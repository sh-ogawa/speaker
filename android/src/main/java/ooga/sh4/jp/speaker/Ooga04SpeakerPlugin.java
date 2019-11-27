package ooga.sh4.jp.speaker;

import android.util.Log;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** Ooga04SpeakerPlugin */
public class Ooga04SpeakerPlugin implements MethodCallHandler, Ooga04Speaker.SpeakEndListener {

  private final MethodChannel channel;
  private List<String> playList;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    MethodChannel channel = new MethodChannel(registrar.messenger(), "ooga04/speaker");
    channel.setMethodCallHandler(new Ooga04SpeakerPlugin(channel));
  }

  private Ooga04SpeakerPlugin(MethodChannel channel) {
    this.channel = channel;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("play")) {
      String resourceUri = call.argument("resourceUri");
      playList = new ArrayList<>();
      playList.add(resourceUri);

      if (play()) {
        result.success("start MediaPlayer");
      } else {
        result.error("failed to start MediaPlayer", resourceUri, null);
      }
    } else if (call.method.equals("plays")) {
      playList = new ArrayList<>();
      List<String> resourceUris = call.argument("resourceUris");
      playList.addAll(resourceUris);

      if (play()) {
        result.success("start MediaPlayer");
      } else {
        result.error("failed to start MediaPlayer", resourceUris.toString(), null);
      }
    } else {
      result.notImplemented();
    }
  }

  // Play a single file
  private boolean play() {
    Ooga04Speaker speaker = new Ooga04Speaker(this);
    String resourceUri = playList.get(0);
    playList.remove(0);
    try {
      speaker.play(resourceUri);
      return true;
    } catch (IOException e) {
      e.printStackTrace();
      return false;
    }
  }

  @Override
  public void onSpeakEnd() {
    if (playList.size() > 0) {
      if (!play()) {
        channel.invokeMethod("onSpeakEnd", null);
      }
    } else {
      channel.invokeMethod("onSpeakEnd", null);
    }
  }
}
