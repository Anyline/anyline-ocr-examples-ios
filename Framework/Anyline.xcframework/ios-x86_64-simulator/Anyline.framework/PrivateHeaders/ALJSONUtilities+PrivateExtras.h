#import <Foundation/Foundation.h>
#import "ALJSONUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ALQTReveal <NSObject>

// these expose QuickType generated functions from those classes
- (instancetype)initWithJSONDictionary:(NSDictionary *)dict;

- (NSDictionary *)JSONDictionary;

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;

+ (NSDictionary<NSString *, NSString *> *)properties;

@end


@interface ALJSONUtilities: NSObject

// the param will be type checked at run time.
+ (NSString * _Nullable)cleanUpHexString:(NSString * _Nullable)hexString;

+ (NSString * _Nullable)cleanUpImageResolutionStr:(NSString * _Nullable)resolutionStr;

+ (NSString *)readableJSON:(NSObject<ALJSONConfig> *)config;

@end

NS_ASSUME_NONNULL_END
