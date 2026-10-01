#!/usr/bin/env python3
"""Audit the locked iOS dependency graph and preserve complete license notices.

Run after setup-rust.sh. --check checks the committed artifacts without editing.
Only normal/build edges reachable from our library are included, not dev-only
workspace dependencies. Rust's own notices intentionally cover all platforms.
"""
import argparse
import hashlib
from html.parser import HTMLParser
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parent.parent

def digest(data):
    return hashlib.sha256(data).hexdigest()

class RustNotices(HTMLParser):
    """Keep every text node, adding paragraph boundaries for native reading."""
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.sections = []
        self.title = 'Rust standard library'
        self.parts = []
        self.heading = None
        self.heading_parts = []
        self.in_body = False
    def flush(self):
        text = ''.join(self.parts).strip()
        # Bound TextKit's per-document work while preserving all notice text.
        pieces = []
        while len(text) > 24000:
            end = text.rfind('\n', 0, 24000)
            if end < 12000: end = 24000
            pieces.append(text[:end])
            text = text[end:]
        if text: pieces.append(text)
        for index, piece in enumerate(pieces):
            suffix = f' · {index + 1}/{len(pieces)}' if len(pieces) > 1 else ''
            self.sections.append({'title': self.title + suffix, 'text': piece})
        self.parts = []
    def handle_starttag(self, tag, attrs):
        if tag == 'body': self.in_body = True
        if not self.in_body: return
        if tag in ('h1', 'h2', 'h3'):
            self.flush(); self.heading = tag; self.heading_parts = []
        elif tag in ('p', 'div', 'li', 'pre', 'br', 'summary', 'details'):
            self.parts.append('\n')
    def handle_endtag(self, tag):
        if tag == self.heading:
            self.title = ''.join(self.heading_parts).strip().removeprefix('📦 ')
            self.parts.append(self.title + '\n\n'); self.heading = None
        elif tag == 'body': self.flush(); self.in_body = False
        elif self.in_body and tag in ('p', 'div', 'li', 'pre', 'summary', 'details'):
            self.parts.append('\n')
    def handle_data(self, data):
        if not self.in_body: return
        if self.heading: self.heading_parts.append(data)
        else: self.parts.append(data)

def generate():
    env = dict(os.environ, CARGO_HOME=str(ROOT / '.build/cargo'), RUSTC=str(ROOT / '.build/rust-sysroot/bin/rustc'))
    metadata = json.loads(subprocess.check_output(['cargo', 'metadata', '--manifest-path', str(ROOT / 'Engine/Cargo.toml'),
        '--format-version', '1', '--locked', '--offline', '--filter-platform', 'aarch64-apple-ios'], env=env))
    packages = {p['id']: p for p in metadata['packages']}
    nodes = {p['id']: p for p in metadata['resolve']['nodes']}
    root = next(p['id'] for p in packages.values() if p['name'] == 'muehlenstein-engine')
    reached = set()
    def visit(key, host=False):
        host = host or any('proc-macro' in t['kind'] for t in packages[key]['targets'])
        state = (key, host)
        if state in reached: return
        reached.add(state)
        for dep in nodes[key]['deps']:
            for kind in dep['dep_kinds']:
                if kind['kind'] != 'dev': visit(dep['pkg'], host or kind['kind'] == 'build')
    visit(root)
    entries, inventory = [], []
    for key in sorted({k for k, _ in reached}, key=lambda k: (packages[k]['name'], packages[k]['version'])):
        p = packages[key]
        row = {'name': p['name'], 'version': p['version'], 'license': p['license'],
            'roles': sorted('build' if h else 'runtime' for k, h in reached if k == key)}
        if p['source']:
            folder = Path(p['manifest_path']).parent
            files = sorted(f for f in folder.iterdir() if f.is_file() and any(x in f.name.upper() for x in ('LICENSE', 'COPYRIGHT', 'NOTICE', 'UNLICENSE')))
            if not files or not p['license']: raise SystemExit('Missing license evidence: ' + p['name'])
            row['repository'] = p['repository']
            row['notices'] = {f.name: digest(f.read_bytes()) for f in files}
            row['source'] = f"https://crates.io/crates/{p['name']}/{p['version']}"
            text = f"{p['name']} {p['version']}\n{p['license']}\n{row['source']}\n\n"
            text += '\n\n'.join(f'{f.name}\n\n{f.read_text()}' for f in files)
            entries.append({'title': f"{p['name']} {p['version']}", 'text': text})
        inventory.append(row)
    vendor = ROOT / 'Engine/vendor/Sanmill'
    hashes = json.loads((ROOT / 'Engine/UPSTREAM_SHA256.json').read_text())
    for name, expected in hashes.items():
        path = vendor / name
        if digest(path.read_bytes()) != expected: raise SystemExit('Vendor changed: ' + name)
    readme = (vendor / 'README.upstream.md').read_text()
    terms = readme.split('## Terms of Use', 1)[1].split('\n## ', 1)[0].strip()
    entries.insert(0, {'title': 'Sanmill', 'text': (vendor / 'AUTHORS').read_text() + '\n\nTerms of Use\n\n' + terms})
    rust_path = ROOT / '.build/rust-sysroot/share/doc/rust/COPYRIGHT-library.html'
    rust_html = rust_path.read_bytes()
    parser = RustNotices(); parser.feed(rust_html.decode()); parser.close()
    entries.append({'title': 'Rust 1.98.1 · Standard library', 'children': parser.sections})
    entries.insert(0, {'title': 'Muehlenstein · App Store permission', 'text': (ROOT / 'APP_STORE_PERMISSION.txt').read_text()})
    def assign_ids(items, prefix='license'):
        for n, entry in enumerate(items):
            entry['id'] = f'{prefix}-{n}'
            if 'children' in entry: assign_ids(entry['children'], entry['id'])
    assign_ids(entries)
    inventory = {'target': 'aarch64-apple-ios', 'cargo_lock_sha256': digest((ROOT / 'Engine/Cargo.lock').read_bytes()),
        'sanmill_revision': '8901a06f088bf49a1602fee8686ed25ac5a33925', 'verified_vendor_files': len(hashes),
        'rust_version': '1.98.1', 'rust_library_notices_sha256': digest(rust_html), 'packages': inventory}
    return {ROOT / 'App/Resources/Legal/notices.json': (json.dumps(entries, ensure_ascii=False, indent=2)+'\n').encode(),
        ROOT / 'App/Resources/Legal/Rust-COPYRIGHT-library.html': rust_html,
        ROOT / 'Docs/Licenses/dependencies.json': (json.dumps(inventory, ensure_ascii=False, indent=2)+'\n').encode()}

if __name__ == '__main__':
    parser = argparse.ArgumentParser(); parser.add_argument('--check', action='store_true'); args = parser.parse_args()
    for path, content in generate().items():
        if args.check:
            if not path.exists() or path.read_bytes() != content: raise SystemExit('Outdated notices: ' + str(path.relative_to(ROOT)))
        else:
            path.parent.mkdir(parents=True, exist_ok=True); path.write_bytes(content)
    print('License inventory and complete notices verified.' if args.check else 'License inventory and complete notices generated.')
