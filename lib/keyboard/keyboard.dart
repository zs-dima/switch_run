import 'dart:io' as io;

import 'keyboard_linux.dart' deferred as linux;
import 'keyboard_windows.dart' deferred as windows;

class Key {
  final String name;
  final int windowsCode;
  final int linuxCode;

  const Key(this.name, this.windowsCode, this.linuxCode);
}

class Keys {
  static const Key alt = Key('alt', 0x12, 56);
  static const Key ctrl = Key('ctrl', 0x11, 29);
  static const Key shift = Key('shift', 0x10, 42);
  static const Key win = Key('win', 0x5B, 125);

  static Map<String, Key> keys = {
    alt.name: alt,
    ctrl.name: ctrl,
    shift.name: shift,
    win.name: win,
  };
}

class Keyboard {
  static Future<bool> keyPressed(Key key) async {
    if (io.Platform.isLinux) {
      await linux.loadLibrary();
      return linux.keyPressed(key.linuxCode);
    } else if (io.Platform.isWindows) {
      await windows.loadLibrary();
      return windows.keyPressed(key.windowsCode);
    }
    return false;
  }
}
