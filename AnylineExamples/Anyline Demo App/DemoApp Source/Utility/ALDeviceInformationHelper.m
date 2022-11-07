//
//  ALDeviceInformationHelper.h
//  AnylineExamples
//
//  Created by Philipp on 11.12.2018.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import "ALDeviceInformationHelper.h"

@interface ALDeviceInformationHelper ()
@end

@implementation ALDeviceInformationHelper

+ (NSString *)getUUID {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)getBundleIdentifier {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)getAppLocalization {
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

@end
