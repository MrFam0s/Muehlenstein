#!/usr/bin/env python3
"""Copy original XCTest screenshots into locale/device folders without editing pixels."""
import hashlib
import json
from pathlib import Path
import re
import struct
import sys

ROOT = Path(__file__).resolve().parent.parent
SOURCE = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / '.build/StoreScreenshotAttachments'
TARGET = ROOT / 'Store/Screenshots'
ORDER = {'Game': '01-Game', 'Hint': '02-Hint', 'Setup': '03-Setup', 'Home': '04-Home'}
SIZES = {(1320, 2868): 'iPhone-6.9', (2064, 2752): 'iPad-13'}
rows = []
seen = set()
for test in json.loads((SOURCE / 'manifest.json').read_text()):
    for item in test['attachments']:
        match = re.match(r'Store-(de|en)-\d+-(Home|Setup|Game|Hint)_', item['suggestedHumanReadableName'])
        if not match:
            continue
        if item['isAssociatedWithFailure']:
            raise SystemExit('Refusing screenshots from a failed test.')
        data = (SOURCE / item['exportedFileName']).read_bytes()
        assert data[:8] == b'\x89PNG\r\n\x1a\n'
        width, height, depth, color = struct.unpack('>IIBB', data[16:26])
        assert depth == 8 and color == 2, 'Store screenshots must be RGB without alpha.'
        device = SIZES[(width, height)]
        language, screen = match.groups()
        locale = 'de-DE' if language == 'de' else 'en-US'
        relative = f'{locale}/{device}/{ORDER[screen]}.png'
        assert relative not in seen, 'Duplicate screenshot: ' + relative
        seen.add(relative)
        rows.append((relative, data, {
            'path': relative, 'device': item['deviceName'], 'width': width, 'height': height,
            'sha256': hashlib.sha256(data).hexdigest(),
        }))
assert len(rows) == 16, f'Expected 16 screenshots; got {len(rows)}.'
for relative, data, _ in rows:
    destination = TARGET / relative
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(data)
(TARGET / 'manifest.json').write_text(json.dumps([r for _, _, r in sorted(rows)], indent=2) + '\n')
print('Exported 16 original RGB screenshots; dimensions and hashes verified.')
