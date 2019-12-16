import Flutter
import AVKit
import AVFoundation

public class SwiftOoga04SpeakerPlugin: NSObject, FlutterPlugin, AVAudioPlayerDelegate {
    let player = AVPlayer()
    var resultPlay:FlutterResult?
    private var playerItemContext = 0
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

            if let encodeUrl = resourceUri.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) , let url = URL(string: encodeUrl) {
                resultPlay = result
                let playerItem = AVPlayerItem(url: url)
                
                // Listen event play finish
                NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
                // Listen event play failed
                playerItem.addObserver(self,forKeyPath: #keyPath(AVPlayerItem.status),options: [.old, .new],
                                       context: &playerItemContext)
                player.replaceCurrentItem(with: playerItem)
                player.volume = 1.0
                player.play()
                result("request success");
            }else{
                channel.invokeMethod("onSpeakFailed", arguments: [])
            }
        }
    }
    
    /// Event play finish
    @objc func playerDidFinishPlaying(sender: Notification) {
        channel.invokeMethod("onSpeakEnd", arguments: [])
    }
    
    /// Filter status to handle event play failed
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        print("AVPLAYER_observeValue:\(String(describing: keyPath))");
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        // Handle status
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItemStatus
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            // Send error to dart code
            if status == .failed{
                let strError = String(describing: self.player.currentItem?.error)
                NSLog("AVPlayer_Error: \(strError))")
                channel.invokeMethod("onSpeakFailed", arguments: [])
            }
        }
    }
    
}
