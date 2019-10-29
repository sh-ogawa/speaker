# speaker

Play the specified resource as audio.

# Feature

* Speaking resources over HTTP(S)
* Plays audio even when the app is in the background
* You can define what happens when playback ends (normal or abnormal)
* There is no way to stop it if it starts in the current version
* iOS isn't support.

# Usage

```dart

  var _speaker = Speaker(onSpeakEnd: () async {
    // Write processing at the speak end.
  });

  await _speaker.play("speaking resource");

```