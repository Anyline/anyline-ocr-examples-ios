//
//  ALBarcodeScanPlugin.h
//  
//
//  Created by Daniel Albertini on 20/04/17.
//
//

#import "ALAbstractScanPlugin.h"
#import "ALBarcodeResult.h"

@protocol ALBarcodeScanPluginDelegate;

/**
 * The ALBarcodeScanPlugin class declares the programmatic interface for an object that manages easy access to Anylines barcode scanning mode. 
 *
 * Communication with the host application is managed with a delegate that conforms to ALBarcodeScanPluginDelegate & ALInfoDelegate.
 *
 * ALBarcodeScanPlugin is able to recognize the most common 1D and 2D codes. The accepted codes are set with setBarcodeFormatOptions.
 *
 */
@interface ALBarcodeScanPlugin : ALAbstractScanPlugin

/**
 *  Sets the type of code to recognize. Valid values are: kCodeTypeAztec, kCodeTypeCodabar, kCodeTypeCode39, kCodeTypeCode93, kCodeTypeCode128, kCodeTypeDataMatrix, kCodeTypeEAN8, kCodeTypeEAN13, kCodeTypeITF, kCodeTypePDF417, kCodeTypeQR, kCodeTypeRSS14, kCodeTypeRSSExpanded, kCodeTypeUPCA, kCodeTypeUPCE, kCodeTypeUPCEANExtension.
 *  Default are all of the above.
 *
 */
@property (nonatomic, assign) ALBarcodeFormatOptions barcodeFormatOptions;

/**
 *  Sets the license key and delegate.
 *
 *  @param licenseKey The Anyline license key for this application bundle
 *  @param delegate The delegate that will receive the Anyline results (hast to conform to <ALBarcodeScanPluginDelegate>)
 *  @param error The error that occured
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setupWithLicenseKey:(NSString * _Nonnull)licenseKey
                   delegate:(id<ALBarcodeScanPluginDelegate> _Nonnull)delegate
                      error:(NSError * _Nullable * _Nullable)error;

- (ALBarcodeFormat)barcodeFormatForString:(NSString * _Nullable)barcodeFormatString;

- (void)addDelegate:(id<ALBarcodeScanPluginDelegate> _Nonnull)delegate;

- (void)removeDelegate:(id<ALBarcodeScanPluginDelegate> _Nonnull)delegate;

@end

@protocol ALBarcodeScanPluginDelegate <NSObject>

@required
/**
 *  Returns the scanned value
 *
 *  @param anylineBarcodeScanPlugin The plugin
 *  @param scanResult The scanned value
 *
 */
- (void)anylineBarcodeScanPlugin:(ALBarcodeScanPlugin * _Nonnull)anylineBarcodeScanPlugin
                   didFindResult:(ALBarcodeResult * _Nonnull)scanResult;

@end
