#import "SpeakerPlugin.h"
#import <speaker/speaker-Swift.h>

@implementation SpeakerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSpeakerPlugin registerWithRegistrar:registrar];
}
@end
