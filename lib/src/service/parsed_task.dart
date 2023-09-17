import 'package:args/args.dart';

import '../built_in_shell.dart';
import '../misc/current_supported_platform.dart';
import '../misc/misc.dart';
import '../misc/range.dart';

class ParsedTask {
  const ParsedTask(this.line, this.paramRanges);

  factory ParsedTask.parse(String line) {
    var i = 0;
    final ranges = <Range<int>>[];

    while (true) {
      final start = line.indexOf("{{", i);
      if (start == -1) {
        break;
      }
      i = start + 2;
      final end = line.indexOf("}}", i);
      if (end == -1) {
        break;
      }
      i = end + 2;
      ranges.add(Range(start, end + 1));
    }
    return ParsedTask(line, ranges);
  }

  final String line;
  final List<Range<int>> paramRanges;

  Iterable<String> getParams() => paramRanges.map(_getName);

  String _getName(Range<int> range) =>
      line.substring(range.start + 2, range.endInclusive - 1);

  Future<void> run(ArgResults argResults) async {
    final String filledLine;
    if (paramRanges.isNotEmpty) {
      final sb = StringBuffer();
      var i = 0;
      for (final range in paramRanges) {
        sb.write(line.substring(i, range.start));
        final name = _getName(range);
        final String arg;
        arg = isDigit(name)
            ? argResults.rest[int.parse(name) - 1]
            : argResults[name] as String;
        sb.write(arg); // should we escape parameter?
        i = range.endInclusive + 1;
      }
      sb.write(line.substring(i));
      filledLine = sb.toString();
    } else {
      filledLine = line;
    }
    final String executableName;
    final space = filledLine.indexOf(" ");
    if (space == -1) {
      executableName = filledLine;
    } else {
      executableName = filledLine.substring(0, space);
    }
    final delegate = builtInShell[executableName];
    if (delegate != null && delegate.isSupported) {
      delegate.handle(filledLine.substring(space + 1));
    } else {
      await shell(filledLine);
    }
  }
}
