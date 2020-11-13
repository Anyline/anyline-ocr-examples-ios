//
//  AnylineSDK.h
//  Anyline
//
//  Created by David Dengg on 04.11.20.
//  Copyright © 2020 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnylineSDK : NSObject

+ (BOOL)setupWithLicenseKey:(NSString*)licenseKey error:(NSError**)error;

@end

NS_ASSUME_NONNULL_END
