#!/usr/bin/env python3
# SPDX-License-Identifier: AGPL-3.0-or-later
"""Extract only the authored NMM oracle; do not import named/learned openings."""
import argparse
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / 'Engine/vendor/Sanmill/src/ui/flutter_app/tool/mill_opening_book_oracle_source.dart'
TARGET = ROOT / 'Engine/data/nmm-opening-book.json'


def render():
    relative = str(SOURCE.relative_to(ROOT / 'Engine/vendor/Sanmill'))
    hashes = json.loads((ROOT / 'Engine/UPSTREAM_SHA256.json').read_text())
    if hashlib.sha256(SOURCE.read_bytes()).hexdigest() != hashes[relative]:
        raise ValueError('Opening source differs from the pinned upstream import')
    text = SOURCE.read_text().split('nineMensMorrisCanonicalOpeningBook =', 1)[1]
    text = text.split('Map<String, List<String>> elFiljaCanonicalOpeningBook', 1)[0]
    # FEN strings contain slash/asterisk sequences, so preserve quoted tokens.
    text = re.sub(r'"(?:\\.|[^"\\])*"|/\*.*?\*/|//[^\n]*',
                  lambda match: match[0] if match[0].startswith('"') else '', text, flags=re.S)
    oracle = {}
    for fen, tokens in re.findall(r'"([^"\n]+)":\s*<String>\[(.*?)\]', text, re.S):
        if fen in oracle:
            raise ValueError(f'Duplicate key: {fen}')
        oracle[fen] = json.loads('[' + tokens.strip().rstrip(',') + ']')
    if len(oracle) != 109 or sum(map(len, oracle.values())) != 437:
        raise ValueError('Unexpected source coverage; review the upstream change')
    return json.dumps(dict(schemaVersion=1, variant='nmm', symmetry='ring16', oracle=oracle),
                      indent=2, ensure_ascii=False) + '\n'


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    content = render()
    if args.check:
        if not TARGET.exists() or TARGET.read_text() != content:
            raise SystemExit('Opening-book asset is stale; run this script without --check')
    else:
        TARGET.parent.mkdir(parents=True, exist_ok=True)
        TARGET.write_text(content)
    print(f'Opening book: 109 positions, 437 candidates, {len(content.encode())} bytes')
