//
//  ALMRZScanPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 15/03/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALAbstractScanPlugin.h"
#import "ALMRZResult.h"

@protocol ALMRZScanPluginDelegate;

/**
 * The ALMRZScanPlugin class declares the programmatic interface for an object that manages easy access to Anylines MRZ scanning mode..
 *
 * Communication with the host application is managed with a delegate that conforms to ALMRZScanPluginDelegate & ALInfoDelegate. The information that gets read is passed to the delegate with the help of of an ALIdentification object.
 *
 */
@interface ALMRZScanPlugin : ALAbstractScanPlugin

/**
 *  Sets the license key and delegate.
 *
 *  @param licenseKey The Anyline license key for this application bundle
 *  @param delegate The delegate that will receive the Anyline results (hast to conform to <ALMRZScanPluginDelegate>)
 *  @param error The error that occured
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setupWithLicenseKey:(NSString * _Nonnull)licenseKey
                   delegate:(id<ALMRZScanPluginDelegate> _Nonnull)delegate
                      error:(NSError * _Nullable * _Nullable)error;

@end

@protocol ALMRZScanPluginDelegate <NSObject>

@required

/**
 *  Returns the scanned value
 *
 *  @param anylineMRZScanPlugin The plugin that scanned the result
 *  @param scanResult The scanned value
 *
 */
- (void)anylineMRZScanPlugin:(ALMRZScanPlugin * _Nonnull)anylineMRZScanPlugin
               didFindResult:(ALMRZResult * _Nonnull)scanResult;

@end
