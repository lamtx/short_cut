import 'dart:math';

import 'package:args/command_runner.dart';

import '../misc/misc.dart';
import '../model/condition.dart';
import 'parsed_task.dart';

class ScriptCommand extends Command<void> {
  ScriptCommand({
    required this.name,
    required this.description,
    required List<ParsedTask> tasks,
    this.conditions = const [],
    Map<String, String> paramSpec = const {},
  }) : _tasks = tasks {
    final params = <int>{};
    for (final task in _tasks) {
      for (final name in task.getParams()) {
        if (isDigit(name)) {
          params.add(int.parse(name));
        } else {
          argParser.addOption(
            name,
            mandatory: true,
            help: paramSpec[name],
          );
        }
      }
    }
    if (params.isNotEmpty) {
      if (params.reduce(max) != params.length) {
        throw StateError(
            "Positional parameters should start from 1 and continuously.");
      }
      _trailingOptions = List.generate(params.length, (index) {
        final name = (index + 1).toString();
        return paramSpec[name] ?? name;
      });
    }
  }

  List<String> _trailingOptions = const [];

  @override
  final String name;

  @override
  final String description;

  final List<ParsedTask> _tasks;

  final List<Condition> conditions;

  @override
  String get invocation {
    if (_trailingOptions.isEmpty) {
      return super.invocation;
    }
    final sb = StringBuffer(super.invocation);
    for (final option in _trailingOptions) {
      sb
        ..write(" ")
        ..write("<")
        ..write(option)
        ..write(">");
    }
    return sb.toString();
  }

  @override
  bool get takesArguments => _trailingOptions.isNotEmpty;

  @override
  Future<void> run() async {
    for (final condition in conditions) {
      condition.check();
    }
    final trailingArgs = argResults!.rest;
    if (trailingArgs.length < _trailingOptions.length) {
      final missingArg = _trailingOptions[trailingArgs.length];
      usageException("Missing `$missingArg`.");
    } else if (trailingArgs.length > _trailingOptions.length) {
      usageException(plural(
        _trailingOptions.length,
        one: (c) => "Command $name only takes $c positional argument.",
        other: (c) => "Command $name only takes $c positional arguments.",
      ));
    }
    for (final line in _tasks) {
      await line.run(argResults!);
    }
  }
}
