# yamlcfg

A type-safe configuration file parser with support for YAML notation.

## Features

* Lightweight and fast
* Type-safe
* Fallback handlers
* Readable and few exceptions
* Versatile input formats

## Getting started

Add `yamlcfg` to your project with the command `dart pub add yamlcfg`.

## Usage

To use `yamlcfg`, simply create a new `YamlCfg`. The constructor takes a `YamlMap`, but a file can be provided via
the `YamlCfg.fromFile` factory, or a string can be provided via the `YamlCfg.fromString` factory.

From there, the usage is quite simple. To retrieve the value of a field, use the `get` method, providing a type to check
against. For example:

```dart

final yamlCfg = YamlCfg.fromFile('pubspec.yaml');
final name = yamlCfg.get<String>('name');
```

If the specified field does not exist, a `MissingFieldException` is thrown. If the field **does** exist,
but the field is not of the specified type, a `TypeMismatchException` is thrown. An `onFallback` handler can be given
to return a fallback value and avoid a `MissingFieldException`. For example:

```dart

final yamlCfg = YamlCfg.fromFile('pubspec.yaml');
final name = yamlCfg.get<String>('does-not-exist', () => 'backup-name');
```

To dig deeper in the YAML tree, use `get` but specify the type as `YamlCfg`. Alternatively, use the wrapper
method `into` to accomplish the same thing. For example:

```dart

final yamlCfg = YamlCfg.fromFile('pubspec.yaml');
final testViaGet = yamlCfg.get<YamlCfg>('dev_dependencies').get<String>('test');

// or...

final testViaInto = yamlCfg.into('dev_dependencies').get<String>('test');
```
