#!/usr/bin/env python3
"""Add sources and localizations without replacing user settings.

The historical script recreated the project, overwriting signing and Xcode edits.
This synchronizer adds missing source and localization references and folder groups.
Existing build settings, configurations, capabilities, targets and schemes are retained.
"""
import hashlib
import json
import plistlib
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

    # The privacy manifest must be at the root of the app bundle, not nested
    # inside the Legal folder reference. Preserve all existing target settings.
    path = 'App/Resources/PrivacyInfo.xcprivacy'
    if (root / path).exists():
        if path not in references:
            parent = folder('App/Resources')
            ref = identity('file:' + path)
            objects[ref] = {'isa': 'PBXFileReference', 'lastKnownFileType': 'text.xml',
                            'path': 'PrivacyInfo.xcprivacy', 'sourceTree': '<group>'}
            objects[parent]['children'].append(ref)
            references[path] = ref
        ref = references[path]
        phase = next(objects[k] for k in targets['Muehlenstein']['buildPhases']
                     if objects[k]['isa'] == 'PBXResourcesBuildPhase')
        if not any(objects[k]['fileRef'] == ref for k in phase['files']):
            key = identity('build:' + path)
            objects[key] = {'isa': 'PBXBuildFile', 'fileRef': ref}
            phase['files'].append(key)
    # Localized files belong to the existing variant groups, which are already
    # in the app's resource phase. Keep signing and all other project settings.
    regions = objects[project['rootObject']]['knownRegions']
    resource_group = folder('App/Resources')
    for name in ['Localizable.strings', 'InfoPlist.strings']:
        variants = [objects[key] for key in objects[resource_group]['children']
                    if objects[key]['isa'] == 'PBXVariantGroup' and objects[key].get('name') == name]
        files = sorted((root / 'App/Resources').glob(f'*.lproj/{name}'))
        if files and len(variants) != 1:
            raise ValueError(f'Expected one existing resource variant group for {name}')
        for file in files:
            group = variants[0]
            lang = file.parent.stem
            path = f'{file.parent.name}/{name}'
            if not any(objects[key].get('path') == path for key in group['children']):
                key = identity('localization:' + path)
                objects[key] = {'isa': 'PBXFileReference', 'lastKnownFileType': 'text.plist.strings',
                                'name': lang, 'path': path, 'sourceTree': '<group>'}
                group['children'].append(key)
            if lang not in regions: regions.append(lang)
    return project


if __name__ == '__main__':
    if not PROJECT.exists():
        raise SystemExit('Restore the checked-in Muehlenstein.xcodeproj; this script does not recreate project settings.')
    try:
        old = plistlib.loads(PROJECT.read_bytes())
    except plistlib.InvalidFileException:
        old = json.loads(subprocess.check_output(['plutil', '-convert', 'json', '-o', '-', str(PROJECT)]))
    before = json.dumps(old, sort_keys=True)
    updated = synchronize(old, ROOT)
    if json.dumps(updated, sort_keys=True) != before:
        # Xcode accepts XML plists; retain standard OpenStep formatting when no write is needed.
        PROJECT.write_bytes(plistlib.dumps(updated, sort_keys=False))
        print('Added missing source/localization references; existing project settings preserved.')
    else:
        print('All sources and localizations are present; project left unchanged.')
