// ignore_for_file: avoid_private_typedef_functions

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
//import 'package:win32/win32.dart';

typedef _GetAsyncKeyStateC = Int16 Function(Int32);
typedef _GetAsyncKeyStateDart = int Function(int);
typedef _GetKeyboardStateC = Int32 Function(Pointer<Uint8> lpKeyState);
typedef _GetKeyboardStateDart = int Function(Pointer<Uint8> lpKeyState);

bool keyPressed(int key) {
  if (!Platform.isWindows) return false;

  final user32 = DynamicLibrary.open('user32.dll');
  final getAsyncKeyState = user32.lookupFunction<_GetAsyncKeyStateC, _GetAsyncKeyStateDart>('GetAsyncKeyState');

  final keyState = getAsyncKeyState(key);

  return (keyState & 0x8000) != 0;
}

List<int> keysPressed() {
  if (!Platform.isWindows) return [];

  // Load the user32.dll library on Windows
  final user32 = DynamicLibrary.open('user32.dll');

  // Get the address of the GetKeyboardState function
  final getKeyboardState = user32.lookupFunction<_GetKeyboardStateC, _GetKeyboardStateDart>('GetKeyboardState');

  // Allocate a buffer to hold the current keyboard state
  final keyboardState = calloc<Uint8>(256);

  // Get the current keyboard state
  getKeyboardState(keyboardState);

  // Get the current keyboard state with win32
  // if (win32.GetKeyboardState(keyboardState) == 0) throw win32.WindowsException(win32.HRESULT_FROM_WIN32(win32.GetLastError()));

  // Convert the keyboard state to a List of pressed keys
  final keysPressed = <int>[];
  for (var i = 0; i < 256; i++) {
    if ((keyboardState[i] & 0x80) != 0) {
      keysPressed.add(i);
    }
  }

  // Free the keyboard state buffer
  calloc.free(keyboardState);

  return keysPressed;
}
