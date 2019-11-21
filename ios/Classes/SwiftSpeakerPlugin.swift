import Flutter
import AVFoundation

public class SwiftOoga04SpeakerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ooga04_speaker", binaryMessenger: registrar.messenger())
    let instance = SwiftOoga04SpeakerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "play" {
      let arguments = call.arguments as! [String: Any]
      guard let resourceUri = arguments["resourceUri"] as? String else {
         result(FlutterError.init(code: "ArgumentError", message: "Required argument does not exist.", details: nil));
         return
      }

      let soundPath = resourceUri.split(separator: ".").map { String($0) }

      guard let path = Bundle.main.path(forResource: soundPath[0], ofType: soundPath[1]) else {
        print("not found file.")
        return
      }

      do {
        audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        if audioPlayer.isPlaying() {
          audioPlayer.stop();
        }

        audioPlayer.delegate = self
        audioPlayer.volume = 1.0
        audioPlayer.play()
      } catch {
      }
    }
  }
}
