import 'package:test/test.dart';
import 'package:yaml/yaml.dart';
import 'package:yamlcfg/yamlcfg.dart';

void main() {
  group('YamlCfg', () {
    test('Empty YAML', () {
      expect(() => YamlCfg(''), throwsArgumentError);
    });

    test('Get field as int', () {
      expect(YamlCfg('test: 5').get<int>('test'), 5);
    });

    test('Get field as YamlMap', () {
      expect(
        YamlCfg('test:\n  val: 1').get<YamlMap>('test'),
        YamlMap.wrap({'val': 1}),
      );
    });

    test('Get field with wrong type', () {
      expect(
        () => YamlCfg('test: 5').get<String>('test'),
        throwsArgumentError,
      );
    });
  });
}
