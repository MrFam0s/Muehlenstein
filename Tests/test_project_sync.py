"""The project synchronizer must retain edits made in Xcode."""
import copy
import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location('sync', ROOT / 'Scripts/generate-project.py')
sync = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sync)

class ProjectSyncTests(unittest.TestCase):
    def test_localizations_join_resource_groups_without_changing_build_settings(self):
        project = json.loads(subprocess.check_output(['plutil', '-convert', 'json', '-o', '-', str(ROOT / 'Muehlenstein.xcodeproj/project.pbxproj')]))
        before = copy.deepcopy(project)
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            locale = root / 'App/Resources/test.lproj'
            locale.mkdir(parents=True)
            for name in ['Localizable.strings', 'InfoPlist.strings']:
                (locale / name).write_text('"example" = "example";\n')
            result = sync.synchronize(project, root)
            for key, value in before['objects'].items():
                if value['isa'] not in ['PBXProject', 'PBXVariantGroup', 'PBXGroup', 'PBXSourcesBuildPhase']:
                    self.assertEqual(result['objects'][key], value)
            for name in ['Localizable.strings', 'InfoPlist.strings']:
                group = next(v for v in result['objects'].values() if v['isa'] == 'PBXVariantGroup' and v['name'] == name)
                paths = [result['objects'][key]['path'] for key in group['children']]
                self.assertEqual(paths.count(f'test.lproj/{name}'), 1)
            self.assertIn('test', result['objects'][result['rootObject']]['knownRegions'])
            first = copy.deepcopy(result)
            self.assertEqual(sync.synchronize(result, root), first)

    def test_new_sources_preserve_custom_settings_and_existing_references(self):
        project = json.loads(subprocess.check_output(['plutil', '-convert', 'json', '-o', '-', str(ROOT / 'Muehlenstein.xcodeproj/project.pbxproj')]))
        configs = {k: v for k, v in project['objects'].items() if v['isa'] == 'XCBuildConfiguration'}
        for config in configs.values():
            config['buildSettings'].update(DEVELOPMENT_TEAM='TESTTEAM99', PRODUCT_BUNDLE_IDENTIFIER='org.example.custom', CODE_SIGN_ENTITLEMENTS='Custom.entitlements')
        before = copy.deepcopy(project)
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            new = root / 'App/Future/Feature.swift'
            new.parent.mkdir(parents=True)
            new.write_text('import SwiftUI\n')
            result = sync.synchronize(project, root)
            for key, value in before['objects'].items():
                if value['isa'] not in ['PBXGroup', 'PBXSourcesBuildPhase']:
                    self.assertEqual(result['objects'][key], value)
            first = copy.deepcopy(result)
            self.assertEqual(sync.synchronize(result, root), first)
            self.assertTrue(any(v.get('path') == 'Feature.swift' for v in result['objects'].values()))

if __name__ == '__main__': unittest.main()
