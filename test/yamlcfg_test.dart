import 'package:test/test.dart';
import 'package:yaml/yaml.dart';
import 'package:yamlcfg/yamlcfg.dart';

void main() {
  group('YamlCfg', () {
    test('Empty YAML string', () {
      expect(
        () => YamlCfg.fromString(''),
        throwsArgumentError,
      );
    });

    test('Empty YAML map', () {
      expect(
        () => YamlCfg(YamlMap()),
        returnsNormally,
      );
    });

    test('Non-yaml string', () {
      expect(
        () => YamlCfg.fromString('12345'),
        throwsArgumentError,
      );
    });

    test('Missing field as int (get)', () {
      expect(
        () => YamlCfg.fromString('test: 5').get<int>('nothing'),
        throwsArgumentError,
      );
    });

    test('Missing field as int (ask)', () {
      expect(
        YamlCfg.fromString('test: 5').ask<int>('nothing'),
        isNull,
      );
    });

    test('Missing field as int (ask) with specified alt', () {
      expect(
        YamlCfg.fromString('test: 5').ask<int>('nothing', -1),
        -1,
      );
    });

    test('Get field as int', () {
      expect(
        YamlCfg.fromString('test: 5').get<int>('test'),
        5,
      );
    });

    test('Get null field as int?', () {
      expect(
        YamlCfg.fromString('test: ~').get<int?>('test'),
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

    test('Get field with wrong type', () {
      expect(
        () => YamlCfg.fromString('test: 5').get<String>('test'),
        throwsArgumentError,
      );
    });
  });
}
