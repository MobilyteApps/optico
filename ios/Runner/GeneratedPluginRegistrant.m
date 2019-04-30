//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <android_intent/AndroidIntentPlugin.h>
#import <flutter_full_pdf_viewer/FlutterFullPdfViewerPlugin.h>
#import <path_provider/PathProviderPlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>
#import <simple_permissions/SimplePermissionsPlugin.h>
#import <url_launcher/UrlLauncherPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTAndroidIntentPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTAndroidIntentPlugin"]];
  [FlutterFullPdfViewerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterFullPdfViewerPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [SimplePermissionsPlugin registerWithRegistrar:[registry registrarForPlugin:@"SimplePermissionsPlugin"]];
  [FLTUrlLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTUrlLauncherPlugin"]];
}

@end
