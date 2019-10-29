package ooga.sh4.jp.speaker;

import java.io.IOException;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** SpeakerPlugin */
public class SpeakerPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "ooga04/speaker");
    channel.setMethodCallHandler(new SpeakerPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("play")) {
      Speaker speaker = new Speaker();
      String resourceUri = call.argument("resourceUri");
      try {
        speaker.play(resourceUri);
        result.success("start MediaPlayer");
      } catch (IOException e) {
        e.printStackTrace();
        result.error("failed to start MediaPlayer", resourceUri, null);
      }
    } else {
      result.notImplemented();
    }
  }
}
