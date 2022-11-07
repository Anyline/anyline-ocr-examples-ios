//
//  ALDeviceInformationHelper.h
//  AnylineExamples
//
//  Created by Philipp on 10.12.2018.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALDeviceInformationHelper : NSObject

+ (NSString *)getUUID;
+ (NSString *)getBundleIdentifier;
+ (NSString *)getAppLocalization;

@end
