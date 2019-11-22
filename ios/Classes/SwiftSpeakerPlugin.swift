import Flutter
import AVKit
import AVFoundation

public class SwiftOoga04SpeakerPlugin: NSObject, FlutterPlugin, AVAudioPlayerDelegate {
  let player = AVPlayer()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ooga04/speaker", binaryMessenger: registrar.messenger())
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
    if let encodeUrl = resourceUri.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
      if let url = URL(string: encodeUrl) {
        let playerItem = AVPlayerItem(url: url)
          player.replaceCurrentItem(with: playerItem)
          player.volume = 1.0
          player.play()
          result("request success");
        }
      }
    }
  }
}
