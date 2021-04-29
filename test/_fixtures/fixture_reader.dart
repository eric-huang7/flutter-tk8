import 'dart:convert';
import 'dart:io';

String fixture(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  return File('$dir/test/_fixtures/$name').readAsStringSync();
}

Map<String, dynamic> fixtureAsMap(String name) => json.decode(fixture(name));
