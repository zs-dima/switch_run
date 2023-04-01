import 'dart:io';

import 'package:args/args.dart';
import 'package:switch_run/command.dart';
import 'package:switch_run/keyboard/keyboard.dart';

void main(List<String> arguments) async {
  // Hide console window
  // https://github.com/dart-lang/sdk/issues/41926
  // editbin.exe /subsystem:windows switch-run.exe

  final parser = ArgParser() //
    ..addOption('alt', abbr: 'a', help: 'Run command when Alt is pressed')
    ..addOption('ctrl', abbr: 'c', help: 'Run command when Ctrl is pressed')
    ..addOption('shift', abbr: 's', help: 'Run command when Shift is pressed')
    ..addOption('win', abbr: 'w', help: 'Run command when Win is pressed')
    ..addOption('path', abbr: 'p', help: 'Default path to run command in')
    ..addFlag('help', abbr: 'h', help: 'Help');

  // TODO:
  //parser.addOption('alt-ctrl', aliases: ['ac'], help: 'Run command when Alt+Shift is pressed');
  //parser.addOption('alt-shift', aliases: ['as'], help: 'Run command when Alt+Ctrl is pressed');
  //parser.addOption('alt-win', aliases: ['aw'], help: 'Run command when Alt+Win is pressed');
  //parser.addOption('ctrl-shift', aliases: ['cs'], help: 'Run command when Ctrl+Shift is pressed');
  //parser.addOption('ctrl-win', aliases: ['cw'], help: 'Run command when Ctrl+Win is pressed');
  //parser.addOption('shift-win', aliases: ['sw'], help: 'Run command when Shift+Win is pressed');

  final args = parser.parse(arguments);

  if (args['path'] != null) {
    Directory.current = args['path'].toString();
  }

  for (final option in args.options.where((o) => Keys.keys.keys.contains(o))) {
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

  if (args['help'] != null) {
    stdout.writeln(parser.usage);
  }
}
