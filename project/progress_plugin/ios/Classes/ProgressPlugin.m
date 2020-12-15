#import "ProgressPlugin.h"
#if __has_include(<progress_plugin/progress_plugin-Swift.h>)
#import <progress_plugin/progress_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "progress_plugin-Swift.h"
#endif

@implementation ProgressPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftProgressPlugin registerWithRegistrar:registrar];
}
@end
