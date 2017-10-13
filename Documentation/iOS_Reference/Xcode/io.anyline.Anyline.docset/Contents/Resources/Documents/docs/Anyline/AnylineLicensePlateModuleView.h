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

@protocol AnylineLicensePlateModuleDelegate;

@interface AnylineLicensePlateModuleView : AnylineAbstractModuleView

@property (nonatomic, strong) ALLicensePlateScanPlugin *licensePlateScanPlugin;

/**
 *  Sets the license key and delegate.
 *
 *  @param licenseKey The Anyline license key for this application bundle
 *  @param delegate The delegate that will receive the Anyline results (hast to conform to <AnylineLicensePlateModuleDelegate>)
 *  @param error The error that occured
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setupWithLicenseKey:(NSString *)licenseKey
                   delegate:(id<AnylineLicensePlateModuleDelegate>)delegate
                      error:(NSError **)error;

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
- (void)anylineLicensePlateModuleView:(AnylineLicensePlateModuleView *)anylineLicensePlateModuleView
                        didFindResult:(ALLicensePlateResult *)scanResult;

@end
