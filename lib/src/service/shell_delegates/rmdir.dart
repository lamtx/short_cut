import 'dart:io';

import '../../misc/app_exception.dart';

/// Remove this directory [dir] if it exits.
void rmdir(String dir) {
  final dir = Directory("dir");
  if (dir.existsSync()) {
    if (FileSystemEntity.isDirectorySync("dir")) {
      dir.deleteSync(recursive: true);
    } else {
      error("$dir exists in the current directory. ");
    }
  }
}
