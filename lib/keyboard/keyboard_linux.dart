import 'dart:io';

bool keyPressed(int key) {
  if (!Platform.isLinux && !Platform.isMacOS) return false;

  final keyboard = File('/dev/input/event0').openSync(mode: FileMode.read);
  final buffer = List.filled(16, 0);

  keyboard.readIntoSync(buffer);

  return buffer[10] == key;
}

List<int> keysPressed() {
  if (!Platform.isLinux && !Platform.isMacOS) return [];

  final keyboard = File('/dev/input/event0').openSync(mode: FileMode.read);
  final buffer = List.filled(16, 0);

  keyboard.readIntoSync(buffer);

  final keysPressed = <int>[];

  for (var i = 10; i < 16; i++) {
    if (buffer[i] != 0) {
      keysPressed.add(buffer[i]);
    }
  }

  return keysPressed;
}
