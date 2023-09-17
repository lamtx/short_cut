import 'dart:io';

import '../misc/app_exception.dart';

abstract class Condition {
  const factory Condition.fileExists(String file) = _FileExistCondition;

  void check();
}

class _FileExistCondition implements Condition {
  const _FileExistCondition(this.file);

  final String file;

  @override
  void check() {
    if (!File(file).existsSync()) {
      error("File `$file` does not exist.");
    }
  }
}
