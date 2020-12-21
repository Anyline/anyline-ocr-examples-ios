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
 * The ALBarcodeScanPlugin class declares the programmatic interface for an object that manages easy access to Anyline's barcode scanning mode.
 *
 * Communication with the host application is managed with a delegate that conforms to ALBarcodeScanPluginDelegate & ALInfoDelegate.
 *
 * ALBarcodeScanPlugin is able to recognize the most common 1D and 2D codes. The accepted codes are set with setBarcodeFormatOptions.
 *
 */
@interface ALBarcodeScanPlugin : ALAbstractScanPlugin

- (instancetype _Nullable)init NS_UNAVAILABLE;
/**
 Constructor for the BarcodeScanPlugin
 
 @param pluginID An unique pluginID
 @param delegate The delegate which receives the results
 @param error The Error object if something fails
 
 @return Boolean indicating the success / failure of the call.
 */
- (instancetype _Nullable)initWithPluginID:(NSString * _Nullable)pluginID
                                  delegate:(id<ALBarcodeScanPluginDelegate> _Nonnull)delegate
                                     error:(NSError *_Nullable *_Nullable)error;

@property (nonatomic, strong, readonly) NSHashTable<ALBarcodeScanPluginDelegate> * _Nullable delegates;

/**
 *  Sets the type of code to recognize. Valid values are:
    kCodeTypeAztec, kCodeTypeCodabar, kCodeTypeCode39, kCodeTypeCode93,
    kCodeTypeCode128, kCodeTypeDataMatrix, kCodeTypeEAN8, kCodeTypeEAN13,
    kCodeTypeITF, kCodeTypePDF417, kCodeTypeQR, kCodeTypeRSS14, kCodeTypeRSSExpanded,
    kCodeTypeUPCA, kCodeTypeUPCE, kCodeTypeUPCEANExtension.
 *  Default are all of the above.
 *
 */
@property (nonatomic, strong) NSArray<NSString*> * _Nonnull barcodeFormatOptions;


/**
 *
 *  Enables / Disables multi barcode scanning
 *
 */

@property (nonatomic, assign) BOOL multiBarcode;

- (void)addDelegate:(id<ALBarcodeScanPluginDelegate> _Nonnull)delegate;

- (void)removeDelegate:(id<ALBarcodeScanPluginDelegate> _Nonnull)delegate;

@end

@protocol ALBarcodeScanPluginDelegate <NSObject>

@required
/**
 *  Returns the scanned values
 *
 *  @param anylineBarcodeScanPlugin The plugin
 *  @param scanResult The scanned values
 *
 */
- (void)anylineBarcodeScanPlugin:(ALBarcodeScanPlugin * _Nonnull)anylineBarcodeScanPlugin didFindResult:(ALBarcodeResult*_Nonnull)scanResult;


@optional
/**
 *  Will be called as soon as the ALBarcodeFormatOptions of the scanPlugin have been modified.
 *
 *  @param anylineBarcodeScanPlugin The plugin
 *  @param barcodeFormats the updated barcode formats
 *
 */
- (void)anylineBarcodeScanPlugin:(ALBarcodeScanPlugin * _Nonnull)anylineBarcodeScanPlugin
           updatedBarcodeFormats:(NSArray<NSString*> * _Nonnull)barcodeFormats;

@end    
