//
//  ALLicenseCheck.h
//  AnylineFramework
//
//  Created by Aldrich Co on 1/25/22.
//  Copyright © 2022 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ALLicenseUtil, ALLicenseProvider;

@interface ALLicenseCheck : NSObject

+ (instancetype)sharedInstance;

/// Tests whether the license string supplied supports the FAU
/// scope. Make sure to initialize the AnylineSDK before calling this.
/// 
/// Throws an ALLicenseNotValidForFeature Exception if this
/// feature is not supported for the license key, or
/// ALLicenseSetupNotDone when AnylineSDK has not yet been initialized.
- (BOOL)checkFaceAuthenticationSupport:(NSError **)error;

// this should be kept private
- (instancetype)initWithLicenseProvider:(ALLicenseProvider * _Nullable)licenseProvider;

@property (nonatomic, strong) ALLicenseUtil *licenseUtil;

@end

NS_ASSUME_NONNULL_END
