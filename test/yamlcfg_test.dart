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

    test('Get field as int', () {
      expect(
        YamlCfg.fromString('test: 5').field<int>('test'),
        5,
      );
    });

    test('Get field as YamlMap', () {
      expect(
        YamlCfg.fromString('test:\n  val: 1').field<YamlMap>('test'),
        YamlMap.wrap({'val': 1}),
      );
    });

    test('Get field as YamlCfg', () {
      expect(
        YamlCfg.fromString('test:\n  val: 1').config('test').yamlMap,
        YamlMap.wrap({'val': 1}),
      );
    });

    test('Get inner field as int', () {
      expect(
        YamlCfg.fromString('test:\n  val: 1').config('test').field<int>('val'),
        1,
      );
    });

    test('Get field with wrong type', () {
      expect(
        () => YamlCfg.fromString('test: 5').field<String>('test'),
        throwsArgumentError,
      );
    });
  });
}
