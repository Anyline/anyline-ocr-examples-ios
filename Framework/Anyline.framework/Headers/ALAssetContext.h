//
//  ALAssetContext.h
//  Anyline
//
//  Created by Angela Brett on 22.01.20.
//  Copyright © 2020 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALAssetContext : NSObject

@property NSString *apiKey;
@property NSString *projectID;
@property NSString *stage;
@property NSString *anylineVersion;
@property NSString *training;

- (NSString *)toJSON;

@end

NS_ASSUME_NONNULL_END
