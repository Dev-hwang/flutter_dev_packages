#import "FlutterDevPackagesPlugin.h"
#if __has_include(<flutter_dev_packages/flutter_dev_packages-Swift.h>)
#import <flutter_dev_packages/flutter_dev_packages-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_dev_packages-Swift.h"
#endif

@implementation FlutterDevPackagesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterDevPackagesPlugin registerWithRegistrar:registrar];
}
@end
