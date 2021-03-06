import 'dart:async';

import 'package:flutter/services.dart';

typedef Future<dynamic> MessageHandler();

class Speaker {
  static const MethodChannel _channel = const MethodChannel('ooga04/speaker');

  MessageHandler _onSpeakEnd;
  MessageHandler _onSpeakFailed;
  Speaker({MessageHandler onSpeakEnd, MessageHandler onSpeakFailed}) {
    _onSpeakEnd = onSpeakEnd;
    _onSpeakFailed = onSpeakFailed;
    _channel.setMethodCallHandler(_handleMethod);
  }

  /// Play audio.
  ///
  Future<String> play(String resourceUri, {bool isLocal = false}) async {
    final String result = await _channel.invokeMethod('play', {
      'resourceUri': resourceUri,
    });

    return result;
  }

  Future<String> plays(List<String> resourceUriList, {bool isLocal = false}) async {
    final String result = await _channel.invokeMethod('plays', {
      'resourceUris': resourceUriList,
    });

    return result;
  }

  /// platform -> flutter
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onSpeakEnd":
        _onSpeakEnd();
        return null;

      case "onSpeakFailed":
        if (_onSpeakFailed != null) {
          _onSpeakFailed();
        }
        return null;

      default:
        throw UnsupportedError("Unrecognized JSON message");
    }
  }
}
