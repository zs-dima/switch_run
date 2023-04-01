import 'dart:io';

bool keyPressed(int key) {
  if (!Platform.isLinux) return false;

  final keyboard = File('/dev/input/event0').openSync(mode: FileMode.read);
  final buffer = List.filled(16, 0);

  keyboard.readIntoSync(buffer);

  return buffer[10] == key;
}
