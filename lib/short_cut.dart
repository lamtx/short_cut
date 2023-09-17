import 'dart:io';

import 'package:args/command_runner.dart';

import 'src/cmd.dart';
import 'src/service/command_factory.dart';

void main(List<String> arguments) {
  final runner = CommandRunner<void>("tbs", "Shortcut for commands");
  for (final e in cmd.entries) {
    runner.addCommand(createCommand(e.value, e.key));
  }
  // ignore: inference_failure_on_untyped_parameter
  runner.run(arguments).catchError((error) {
    // ignore: avoid_print
    print(error);
    exit(64);
  });
}
