// Example to read our own `pubspec.yaml` using the yamlcfg package.

import 'dart:io';

import 'package:yamlcfg/yamlcfg.dart';

void main() {
  final root = YamlCfg.fromFile(File('pubspec.yaml'));

  // Get our project name by retrieving a simple String field.
  final name = root.get<String>('name');
  stdout.writeln('name: $name');

  // Get our SDK version by digging into our environment field, then retrieving
  // the sdk variable.
  final sdk = root.into('environment').get<String>('sdk');
  stdout.writeln('sdk: $sdk');

  // Fallback to a default value if we try to retrieve a non-existent field.
  final nonexistent = root.get<String>('nonexistent', () => '<missing>');
  stdout.writeln('nonexistent: $nonexistent');
}
