import 'package:args/command_runner.dart' as runner;

import '../model/command_spec.dart';
import 'parsed_task.dart';
import 'script_command.dart';

runner.Command<void> createCommand(CommandSpec spec, String name) {
  if (spec is Command) {
    return ScriptCommand(
      name: name,
      description: spec.desc,
      tasks: spec.script.map(ParsedTask.parse).toList(),
      conditions: spec.conditions,
      paramSpec: spec.params,
    );
  } else if (spec is SubCommand) {
    return _SubCommand(
      name: name,
      description: spec.desc,
      children: spec.cmd.entries.map((e) => createCommand(e.value, e.key)),
    );
  } else {
    throw StateError("Sealed class exhausted");
  }
}

class _SubCommand extends runner.Command<void> {
  _SubCommand({
    required this.name,
    required this.description,
    required Iterable<runner.Command<void>> children,
  }) {
    for (final command in children) {
      addSubcommand(command);
    }
  }

  @override
  final String description;

  @override
  final String name;
}
