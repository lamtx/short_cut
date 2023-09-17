import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:charcode/ascii.dart';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'app_exception.dart';

typedef VoidCallback = void Function();
typedef AsyncCallback = FutureOr<void> Function();

Future<void> shell(String command) async {
  final args = command.split(" ");
  final result = await Process.run(
    args.first,
    args.skip(1).toList(growable: false),
    stderrEncoding: utf8,
  );
  if (result.exitCode != 0) {
    error(result.errorResult());
  }
}



extension on ProcessResult {
  String errorResult() {
    return decode(this.stderr) ?? decode(this.stdout) ?? "";
  }

  String? decode(Object? s) {
    if (s is String) {
      return s.isEmpty ? null : s;
    }
    if (s is List<int>) {
      return utf8.decode(s);
    }
    return null;
  }
}

String plural(
  int count, {
  required String Function(int count) other,
  String Function(int count)? one,
}) =>
    count == 1 ? (one ?? other)(count) : other(count);

bool isDigit(String value) =>
    value.codeUnits.every((code) => $0 <= code && code <= $9);
