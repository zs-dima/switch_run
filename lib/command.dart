import 'dart:io';

import 'package:meta/meta.dart';

@immutable
class Command {
  final String executable;
  final List<String> parameters;

  const Command(this.executable, this.parameters);

  bool get isEmpty => executable.isEmpty;

  factory Command.from(String command) {
    String executable;
    List<String> parameters;

    if (command.startsWith('"')) {
      final index = command.indexOf('"', 1);
      executable = command.substring(1, index);
      parameters = command.substring(index + 1).trimChar(' "').split(' ');
    } else {
      final executableAndParams = command.split(' ');
      executable = executableAndParams[0];
      parameters = command.substring(executable.length).trimChar(' "').split(' ');
    }

    return Command(executable, parameters);
  }

  Future<bool> execute() async {
    if (isEmpty) return false;

    stdout.writeln('Executing: $this');

    final result = await Process.run(executable, parameters);
    stdout.write(result.stdout);
    stderr.write(result.stderr);

    return result.exitCode == 0;
  }

  // Value class equality
  @override
  bool operator ==(Object other) =>
      other is Command && other.executable == executable && other.parameters == parameters;

  @override
  int get hashCode => executable.hashCode ^ parameters.hashCode;

  @override
  String toString() => '$executable, parameters: ${parameters.join(' ')}';
}

// String extension
extension StringExtension on String {
  String trimChar(String char) {
    if (isEmpty) return this;
    var result = this;

    while (char.contains(result[0])) {
      result = result.substring(1);
    }

    while (char.contains(result[result.length - 1])) {
      result = result.substring(0, result.length - 1);
    }

    return result;
  }
}
