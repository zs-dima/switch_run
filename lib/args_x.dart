import 'dart:async';

import 'package:args/args.dart';

extension ArgsExtension on ArgResults {
  Future execute(String key, FutureOr Function(String value) run) async {
    final value = this[key]?.toString();
    if (value != null) await run(value);
  }
}
