//
//  ALIdentityDocumentScanPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 15/03/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALAbstractScanPlugin.h"
#import "ALIDConfig.h"
#import "ALMRZConfig.h"
#import "ALDrivingLicenseConfig.h"
#import "ALGermanIDFrontConfig.h"
#import "ALUniversalIDConfig.h"
#import "ALIDResult.h"

@protocol ALIDPluginDelegate;

/**
 * The ALIDScanPlugin class declares the programmatic interface for an object that manages easy access to Anylines ID scanning mode..
 *
 * Communication with the host application is managed with a delegate that conforms to ALIDScanPluginDelegate & ALInfoDelegate. The information that gets read is passed to the delegate with the help of of an ALIdentification object.
 *
 */
@interface ALIDScanPlugin : ALAbstractScanPlugin

/**
 The Constructor for the IDScanPlugin.
 
 @param pluginID An unique pluginID to identify the results
 @param licenseKey The Anyline license key
 @param delegate The delegate to receive the results
 @param config The IDConfig object (DrivingLicense or MRZ)
 @param error The Error object if something fails
 @return Boolean indicating the success / failure of the call.
 */
- (instancetype _Nullable)initWithPluginID:(NSString * _Nullable)pluginID
                                  delegate:(id<ALIDPluginDelegate> _Nonnull)delegate
                                  idConfig:(ALIDConfig * _Nonnull)config
                                     error:(NSError *_Nullable *_Nullable)error;

- (instancetype _Nullable)init NS_UNAVAILABLE;

@property (nonatomic, strong, readonly) NSHashTable<ALIDPluginDelegate> * _Nullable delegates;

- (void)addDelegate:(id<ALIDPluginDelegate> _Nonnull)delegate;

- (void)removeDelegate:(id<ALIDPluginDelegate> _Nonnull)delegate;

@property (nullable, nonatomic, strong, readonly) ALIDConfig *idConfig;
/**
 *  Sets a new ALIdentityDocumentConfig and returns an Error if something failed.
 *
 *  @param idConfig   The ALIDConfig to set
 *  @param error      The Error object if something fails
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setIDConfig:(ALIDConfig * _Nonnull)idConfig error:(NSError *_Nullable * _Nullable)error;

@end

@protocol ALIDPluginDelegate <NSObject>

@required

/**
 *  Returns the scanned value
 *
 *  @param anylineIDScanPlugin The plugin that scanned the result
 *  @param scanResult The scanned value
 *
 */
- (void)anylineIDScanPlugin:(ALIDScanPlugin * _Nonnull)anylineIDScanPlugin
              didFindResult:(ALIDResult * _Nonnull)scanResult;



@end
