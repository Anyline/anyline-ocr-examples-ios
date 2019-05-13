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
#import "ALBarcodeScanViewPlugin.h"

@protocol AnylineBarcodeModuleDelegate;

/**
 * The AnylineBarcodeModuleView class declares the programmatic interface for an object that manages easy access to Anylines barcode scanning mode. All its capabilities are bundled into this AnylineAbstractModuleView subclass. Management of the scanning process happens within the view object. It is configurable via interface builder.
 *
 * Communication with the host application is managed with a delegate that conforms to AnylineBarcodeModuleDelegate.
 *
 * AnylineBarcodeModuleView is able to scan the most common 1D and 2D codes. The accepted codes are set with setBarcodeFormatOptions.
 *
 */

__attribute__((deprecated("As of release 10.1, use an ALScanView, combined with an ALBarcodeScanViewPlugin instead. This class will be removed by November 2019.")))
@interface AnylineBarcodeModuleView : AnylineAbstractModuleView

@property (nullable, nonatomic, strong) ALBarcodeScanPlugin *barcodeScanPlugin;

@property (nullable, nonatomic, strong) ALBarcodeScanViewPlugin *barcodeScanViewPlugin;

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
- (BOOL)setupWithLicenseKey:(NSString * _Nonnull)licenseKey
                   delegate:(id<AnylineBarcodeModuleDelegate> _Nonnull)delegate
                      error:(NSError * _Nullable * _Nullable )error;

/**
 *  Sets the license key and delegate. Async method with return block when done.
 *
 *  @param licenseKey The Anyline license key for this application bundle
 *  @param delegate The delegate that will receive the Anyline results (hast to conform to <AnylineBarcodeModuleDelegate>)
 *  @param finished Inidicating if setup is finished with an error object when setup failed.
 *
 */
- (void)setupAsyncWithLicenseKey:(NSString * _Nonnull)licenseKey
                        delegate:(id<AnylineBarcodeModuleDelegate> _Nonnull)delegate
                        finished:(void (^_Nonnull)(BOOL success, NSError * _Nullable error))finished;

@end

__attribute__((deprecated("As of release 10.1, use an ALBarcodeScanPluginDelegate, combined with an ALBarcodeScanPluing instead. This class will be removed by November 2019.")))
@protocol AnylineBarcodeModuleDelegate <NSObject>

@required
/**
 *  Returns the scanned value
 *
 *  @param anylineBarcodeModuleView The view that scanned the result
 *  @param scanResult The scanned value
 *
 *  @since 3.10
 */
- (void)anylineBarcodeModuleView:(AnylineBarcodeModuleView * _Nonnull)anylineBarcodeModuleView
                   didFindResult:(ALBarcodeResult * _Nonnull)scanResult;

@end
