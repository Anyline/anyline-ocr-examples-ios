//
//  ALOCRScanPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 15/03/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALAbstractScanPlugin.h"
#import "ALOCRConfig.h"
#import "ALOCRResult.h"

@protocol ALOCRScanPluginDelegate;
/**
 *  The ALOCRScanPlugin can be used to recognize text.
 *  It can be adapted to different kinds of use cases with the {@link AnylineViewConfig} (settings for the camera and UI)
 *  and the {@link ALOOCRConfig} (settings to adapt the recognition to your use case).
 *
 */
@interface ALOCRScanPlugin : ALAbstractScanPlugin

/**
 *  Read-only property for the ALOCRConfig
 *
 *  Use method setOCRConfig:error: for setting the config.
 */
@property (nullable, nonatomic, strong, readonly) ALOCRConfig *ocrConfig;

/**
 *  Sets the license key and delegate.
 *
 *  @param licenseKey   The Anyline license key for this application bundle
 *  @param delegate     The delegate that will receive the Anyline results (hast to conform to <ALOCRScanPluginDelegate>)
 *  @param ocrConfig    The ocrConfig to use for the scanning
 *  @param error        The error that occured
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setupWithLicenseKey:(NSString * _Nonnull)licenseKey
                   delegate:(id<ALOCRScanPluginDelegate> _Nonnull)delegate
                  ocrConfig:(ALOCRConfig * _Nonnull)ocrConfig
                      error:(NSError * _Nullable * _Nullable)error;
/**
 *  Sets a new ALOCRConfig and returns an Error if something failed.
 *
 *  @param ocrConfig The ALOCRConfig to set
 *  @param error     The Error object if something fails
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setOCRConfig:(ALOCRConfig * _Nonnull)ocrConfig error:(NSError * _Nullable * _Nullable)error;
/**
 *  Use this method to copy a custom trained font data into the Anyline work environment.
 *  This method is mandatory if you want to use custom fonts.
 *
 *  @param trainedDataPath  The full path to your trained data file
 *  @param fileHash         The hash of the traineddata file so Anyline knows when it changed.
 *  @param error            The Error object if something fails
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)copyTrainedData:(NSString * _Nonnull)trainedDataPath
               fileHash:(NSString * _Nullable)hash
                  error:(NSError * _Nullable * _Nullable)error;

- (void)addDelegate:(id<ALOCRScanPluginDelegate> _Nonnull)delegate;

- (void)removeDelegate:(id<ALOCRScanPluginDelegate> _Nonnull)delegate;

@end

/**
 *  The delegate for the ALOCRScanPluginDelegate.
 */
@protocol ALOCRScanPluginDelegate <NSObject>

@required

/**
 *  Called when a result is found
 *
 *  @param anylineOCRScanPlugin The ALOCRScanPlugin
 *  @param result               The result object
 */
- (void)anylineOCRScanPlugin:(ALOCRScanPlugin * _Nonnull)anylineOCRScanPlugin
               didFindResult:(ALOCRResult * _Nonnull)result;

@end

