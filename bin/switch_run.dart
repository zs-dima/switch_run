import 'dart:io';

import 'package:args/args.dart';
import 'package:switch_run/args_x.dart';
import 'package:switch_run/command.dart';
import 'package:switch_run/keyboard/keyboard.dart';

void main(List<String> arguments) async {
  // Hide console window
  // https://github.com/dart-lang/sdk/issues/41926
  // https://github.com/dart-lang/sdk/issues/51922
  // editbin.exe /subsystem:windows switch-run.exe

  final parser = ArgParser() //
    ..addOption('run', abbr: 'r', help: 'Run command when no shortcut key is pressed')
    ..addOption('alt', abbr: 'a', help: 'Run command when Alt is pressed')
    ..addOption('ctrl', abbr: 'c', help: 'Run command when Ctrl is pressed')
    ..addOption('shift', abbr: 's', help: 'Run command when Shift is pressed')
    ..addOption('win', abbr: 'w', help: 'Run command when Win is pressed')
    ..addOption('folder', abbr: 'f', help: 'Default path to run command in')
    ..addOption('parameters', abbr: 'p', help: 'Parameters to pass to the shortcut command')
    ..addOption('before', abbr: 'b', help: 'Run command before running the shortcut command')
    ..addOption('after', abbr: 't', help: 'Run command after running the shortcut command')
    ..addFlag('help', abbr: 'h', help: 'Help');

  // TODO:
  //parser.addOption('alt-ctrl', aliases: ['ac'], help: 'Run command when Alt+Shift is pressed');
  //parser.addOption('alt-shift', aliases: ['as'], help: 'Run command when Alt+Ctrl is pressed');
  //parser.addOption('alt-win', aliases: ['aw'], help: 'Run command when Alt+Win is pressed');
  //parser.addOption('ctrl-shift', aliases: ['cs'], help: 'Run command when Ctrl+Shift is pressed');
  //parser.addOption('ctrl-win', aliases: ['cw'], help: 'Run command when Ctrl+Win is pressed');
  //parser.addOption('shift-win', aliases: ['sw'], help: 'Run command when Shift+Win is pressed');

  final args = parser.parse(arguments);

  await args.execute(
    'folder',
    (folder) => Directory.current = folder,
  );

  await args.execute(
    'before',
    (command) => Command.from(command).execute(),
  );

  final options = args.options.where((o) => Keys.keys.keys.contains(o)).toList();
  if (options.isEmpty) {
    await args.execute(
      'run',
      (command) => Command.from(command).execute(),
    );
  } else {
    for (final option in options) {
      final commandText = args[option]?.toString();
      final key = Keys.keys[option];

      if (key == null) {
        stderr.writeln('Unknown key: $option');
        continue;
      }

      if (commandText != null && await Keyboard.keyPressed(key)) {
        await Command.from(commandText).execute();
      }
    }
  }

  await args.execute(
    'after',
    (command) => Command.from(command).execute(),
  );

  if (args['help'] != null) {
    stdout.writeln(parser.usage);
  }
}
