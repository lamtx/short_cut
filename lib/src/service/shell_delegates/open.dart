import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

/// Open this [file] by the default app.
void open(String file) {
  shellExecute('open', file);
}

int shellExecute(String operation, String file) {
  // Allocate pointers to Utf8 arrays containing the command arguments.
  final operationP = operation.toNativeUtf16();
  final fileP = file.toNativeUtf16();
  // ignore: constant_identifier_names
  const SW_SHOWNORMAL = 1;

  // Invoke the command, and free the pointers.
  final result = ShellExecute(
      nullptr.address, operationP, fileP, nullptr, nullptr, SW_SHOWNORMAL);
  free(operationP);
  free(fileP);

  return result;
}
