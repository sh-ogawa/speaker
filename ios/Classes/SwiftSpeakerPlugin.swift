import Flutter
import AVKit
import AVFoundation

public class SwiftOoga04SpeakerPlugin: NSObject, FlutterPlugin, AVAudioPlayerDelegate {
    let player = AVPlayer()
    var resultPlay:FlutterResult?
    private var channel: FlutterMethodChannel!

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftOoga04SpeakerPlugin(registrar: registrar, messenger: registrar.messenger())
        registrar.addApplicationDelegate(instance)
    }

    init(registrar: (NSObjectProtocol & FlutterPluginRegistrar)!, messenger: (NSObjectProtocol & FlutterBinaryMessenger)!) {
        super.init()

        channel = FlutterMethodChannel(name: "ooga04/speaker", binaryMessenger: registrar.messenger())
        registrar?.addMethodCallDelegate(self, channel: channel)
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
                    resultPlay = result
                    let playerItem = AVPlayerItem(url: url)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
                    player.replaceCurrentItem(with: playerItem)
                    player.volume = 1.0
                    player.play()
                    result("request success");
                }
            }
        }
    }

    @objc func playerDidFinishPlaying(sender: Notification) {
        channel.invokeMethod("onSpeakEnd", arguments: [])
    }
}
