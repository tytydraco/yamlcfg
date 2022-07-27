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

    test('Missing field as int', () {
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

    test('Missing field via into', () {
      expect(
        () => YamlCfg.fromString('val: 1').into('nothing'),
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

    test('Missing field as int with handler', () {
      expect(
        YamlCfg.fromString('val: 1').get<int?>('nothing', () => null),
        isNull,
      );
    });

    test('Missing field as int with handler', () {
      expect(
        YamlCfg.fromString('val: 1').get<int>('missing', () => -1),
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

    test('Into field as YamlCfg', () {
      expect(
        YamlCfg.fromString('test:\n  val: 1').into('test').yamlMap,
        YamlMap.wrap({'val': 1}),
      );
    });

    test('Get inner field as int', () {
      expect(
        YamlCfg.fromString('test:\n  val: 1').into('test').get<int>('val'),
        1,
      );
    });

    test('Get inner field as int with missing outer field with fallback', () {
      expect(
        YamlCfg.fromString('test:\n  val: 1')
            .into(
              'test',
              () => YamlCfg.fromString('val: 1'),
            )
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
