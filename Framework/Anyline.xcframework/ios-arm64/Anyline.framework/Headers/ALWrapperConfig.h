#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A typed string constant identifying the plugin variant codename.
typedef NSString * ALWrapperCodename NS_STRING_ENUM;

/// Legacy plugin variant codename.
static ALWrapperCodename const ALWrapperCodenameLegacy = @"legacy";

/// Infinity plugin variant codename.
static ALWrapperCodename const ALWrapperCodenameInfinity = @"infinity";

/// Contains information about the framework accessing Anyline.
@interface ALWrapperConfig : NSObject

/// Returns the name of the wrapper framework.
- (NSString *)name;

/// Returns the version of the wrapper framework.
- (NSString *)pluginVersion;

/// Native SDK
+ (ALWrapperConfig *)none;

/// React Native wrapper
/// - Parameter version: the version number of the React Native Anyline plugin
+ (ALWrapperConfig *)reactNative:(NSString *)version;

/// React Native wrapper with a codename variant (e.g. ALWrapperCodenameInfinity)
/// - Parameters:
///   - version: the version number of the React Native Anyline plugin
///   - codename: the plugin variant codename, or nil for the standard plugin
+ (ALWrapperConfig *)reactNative:(NSString *)version codename:(nullable ALWrapperCodename)codename;

/// Cordova wrapper
/// - Parameter version: the version number of the Cordova Anyline plugin
+ (ALWrapperConfig *)cordova:(NSString *)version;

/// Cordova wrapper with a codename variant (e.g. ALWrapperCodenameInfinity)
/// - Parameters:
///   - version: the version number of the Cordova Anyline plugin
///   - codename: the plugin variant codename, or nil for the standard plugin
+ (ALWrapperConfig *)cordova:(NSString *)version codename:(nullable ALWrapperCodename)codename;

/// Flutter wrapper
/// - Parameter version: the version number of the Flutter Anyline plugin
+ (ALWrapperConfig *)flutter:(NSString *)version;

/// Flutter wrapper with a codename variant (e.g. ALWrapperCodenameInfinity)
/// - Parameters:
///   - version: the version number of the Flutter Anyline plugin
///   - codename: the plugin variant codename, or nil for the standard plugin
+ (ALWrapperConfig *)flutter:(NSString *)version codename:(nullable ALWrapperCodename)codename;

/// .NET wrapper
/// - Parameter version: the version number of the .NET Anyline plugin
+ (ALWrapperConfig *)dotNet:(NSString *)version;

/// Returns the object as a JSON-friendly NSDictionary.
- (NSDictionary *)asJSONDictionary;

@end

NS_ASSUME_NONNULL_END
