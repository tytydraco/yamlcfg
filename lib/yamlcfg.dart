import 'dart:io';

import 'package:yaml/yaml.dart';

/// A type-safe configuration file parser with support for YAML notation.
class YamlCfg {
  /// Creates a new [YamlCfg] given a [yamlMap].
  const YamlCfg(this.yamlMap);

  /// Creates a new [YamlCfg] given some [content] data.
  ///
  /// Throws an [ArgumentError] if:
  ///   * [content] does not parse to a [YamlMap]
  ///   * [content] parses to null
  factory YamlCfg.fromString(String content) {
    final yamlMap = loadYaml(content);

    // Reject bad content.
    if (yamlMap is! YamlMap?) {
      throw ArgumentError(
        'Content contains invalid YAML',
        'content',
      );
    }

    // Reject null maps.
    if (yamlMap == null) {
      throw ArgumentError('Map must not be null', 'content');
    }

    return YamlCfg(yamlMap);
  }

  /// Creates a new [YamlCfg] given some input [file]. This constructor blocks
  /// until the [file] contents are read. Calls [YamlCfg.fromString] constructor
  /// internally.
  ///
  /// Throws an [ArgumentError] if the [file] is missing.
  factory YamlCfg.fromFile(File file) {
    // Reject missing files.
    if (!file.existsSync()) throw ArgumentError('File not found', file.path);

    final fileString = file.readAsStringSync();
    return YamlCfg.fromString(fileString);
  }

  /// The [YamlMap] to wrap and parse.
  final YamlMap yamlMap;

  /// Returns the [String] representation of the internal [yamlMap].
  @override
  String toString() => yamlMap.toString();

  /// Retrieve a field of type [T] given a [name]. If it is missing, use the
  /// result of the [onFallback] handler instead.
  ///
  /// If [T] is a [YamlCfg], then safely wrap the retrieved map as a new
  /// [YamlCfg] for further processing.
  ///
  /// Throws an [ArgumentError] if:
  ///   * Field is not a key in [yamlMap] and [onFallback] is null
  ///   * Field value is not of type [T]
  T get<T>(String name, [T Function()? onFallback]) {
    var fieldValue = yamlMap[name];

    // Reject missing fields unless a handler was specified.
    if (!yamlMap.containsKey(name)) {
      if (onFallback != null) {
        fieldValue = onFallback();
      } else {
        throw ArgumentError('Missing field without fallback handler', name);
      }
    }

    // Consider wrapping as new config object.
    if (T == YamlCfg) return YamlCfg(fieldValue as YamlMap) as T;

    // Reject mismatching field types.
    if (fieldValue is! T) {
      throw ArgumentError(
        'Field type mismatch: $T != ${fieldValue.runtimeType}',
        name,
      );
    }

    return fieldValue;
  }

  /// Wrap a [YamlMap] field with a [YamlCfg] given a [name]. If it is missing,
  /// use the result of the [onFallback] handler instead.
  ///
  /// Wrapper around [YamlCfg.get] with the assumed type of [YamlCfg].
  YamlCfg into(String name, [YamlCfg Function()? onFallback]) =>
      get<YamlCfg>(name, onFallback);
}
