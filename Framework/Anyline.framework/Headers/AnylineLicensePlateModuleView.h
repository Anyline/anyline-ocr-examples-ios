//
//  AnylineLicensePlateModuleView.h
//  Anyline
//
//  Created by Daniel Albertini on 02/10/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "AnylineAbstractModuleView.h"
#import "ALLicensePlateResult.h"
#import "ALLicensePlateScanPlugin.h"
#import "ALLicensePlateScanViewPlugin.h"

@protocol AnylineLicensePlateModuleDelegate;

@interface AnylineLicensePlateModuleView : AnylineAbstractModuleView

@property (nullable, nonatomic, strong) ALLicensePlateScanPlugin *licensePlateScanPlugin;

@property (nullable, nonatomic, strong) ALLicensePlateScanViewPlugin *licensePlateScanViewPlugin;

/**
 *  Sets the license key and delegate.
 *
 *  @param licenseKey The Anyline license key for this application bundle
 *  @param delegate The delegate that will receive the Anyline results (hast to conform to <AnylineLicensePlateModuleDelegate>)
 *  @param error The error that occured
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setupWithLicenseKey:(NSString * _Nonnull)licenseKey
                   delegate:(id<AnylineLicensePlateModuleDelegate> _Nonnull)delegate
                      error:(NSError * _Nullable * _Nullable )error;

/**
 *  Sets the license key and delegate. Async method with return block when done.
 *
 *  @param licenseKey The Anyline license key for this application bundle
 *  @param delegate The delegate that will receive the Anyline results (hast to conform to <AnylineLicensePlateModuleDelegate>)
 *  @param finished Inidicating if setup is finished with an error object when setup failed.
 *
 */
- (void)setupAsyncWithLicenseKey:(NSString * _Nonnull)licenseKey
                        delegate:(id<AnylineLicensePlateModuleDelegate> _Nonnull)delegate
                        finished:(void (^_Nonnull)(BOOL success, NSError * _Nullable error))finished;

@end

@protocol AnylineLicensePlateModuleDelegate <NSObject>

@required

/**
 *  Returns the scanned value
 *
 *  @param anylineLicensePlateModuleView The view that scanned the result
 *  @param scanResult The scanned value
 *
 */
- (void)anylineLicensePlateModuleView:(AnylineLicensePlateModuleView * _Nonnull)anylineLicensePlateModuleView
                        didFindResult:(ALLicensePlateResult * _Nonnull)scanResult;

@end
