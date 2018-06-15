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

@property (nonatomic, strong, readonly) NSHashTable<ALMRZScanPluginDelegate> * _Nullable delegates;

/**
 *  If strictMode is enabled, results will only be returned when all checkDigits are valid.
 *  Default strictMode = false
 */
@property (nonatomic) BOOL strictMode;

/**
 *  If cropAndTransformID is enabled, the detected identification document will be cropped and the image will be returned.
 *  Default strictMode = false
 */
@property (nonatomic) BOOL cropAndTransformID;

/**
 *  Sets the license key and delegate.
 *
 *  @param licenseKey The Anyline license key for this application bundle
 *  @param delegate The delegate that will receive the Anyline results (hast to conform to <ALMRZScanPluginDelegate>)
 *  @param finished Inidicating if setup is finished with an error object when setup failed.
 */
- (void)setupWithLicenseKey:(NSString * _Nonnull)licenseKey
                   delegate:(id<ALMRZScanPluginDelegate> _Nonnull)delegate
                   finished:(void (^_Nonnull)(BOOL success, NSError * _Nullable error))finished;

- (void)addDelegate:(id<ALMRZScanPluginDelegate> _Nonnull)delegate;

- (void)removeDelegate:(id<ALMRZScanPluginDelegate> _Nonnull)delegate;

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
