#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

/// Cordova wrapper
/// - Parameter version: the version number of the Cordova Anyline plugin
+ (ALWrapperConfig *)cordova:(NSString *)version;

/// Flutter wrapper
/// - Parameter version: the version number of the Flutter Anyline plugin
+ (ALWrapperConfig *)flutter:(NSString *)version;

/// .NET wrapper
/// - Parameter version: the version number of the .NET Anyline plugin
+ (ALWrapperConfig *)dotNet:(NSString *)version;

/// Returns the object as a JSON-friendly NSDictionary.
- (NSDictionary *)asJSONDictionary;

@end

NS_ASSUME_NONNULL_END
