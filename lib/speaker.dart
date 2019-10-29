import 'dart:async';

import 'package:flutter/services.dart';

class Speaker {
  static const MethodChannel _channel = const MethodChannel('ooga04/speaker');

  /// Plays an audio.
  ///
  Future<String> play(String resourceUri, {bool isLocal = false}) async {
    final String result = await _channel.invokeMethod('play', {
      'resourceUri': resourceUri,
    });

    return result;
  }
}
