// Example to read our own `pubspec.yaml` using the yamlcfg package.

import 'dart:io';

import 'package:yamlcfg/yamlcfg.dart';

void main() {
  final pubspecYamlText = File('pubspec.yaml').readAsStringSync();
  final root = YamlCfg.fromString(pubspecYamlText);

  // Get our project name.
  final name = root.get<String>('name');
  stdout.writeln('name: $name');
}
