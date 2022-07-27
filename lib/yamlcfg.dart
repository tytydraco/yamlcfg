import 'package:yaml/yaml.dart';

/// A type-safe configuration file parser with support for YAML notation.
class YamlCfg {
  /// Creates a new [YamlCfg] given a [yamlMap].
  YamlCfg(this.yamlMap);

  /// Creates a new [YamlCfg] given some [content] data.
  factory YamlCfg.fromString(String content) {
    final _yamlMap = loadYaml(content);

    // Reject bad content.
    if (_yamlMap is! YamlMap?) {
      throw ArgumentError(
        'Invalid content',
        'content',
      );
    }

    // Reject null maps.
    if (_yamlMap == null) {
      throw ArgumentError(
        'Map must not be null',
        'content',
      );
    }

    return YamlCfg(_yamlMap);
  }

  /// The [YamlMap] to wrap and parse.
  final YamlMap yamlMap;

  /// Retrieve a field of type [T] given a [name].
  T field<T>(String name) {
    final fieldValue = yamlMap[name];

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

  /// Retrieve a field of type [YamlMap] given a [name] and safely wrap it with
  /// a [YamlCfg] for further parsing.
  YamlCfg config(String name) {
    final fieldValue = field<YamlMap>(name);
    return YamlCfg(fieldValue);
  }
}
