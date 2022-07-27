import 'package:yaml/yaml.dart';

/// A type-safe configuration file parser with support for YAML notation.
class YamlCfg {
  /// Creates a new [YamlCfg] given some [content] data.
  YamlCfg(this.content) {
    final _unsafeYamlMap = loadYaml(content) as YamlMap?;
    if (_unsafeYamlMap == null) {
      throw ArgumentError(
        'No content given',
        'content',
      );
    }

    _yamlMap = _unsafeYamlMap;
  }

  /// A string representation of the YAML file's content.
  final String content;

  /// A [YamlMap] generated from the [content].
  late final YamlMap _yamlMap;

  /// Retrieve a field of type [T] given a [name].
  T get<T>(String name) {
    final fieldValue = _yamlMap[name];

    // Reject missing fields.
    if (fieldValue == null) {
      throw ArgumentError('No field found', name);
    }

    // Reject mismatching field types.
    if (fieldValue is! T) {
      throw ArgumentError(
        'Field type mismatch; $T != ${fieldValue.runtimeType}',
        name,
      );
    }

    return fieldValue;
  }
}
