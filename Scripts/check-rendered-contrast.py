#!/usr/bin/env python3
"""Review inspector-flagged text against sampled screenshot backgrounds.

Requires Pillow. Run after exporting the named screenshots and Findings.txt to
Docs/Contrast/{Simulator,iPhone}. This is a representative pixel measurement,
not a minimum over antialiased edge pixels or every possible glass backdrop.
"""
import hashlib
import importlib.util
import json
import re
from collections import Counter
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location('contrast', ROOT / 'Scripts/check-contrast.py')
contrast = importlib.util.module_from_spec(spec)
spec.loader.exec_module(contrast)
rows = []
for report in sorted((ROOT / 'Docs/Contrast').glob('*/Contrast-*-Findings.txt')):
    mode = report.name.split('-')[1]
    for line in report.read_text().splitlines():
        match = re.match(r'([^:]+): (.*?) · Optional\(\((.*?)\)\)', line)
        if not match:
            raise ValueError(f'Unreviewed finding: {line}')
        screen, label, rectangle = match.groups()
        x, y, width, height = map(float, rectangle.split(','))
        file = report.with_name(f'Contrast-{mode}-{screen}.png')
        image = Image.open(file).convert('RGB')
        # Both recorded devices use @3x; coordinates in the audit are screen points.
        assert image.width in (1170, 1206)
        region = image.crop((int(x * 3), int(y * 3), int((x + width) * 3), int((y + height) * 3)))
        pixels = Counter(getattr(region, 'get_flattened_data', region.getdata)())
        background, count = pixels.most_common(1)[0]
        role = 'AccentColor' if label == 'Fertig' else 'Ink'
        assert label in ('Fertig', 'Abbrechen', '1', '2', '3', '4', '5'), label
        foreground = tuple(round(value * 255) for value in contrast.asset(role, mode))
        ratio = contrast.contrast(tuple(value / 255 for value in foreground), tuple(value / 255 for value in background))
        rows.append(dict(device=report.parent.name, appearance=mode, screen=screen, label=label,
                         screenshot=str(file.relative_to(ROOT)), sha256=hashlib.sha256(file.read_bytes()).hexdigest(),
                         frame_points=[x, y, width, height], scale=3, foreground_rgb=foreground,
                         exact_foreground_pixels=pixels[foreground], dominant_background_rgb=background,
                         dominant_background_pixels=count, sampled_ratio=ratio,
                         passes=pixels[foreground] > 0 and ratio >= 4.5))
result = {'method': 'Exact semantic glyph color verified in the reported frame; WCAG luminance against its most frequent background pixel. Screenshot sRGB, @3x.',
          'limits': 'Representative sample of each inspector finding, not a full pixel minimum, not every possible backdrop. Antialias edge pixels deliberately excluded. Inspector warnings remain in the raw reports.',
          'samples': rows}
(ROOT / 'Docs/Contrast/rendered-text.json').write_text(json.dumps(result, indent=2, ensure_ascii=False) + '\n')
for row in rows:
    print(f"{'PASS' if row['passes'] else 'FAIL'} {row['device']} {row['appearance']} {row['screen']} {row['label']}: {row['sampled_ratio']:.2f}:1 ({row['exact_foreground_pixels']} full-color text pixels)")
raise SystemExit(0 if rows and all(row['passes'] for row in rows) else 1)
