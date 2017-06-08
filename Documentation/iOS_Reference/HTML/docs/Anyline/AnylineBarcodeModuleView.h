//
//  AnylineBarcodeModuleView.h
//  
//
//  Created by Daniel Albertini on 29/06/15.
//
//

#import "AnylineAbstractModuleView.h"
#import "ALBarcodeResult.h"
#import "ALBarcodeScanPlugin.h"

@protocol AnylineBarcodeModuleDelegate;

/**
 * The AnylineBarcodeModuleView class declares the programmatic interface for an object that manages easy access to Anylines barcode scanning mode. All its capabilities are bundled into this AnylineAbstractModuleView subclass. Management of the scanning process happens within the view object. It is configurable via interface builder.
 *
 * Communication with the host application is managed with a delegate that conforms to AnylineBarcodeModuleDelegate.
 *
 * AnylineBarcodeModuleView is able to scan the most common 1D and 2D codes. The accepted codes are set with setBarcodeFormatOptions.
 *
 */
@interface AnylineBarcodeModuleView : AnylineAbstractModuleView

@property (nonatomic, strong) ALBarcodeScanPlugin *barcodeScanPlugin;

/**
 *  Sets the type of code to recognize. Valid values are: kCodeTypeAztec, kCodeTypeCodabar, kCodeTypeCode39, kCodeTypeCode93, kCodeTypeCode128, kCodeTypeDataMatrix, kCodeTypeEAN8, kCodeTypeEAN13, kCodeTypeITF, kCodeTypePDF417, kCodeTypeQR, kCodeTypeRSS14, kCodeTypeRSSExpanded, kCodeTypeUPCA, kCodeTypeUPCE, kCodeTypeUPCEANExtension.
 *  Default are all of the above.
 *
 */
@property (nonatomic, assign) ALBarcodeFormatOptions barcodeFormatOptions;

/**
 *  When set to YES we only use the iOS native Barcode scanning. 
 *  That one uses less computing power, but is worse under low light conditions.
 */
@property (nonatomic, assign) BOOL useOnlyNativeBarcodeScanning;

/**
 *  Sets the license key and delegate.
 *
 *  @param licenseKey The Anyline license key for this application bundle
 *  @param delegate The delegate that will receive the Anyline results (hast to conform to <AnylineBarcodeModuleDelegate>)
 *  @param error The error that occured
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setupWithLicenseKey:(NSString *)licenseKey
                   delegate:(id<AnylineBarcodeModuleDelegate>)delegate
                      error:(NSError **)error;


@end

@protocol AnylineBarcodeModuleDelegate <NSObject>

@optional

/**
 *  Returns the scanned value
 *
 *  @param anylineBarcodeModuleView The view that scanned the result
 *  @param scanResult The scanned value
 *  @param barcodeFormat The barcode format of the scanned barcode
 *  @param image The image that was used to scan the barcode
 * 
 *  @deprecated since 3.10
 */
- (void)anylineBarcodeModuleView:(AnylineBarcodeModuleView *)anylineBarcodeModuleView
               didFindScanResult:(NSString *)scanResult
               withBarcodeFormat:(ALBarcodeFormat)barcodeFormat
                         atImage:(UIImage *)image __deprecated_msg("Deprecated since 3.10 Use method anylineBarcodeModuleView:didFindScanResult:withBarcodeFormat:atImage: instead.");


@required
/**
 *  Returns the scanned value
 *
 *  @param anylineBarcodeModuleView The view that scanned the result
 *  @param scanResult The scanned value
 *
 *  @since 3.10
 */
- (void)anylineBarcodeModuleView:(AnylineBarcodeModuleView *)anylineBarcodeModuleView
                   didFindResult:(ALBarcodeResult *)scanResult;

@end
