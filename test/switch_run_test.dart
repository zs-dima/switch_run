import 'package:switch_run/command.dart';
import 'package:test/test.dart';

void main() {
  test('Test command parsing', () {
    final command1 = Command.from('"C:\\Program Files\\notepad.exe" test.txt');
    expect(command1.executable, equals('C:\\Program Files\\notepad.exe'));
    expect(command1.parameters, equals(['test.txt']));

    final command2 = Command.from('notepad.exe test.txt');
    expect(command2.executable, equals('notepad.exe'));
    expect(command2.parameters, equals(['test.txt']));
  });
}
