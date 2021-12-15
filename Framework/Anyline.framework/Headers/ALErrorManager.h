//
//  ALErrorManager.h
//  Anyline
//
//  Created by Daniel Albertini on 16/06/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALError.h"

@interface ALErrorManager : NSObject

@property (strong, nonatomic) NSError *error;

+ (instancetype)sharedInstance;
- (instancetype)init NS_UNAVAILABLE;

- (BOOL)hasError;
- (void)resetError;

- (void)addErrorForDomain:(NSString *)errorDomain
                errorCode:(ALErrorCode)errorCode
                 userInfo:(NSDictionary *)userInfo;

@end
