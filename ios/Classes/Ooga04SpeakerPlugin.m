#import "Ooga04SpeakerPlugin.h"
#import <ooga04_speaker/ooga04_speaker-Swift.h>

@implementation Ooga04SpeakerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOoga04SpeakerPlugin registerWithRegistrar:registrar];
}
@end
