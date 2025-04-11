#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALFrameworkBundle : NSObject

+ (NSURL * _Nullable)frameworkBundleURL;
+ (NSBundle * _Nullable)frameworkBundle;
+ (NSString *)versionNumber;
+ (NSString *)buildNumber;
+ (NSString *)bundleIdentifier;

@end

NS_ASSUME_NONNULL_END
