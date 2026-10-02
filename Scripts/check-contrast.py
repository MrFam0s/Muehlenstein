#!/usr/bin/env python3
"""Check semantic sRGB colors, including composited selection fills.

Uses WCAG relative luminance; native translucent controls also require screenshot
review. This checks color roles, not every rendered pixel or full accessibility.
"""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / 'App/Resources/Assets.xcassets'


def asset(name, mode):
    entries = json.loads((ASSETS / f'{name}.colorset/Contents.json').read_text())['colors']
    for entry in entries:
        dark = {'appearance': 'luminosity', 'value': 'dark'} in entry.get('appearances', [])
        if dark == (mode == 'dark'):
            values = entry['color']['components']
            assert entry['color']['color-space'] == 'srgb'
            assert float(values['alpha']) == 1
            return tuple(float(values[key]) for key in ('red', 'green', 'blue'))
    raise ValueError(f'Missing {mode} color: {name}')


def luminance(rgb):
    return sum(weight * (value / 12.92 if value <= .04045 else ((value + .055) / 1.055) ** 2.4)
               for weight, value in zip((.2126, .7152, .0722), rgb))


def contrast(first, second):
    low, high = sorted((luminance(first), luminance(second)))
    return (high + .05) / (low + .05)


def composite(foreground, background, alpha):
    return tuple(alpha * first + (1 - alpha) * second for first, second in zip(foreground, background))


def audit():
    rows = []
    for accent in ('AccentColor', 'Accent-forest', 'Accent-aubergine', 'Accent-terracotta', 'Accent-petrol', 'Accent-rose'):
        for mode in ('light', 'dark'):
            def add(role, foreground, background, minimum):
                ratio = contrast(foreground, background)
                rows.append(dict(palette=accent, appearance=mode, role=role, ratio=ratio, minimum=minimum, passes=ratio >= minimum))
            def c(name): return asset(accent if name == 'AccentColor' else name, mode)
            for surface in ('Limestone', 'BoardSurface'):
                for text in ('Ink', 'QuietInk', 'AccentColor'):
                    add(f'{text} / {surface}', c(text), c(surface), 4.5)
                add(f'Stone edge / {surface}', c('StoneEdge'), c(surface), 3)
            add('Primary action text', c('AccentContent'), c('AccentColor'), 4.5)
            for opacity in (.12, .13):
                add(f'Selected label / fill {opacity}', c('AccentColor'),
                    composite(c('AccentColor'), c('Limestone'), opacity), 4.5)
            add('Board lines / board', c('BoardLine'), c('BoardSurface'), 3)
            add('Move paths, rings and empty targets / board', c('AccentColor'), c('BoardSurface'), 3)
            for side in ('White', 'Black'):
                for endpoint in ('Top', 'Bottom'):
                    add(f'{side} stone marker / {endpoint}', asset(accent, 'light' if side == 'White' else 'dark'), c(side + 'Stone' + endpoint), 3)
    return rows


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--json', type=Path)
    args = parser.parse_args()
    rows = audit()
    result = {'method': 'WCAG sRGB relative luminance; 4.5:1 text, 3:1 meaningful graphics',
              'scope': 'Semantic color roles. Selected fills composited over Limestone. Stone gradients have monotonic channels, so both endpoints bound the marker contrast. Excludes native system materials and disabled controls; these need visual review.',
              'checks': rows}
    if args.json:
        args.json.parent.mkdir(parents=True, exist_ok=True)
        args.json.write_text(json.dumps(result, indent=2) + '\n')
    for row in rows:
        print(f"{'PASS' if row['passes'] else 'FAIL'} {row['palette']:18} {row['appearance']:5} {row['ratio']:5.2f}:1 >= {row['minimum']} {row['role']}")
    raise SystemExit(0 if all(row['passes'] for row in rows) else 1)
