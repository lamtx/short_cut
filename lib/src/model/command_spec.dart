import 'package:args/command_runner.dart' as runner;
import 'package:meta/meta.dart';

import '../built_in_shell.dart';
import 'condition.dart';

@sealed
abstract class CommandSpec {
  /// Description of this command, included in Usage
  /// See [runner.Command.description]
  String get desc;
}

class Command implements CommandSpec {
  const Command({
    required this.desc,
    required this.script,
    this.conditions = const [],
    this.params = const {},
  });

  /// Description of this script, used for Usage.
  @override
  final String desc;

  /// List of shell commands or built-in commands defined in [builtInShell]
  /// Named arguments are defined by {{string}} and trailing arguments are defined by {{number}},
  /// which `number` is the 1-index of trailing arguments.
  final List<String> script;

  /// Pre-conditions before running this script.
  final List<Condition> conditions;

  /// Map of argument name and description.
  final Map<String, String> params;
}

class SubCommand implements CommandSpec {
  const SubCommand({
    required this.desc,
    required this.cmd,
  });

  /// Description of this command.
  @override
  final String desc;

  /// Sub-commands
  final Map<String, CommandSpec> cmd;
}
