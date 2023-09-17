import 'dart:io';

/// Create a new directory
void mkdir(String dir) {
  Directory(dir).createSync();
}
