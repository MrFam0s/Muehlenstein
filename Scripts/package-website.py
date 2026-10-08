#!/usr/bin/env python3
"""Assemble a local, CMS-neutral website handoff; never publishes or edits the app."""
import argparse
import hashlib
import html
import json
from pathlib import Path
import re
import shutil
import zipfile

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
COPY = ROOT / 'Website'


def read_json(path):
    return json.loads(path.read_text())


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding='utf-8')


def dump(path, value):
    write(path, json.dumps(value, ensure_ascii=False, indent=2) + '\n')


def rich(text):
    """Escape all copy; make only explicit HTTPS URLs and the support email links."""
    escaped = html.escape(text)
    escaped = re.sub(r'https://[^\s<]+', lambda m: '<a href="' + m[0].rstrip('.,;') + '">' +
                     m[0].rstrip('.,;') + '</a>' + m[0][len(m[0].rstrip('.,;')):], escaped)
    return escaped.replace('info@fabianamos.com', '<a href="mailto:info@fabianamos.com">info@fabianamos.com</a>')


def sections_html(title, intro, sections):
    result = f'<article><h1>{html.escape(title)}</h1>\n'
    if intro:
        result += f'<p>{rich(intro)}</p>\n'
    for heading, paragraphs in sections:
        result += f'<section><h2>{html.escape(heading)}</h2>\n'
        result += ''.join(f'<p>{rich(p)}</p>\n' for p in paragraphs)
        result += '</section>\n'
    return result + '</article>\n'


def sections_text(title, intro, sections):
    parts = [title, intro] if intro else [title]
    for heading, paragraphs in sections:
        parts.extend([heading, *paragraphs])
    return '\n\n'.join(parts) + '\n'


STYLE = '''
:root{color-scheme:light;--paper:#f6f3eb;--ink:#263337;--accent:#4a6074;--line:#d7d3c8}
*{box-sizing:border-box}body{margin:0;background:var(--paper);color:var(--ink);font:16px/1.65 system-ui,sans-serif}
main{max-width:1120px;margin:auto;padding:48px 32px}h1,h2,h3{line-height:1.16}h1{font:clamp(34px,6vw,64px)/1.1 Georgia,serif;letter-spacing:-.035em;margin:18px 0}
h2{font-size:26px;margin-top:40px}h3{font-size:18px}p{max-width:78ch}a{color:var(--accent);text-underline-offset:4px}a:focus-visible{outline:3px solid var(--accent);outline-offset:5px}
.hero{display:flex;gap:28px;align-items:center;padding-bottom:28px;border-bottom:1px solid var(--line)}.icon{width:120px;height:120px;border-radius:26px}
.eyebrow{font-size:12px;letter-spacing:.12em;text-transform:uppercase;color:#596460}.lead{font-size:21px}.muted{color:#596460}
nav{display:flex;flex-wrap:wrap;gap:18px;margin:22px 0}.cards,.gallery{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:20px}
.card{border:1px solid var(--line);border-radius:16px;padding:20px;background:#ffffff70}.gallery figure{margin:0}.gallery img{width:100%;height:auto;display:block;border:1px solid var(--line);border-radius:14px}
figcaption{font-size:14px;line-height:1.45;margin:10px 0 26px}.preview{background:#fff9;padding:20px 28px;border:1px solid var(--line);border-radius:16px}
.preview article h1{font-size:30px}.preview article h2{font-size:20px}details{margin:14px 0}summary{cursor:pointer;font-weight:600;padding:8px 0}
code{overflow-wrap:anywhere}footer{border-top:1px solid var(--line);padding-top:20px;margin-top:40px;font-size:14px}
@media(max-width:700px){main{padding:26px 18px}.hero{gap:18px}.icon{width:76px;height:76px;border-radius:18px}.cards{grid-template-columns:1fr}.gallery{grid-template-columns:1fr 1fr}.preview{padding:16px}}
'''


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    out = args.output.resolve()
    archive = out.with_name(out.name + '.zip')
    if out.exists() or archive.exists():
        raise SystemExit('Choose a new output folder; existing packages are never overwritten.')
    facts = read_json(COPY / 'release-facts.json')
    config = (ROOT / 'Configuration/App.xcconfig').read_text()
    for key, value in [('MARKETING_VERSION', facts['version']), ('CURRENT_PROJECT_VERSION', facts['build'])]:
        if not re.search(r'^' + key + r' = ' + re.escape(value) + r'$', config, re.M):
            raise SystemExit('Update website release facts before exporting a different app version.')
    data = {lang: read_json(COPY / f'{lang}.json') for lang in ['de', 'en']}
    screenshot_source = ROOT / 'Store/Screenshots'
    records = read_json(screenshot_source / 'manifest.json')
    if len(records) != 80 or len({r['path'] for r in records}) != 80:
        raise SystemExit('Expected 80 unique source screenshots.')
    for record in records:
        if sha(screenshot_source / record['path']) != record['sha256']:
            raise SystemExit('Screenshot differs from approved manifest: ' + record['path'])
    out.mkdir(parents=True)
    shutil.copy2(COPY / 'README.txt', out / 'START-HERE.txt')
    dump(out / 'sources/release-facts.json', facts)
    write(out / 'preview.css', STYLE)
    assets = []
    for record in records:
        source = screenshot_source / record['path']
        relative = Path('screenshots/original') / record['path']
        destination = out / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)
        locale, device, filename = Path(record['path']).parts
        screen = Path(filename).stem
        text = {lang: next(g for g in value['gallery'] if g['screen'] == screen) for lang, value in data.items()}
        row = {'original': relative.as_posix(), 'uiLocale': locale, 'device': device,
               'width': record['width'], 'height': record['height'], 'sha256': sha(destination),
               'screen': screen, 'caption': {l: t['caption'] for l, t in text.items()},
               'alt': {l: t['alt'] for l, t in text.items()}, 'web': []}
        with Image.open(source) as image:
            assert image.size == (record['width'], record['height']) and image.mode == 'RGB'
            if locale in ('de-DE', 'en-US'):
                width = 660 if device.startswith('iPhone') else 1032
                height = round(image.height * width / image.width)
                resized = image.resize((width, height), Image.Resampling.LANCZOS)
                for extension in ('png', 'webp'):
                    rel = Path('screenshots/web') / locale / device / (screen + '.' + extension)
                    target = out / rel
                    target.parent.mkdir(parents=True, exist_ok=True)
                    resized.save(target, **({'lossless': True, 'method': 6} if extension == 'webp' else {'optimize': True}))
                    row['web'].append({'path': rel.as_posix(), 'width': width, 'height': height, 'sha256': sha(target)})
        assets.append(row)
    brand = out / 'brand'
    brand.mkdir()
    for variant in ['AppIcon', 'AppIcon-Dark', 'AppIcon-Tinted']:
        shutil.copy2(ROOT / f'App/Resources/Assets.xcassets/AppIcon.appiconset/{variant}.png', brand / f'{variant}.png')
    colors = {}
    for name in ['Limestone', 'BoardSurface', 'Ink', 'QuietInk', 'AccentSlate', 'AccentForest']:
        path = ROOT / f'App/Resources/Assets.xcassets/{name}.colorset/Contents.json'
        if path.exists():
            colors[name] = read_json(path)
    dump(brand / 'colors.json', {'appIcon': {'background': '#EDE8DD', 'accent': '#4A6074', 'darkStone': '#263337'}, 'semanticAssets': colors})
    for source, filename in [('LICENSE', 'AGPL-3.0.txt'), ('APP_STORE_PERMISSION.txt', 'APP_STORE_PERMISSION.txt'),
                             ('App/Resources/Legal/notices.json', 'third-party-notices.json'),
                             ('App/Resources/Legal/Rust-COPYRIGHT-library.html', 'Rust-COPYRIGHT-library.html')]:
        target = out / 'legal' / filename
        target.parent.mkdir(exist_ok=True)
        shutil.copy2(ROOT / source, target)
    # Each deliverable is usable on its own: JSON for a CMS, HTML fragment, plain text.
    for lang, c in data.items():
        dest = out / 'content' / lang
        dump(dest / 'product.json', c)
        sections = [('Beschreibung' if lang == 'de' else 'Description', c['description'])]
        sections += [(f['title'], [f['text']]) for f in c['features']]
        sections += [('Details', [c['footer'], c['price']])]
        product = sections_html(c['headline'], c['intro'], sections)
        write(dest / 'product.html', product)
        write(dest / 'product.txt', sections_text(c['name'], c['card'], [(c['headline'], [c['intro']]), *sections]))
        privacy = c['privacy']
        privacy_sections = [(s['title'], s['paragraphs']) for s in privacy['sections']]
        support = c['support']
        support_sections = [(q['question'], [q['answer']]) for q in support['questions']]
        for key, title, intro, entries in [('privacy', privacy['title'], privacy['intro'], privacy_sections),
                                         ('support', support['title'], support['intro'], support_sections),
                                         ('credits', c['credits']['title'], '', [('', c['credits']['paragraphs'])])]:
            fragment = sections_html(title, intro, entries).replace('<h2></h2>', '')
            write(dest / f'{key}.html', fragment)
            write(dest / f'{key}.txt', sections_text(title, intro, entries))
        locale = 'de-DE' if lang == 'de' else 'en-US'
        preview = f'''<!doctype html><html lang="{lang}"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>{c['name']} · Website-Paket</title><link rel="stylesheet" href="preview.css"></head><body><main>
        <header class="hero"><img class="icon" src="brand/AppIcon.png" width="120" height="120" alt="{c['name']} App-Icon"><div><span class="eyebrow">AmoSystems · Website-Paket · 08.10.2026</span><h1>{c['name']}</h1><p>{c['category']} · 1.3.1 (11)</p></div></header>
        <nav aria-label="Package navigation"><a href="index.html">Deutsch</a><a href="index-en.html">English</a><a href="START-HERE.txt">Integration / Read me</a><a href="asset-manifest.json">Bildverzeichnis</a></nav>
        <p class="lead">{c['card']}</p><p class="muted">{'Lokale Paketvorschau. Die AmoSystems-Webseite wurde nicht verändert.' if lang == 'de' else 'Local package preview. The AmoSystems website has not been changed.'}</p>
        <div class="cards">'''
        for key, title in [('product', 'Produkt / Product'), ('privacy', 'Datenschutz / Privacy'), ('support', 'Support / FAQ')]:
            preview += f'<section class="card"><h3>{title}</h3><a href="content/{lang}/{key}.html">HTML</a> · <a href="content/{lang}/{key}.txt">Text</a></section>'
        preview += '</div><h2>' + ('Empfohlene Bildergalerie' if lang == 'de' else 'Suggested gallery') + '</h2><div class="gallery">'
        for screen in ['01-Game', '03-Setup', '05-Network']:
            g = next(g for g in c['gallery'] if g['screen'] == screen)
            base = f'screenshots/web/{locale}/iPhone-6.9/{screen}'
            preview += f'<figure><a href="screenshots/original/{locale}/iPhone-6.9/{screen}.png"><picture><source srcset="{base}.webp" type="image/webp"><img src="{base}.png" width="660" height="1434" alt="{html.escape(g["alt"])}" loading="lazy"></picture></a><figcaption>{g["caption"]}</figcaption></figure>'
        preview += '</div><details><summary>Weitere Motive / More images · iPhone &amp; iPad</summary><div class="gallery">'
        for device in ['iPhone-6.9', 'iPad-13']:
            for g in c['gallery']:
                w, h = (660, 1434) if device.startswith('iPhone') else (1032, 1376)
                base = f'screenshots/web/{locale}/{device}/{g["screen"]}'
                preview += f'<figure><a href="screenshots/original/{locale}/{device}/{g["screen"]}.png"><img src="{base}.webp" width="{w}" height="{h}" alt="{html.escape(g["alt"])}" loading="lazy"></a><figcaption>{g["caption"]} · {device}</figcaption></figure>'
        preview += '</div></details><h2>Website-Text</h2><div class="preview">' + product + '</div>'
        for key in ['privacy', 'support', 'credits']:
            fragment = (dest / f'{key}.html').read_text()
            preview += f'<details><summary>{c[key]["title"]}</summary><div class="preview">{fragment}</div></details>'
        url = facts['appStoreURL'] if lang == 'de' else facts['internationalAppStoreURL']
        preview += f'<footer><a href="{url}">{c["cta"]}</a> · <a href="content/{lang}/product.json">CMS JSON</a><p>{c["madeIn"]} · © 2026 Fabian Amos / AmoSystems</p></footer></main></body></html>'
        write(out / ('index.html' if lang == 'de' else 'index-en.html'), preview)
    dump(out / 'asset-manifest.json', {'version': facts['version'], 'originals': len(assets), 'screenshots': assets})
    # Provenance is limited to public product sources and file hashes; no release credentials.
    source_paths = ['Website/de.json', 'Website/en.json', 'Website/release-facts.json',
                    'Store/Screenshots/manifest.json', 'Docs/PRIVACY.md', 'Docs/SUPPORT.md',
                    'App/Core/NearbyMatchTransport.swift', 'App/Core/LocalMatchSession.swift',
                    'Scripts/generate-icon.swift', 'Scripts/package-website.py']
    dump(out / 'sources/source-hashes.json', {p: sha(ROOT / p) for p in source_paths})
    files = sorted(p for p in out.rglob('*') if p.is_file())
    write(out / 'checksums.sha256', ''.join(f'{sha(p)}  {p.relative_to(out).as_posix()}\n' for p in files))
    with zipfile.ZipFile(archive, 'x', zipfile.ZIP_DEFLATED) as z:
        for p in sorted(out.rglob('*')):
            if p.is_file():
                z.write(p, (Path(out.name) / p.relative_to(out)).as_posix())
    with zipfile.ZipFile(archive) as z:
        assert z.testzip() is None
    print(json.dumps({'folder': str(out), 'zip': str(archive), 'originalScreenshots': len(assets),
                      'webImages': sum(len(a['web']) for a in assets), 'zipMiB': round(archive.stat().st_size / 1024 ** 2, 2)}, indent=2))


if __name__ == '__main__':
    main()
