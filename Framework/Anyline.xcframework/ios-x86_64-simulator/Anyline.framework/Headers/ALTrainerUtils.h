//
//  ALTrainerUtils.h
//  Anyline
//
//  Created by Angela Brett on 04.08.20.
//  Copyright © 2020 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALAssetContext.h"

@interface ALTrainerUtils : NSObject


/// Returns the project configuration from a trainer context.
/// @param context An asset context with the appropriate projectId and apiKey set
/// @param timeout Maximum of time (in seconds) to wait to get the result
/// @param error This will be set to an NSError if there is a timeout or another problem with getting the configuration, or nil if there was no issue.
+ (NSDictionary *_Nullable)getProjectConfigWithContext:(ALAssetContext * _Nonnull)context timeout:(NSTimeInterval)timeout error:(NSError *_Nullable*_Nullable)error;

/// Returns a temporary authorization token from a trainer context.
/// The token will be cached until it expires.
/// If there already exists a cached token which has not yet expired, it will be reused.
/// @param context An asset context with the appropriate projectId and apiKey set
/// @param timeout Maximum of time (in seconds) to wait to get the token
/// @param error This will be set to an NSError if there is a timeout or another problem with getting the token, or nil if there was no issue.
+ (NSString *_Nullable)getAuthTokenWithContext:(ALAssetContext * _Nonnull)context timeout:(NSTimeInterval)timeout error:(NSError *_Nullable*_Nullable)error;

@end
