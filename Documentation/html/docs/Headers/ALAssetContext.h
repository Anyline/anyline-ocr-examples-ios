#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Asset context descriptor
@interface ALAssetContext : NSObject

/// The API key
@property NSString *apiKey;

/// Project ID
@property NSString *projectID;

/// The stage the asset is in
@property NSString *stage;

/// The Anyline version targeted
@property NSString *anylineVersion;

/// Training value
@property NSString *training;

/// The asset ID
@property NSString *assetID;

/// The asset version
@property NSString *assetVersion;

/// Return the asset context as a JSON string
/// @return the asset context as a JSON string
- (NSString *)asJSONString;

/// Returns the project configuration from a trainer context.
/// @param context An asset context with the appropriate projectId and apiKey set
/// @param timeout Maximum of time (in seconds) to wait to get the result
/// @param error This will be set to an NSError if there is a timeout or another problem with getting the configuration, or nil if there was no issue.
/// @return the project configuration as a dictionary
+ (NSDictionary *_Nullable)getProjectConfigWithContext:(ALAssetContext * _Nonnull)context timeout:(NSTimeInterval)timeout error:(NSError *_Nullable*_Nullable)error;

/// Returns a temporary authorization token from a trainer context.
/// The token will be cached until it expires.
/// If there already exists a cached token which has not yet expired, it will be reused.
/// @param context An asset context with the appropriate projectId and apiKey set
/// @param timeout Maximum of time (in seconds) to wait to get the token
/// @param error This will be set to an NSError if there is a timeout or another problem with getting the token, or nil if there was no issue.
/// @return the authentication token to use with the trainer session
+ (NSString *_Nullable)getAuthTokenWithContext:(ALAssetContext * _Nonnull)context timeout:(NSTimeInterval)timeout error:(NSError *_Nullable*_Nullable)error;

@end

NS_ASSUME_NONNULL_END
