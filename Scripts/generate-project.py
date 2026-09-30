#!/usr/bin/env python3
"""Add new Swift sources to the checked-in Xcode project without replacing user settings.

The historical script recreated the project, overwriting signing and Xcode edits.
This synchronizer only adds missing file references, folder groups and source entries.
Existing build settings, configurations, capabilities, targets and schemes are retained.
"""
import hashlib
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parent.parent
PROJECT = ROOT / 'Muehlenstein.xcodeproj/project.pbxproj'


def identity(name):
    return hashlib.sha256(name.encode()).hexdigest()[:24].upper()


def synchronize(project, root):
    objects = project['objects']
    main = objects[project['rootObject']]['mainGroup']
    groups = {'': main}
    references = {}

    def walk(key, parent):
        item = objects[key]
        if item['isa'] == 'PBXGroup':
            path = str(Path(parent) / item.get('path', ''))
            if path == '.': path = ''
            groups[path] = key
            for child in item['children']: walk(child, path)
        elif item['isa'] == 'PBXFileReference' and item.get('sourceTree') == '<group>':
            references[str(Path(parent) / item['path'])] = key
    walk(main, '')

    def folder(path):
        if path not in groups:
            parent_path = Path(path).parent.as_posix()
            parent = folder('' if parent_path == '.' else parent_path)
            key = identity('folder:' + path)
            objects[key] = {'isa': 'PBXGroup', 'path': Path(path).name, 'sourceTree': '<group>', 'children': []}
            objects[parent]['children'].append(key)
            groups[path] = key
        return groups[path]

    targets = {objects[k]['name']: objects[k] for k in objects[project['rootObject']]['targets']}
    sources = [(p, 'Muehlenstein') for p in sorted((root / 'App').rglob('*.swift'))]
    sources += [(root / 'Tests/GameStoreTests.swift', 'MuehlensteinTests'),
                (root / 'Tests/MuehlensteinUITests.swift', 'MuehlensteinUITests')]
    for file, target in sources:
        path = file.relative_to(root).as_posix()
        if path not in references:
            parent = folder(str(Path(path).parent))
            ref = identity('file:' + path)
            objects[ref] = {'isa': 'PBXFileReference', 'lastKnownFileType': 'sourcecode.swift',
                            'path': file.name, 'sourceTree': '<group>'}
            objects[parent]['children'].append(ref)
            references[path] = ref
        ref = references[path]
        phase = next(objects[k] for k in targets[target]['buildPhases'] if objects[k]['isa'] == 'PBXSourcesBuildPhase')
        if not any(objects[k]['fileRef'] == ref for k in phase['files']):
            key = identity('build:' + path)
            objects[key] = {'isa': 'PBXBuildFile', 'fileRef': ref}
            phase['files'].append(key)
    return project


if __name__ == '__main__':
    if not PROJECT.exists():
        raise SystemExit('Restore the checked-in Muehlenstein.xcodeproj; this script does not recreate project settings.')
    old = json.loads(subprocess.check_output(['plutil', '-convert', 'json', '-o', '-', str(PROJECT)]))
    before = json.dumps(old, sort_keys=True)
    updated = synchronize(old, ROOT)
    if json.dumps(updated, sort_keys=True) != before:
        # Xcode accepts XML plists; retain standard OpenStep formatting when no write is needed.
        import plistlib
        PROJECT.write_bytes(plistlib.dumps(updated, sort_keys=False))
        print('Added missing source references; existing project settings preserved.')
    else:
        print('All sources are already present; project left unchanged.')
