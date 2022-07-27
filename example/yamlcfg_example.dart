// Example to read our own `pubspec.yaml` using the yamlcfg package.

import 'dart:io';

import 'package:yamlcfg/yamlcfg.dart';

void main() {
  final root = YamlCfg.fromFile(File('pubspec.yaml'));

  // Get our project name.
  final name = root.get<String>('name');
  stdout.writeln('name: $name');
}
