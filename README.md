# speaker

Play the specified resource as audio.

# Feature

* Speaking resources over HTTP(S)
* Plays audio even when the app is in the background
* You can define what happens when playback ends (normal or abnormal)
* There is no way to stop it if it starts in the current version
* iOS support.

# Usage

```dart

  var _speaker = Speaker(onSpeakEnd: () async {
    // Write processing at the speak end.
  });

  await _speaker.play("speaking resource");

```

```dart

  var _speaker = Speaker(onSpeakEnd: () async {
    // Write processing at the all speak end.
  });

　
  await _speaker.plays(["speaking resource1", "speaking resource2"]);

```

# local audio file integration

pubspec.yaml
```yaml
flutter:
  assets:
    - audios/example.mp3

```

```dart

  _speaker.play("example.mp3");

```