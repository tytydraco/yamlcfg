import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';
import 'package:yamlcfg/yamlcfg.dart';

void main() {
  group('Invalid configs', () {
    test('Empty YAML string', () {
      expect(
        () => YamlCfg.fromString(''),
        throwsArgumentError,
      );
    });

    test('Non-yaml string', () {
      expect(
        () => YamlCfg.fromString('bad'),
        throwsArgumentError,
      );
    });

    test('Missing file', () {
      expect(
        () => YamlCfg.fromFile(File('does-not-exist-ever')),
        throwsArgumentError,
      );
    });

    test('Missing field as int (get)', () {
      expect(
        () => YamlCfg.fromString('val: 1').get<int>('nothing'),
        throwsArgumentError,
      );
    });

    test('Get field with wrong type', () {
      expect(
        () => YamlCfg.fromString('val: 1').get<String>('test'),
        throwsArgumentError,
      );
    });
  });

  group('Valid configs', () {
    test('Empty YAML map', () {
      expect(
        () => YamlCfg(YamlMap()),
        returnsNormally,
      );
    });

    test('Missing field as int (ask)', () {
      expect(
        YamlCfg.fromString('val: 1').ask<int>('nothing'),
        isNull,
      );
    });

    test('Missing field as int (ask) with specified alt', () {
      expect(
        YamlCfg.fromString('val: 1').ask<int>('missing', -1),
        -1,
      );
    });

    test('Get field as int', () {
      expect(
        YamlCfg.fromString('val: 1').get<int>('val'),
        1,
      );
    });

    test('Get null field as int?', () {
      expect(
        YamlCfg.fromString('val: null').get<int?>('val'),
        isNull,
      );
    });

    test('Get field as YamlMap', () {
      expect(
        YamlCfg.fromString('test:\n  val: 1').get<YamlMap>('test'),
        YamlMap.wrap({'val': 1}),
      );
    });

    test('Get field as YamlCfg', () {
      expect(
        YamlCfg.fromString('test:\n  val: 1').get<YamlCfg>('test').yamlMap,
        YamlMap.wrap({'val': 1}),
      );
    });

    test('Get inner field as int', () {
      expect(
        YamlCfg.fromString('test:\n  val: 1')
            .get<YamlCfg>('test')
            .get<int>('val'),
        1,
      );
    });

    test('Get field from file as int', () {
      final tempDir = Directory.systemTemp.createTempSync();
      final tempFile = File('${tempDir.path}/temp')
        ..createSync()
        ..writeAsStringSync('val: 1');

      expect(
        YamlCfg.fromFile(tempFile).get<int>('val'),
        1,
      );

      tempDir.deleteSync(recursive: true);
    });
  });
}
