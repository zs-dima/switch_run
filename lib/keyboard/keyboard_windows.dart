import 'dart:io';

import 'package:win32/win32.dart' as win32;

bool keyPressed(int key) {
  if (!Platform.isWindows) return false;

  return win32.GetAsyncKeyState(key) < 0;
}
