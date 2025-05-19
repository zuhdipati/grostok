import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.milliseconds});

  Future run(VoidCallback action) async {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}