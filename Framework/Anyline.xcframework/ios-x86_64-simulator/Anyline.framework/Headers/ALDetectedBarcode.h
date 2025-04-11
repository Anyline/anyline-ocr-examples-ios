#import <Foundation/Foundation.h>

@class ALBarcode;

NS_ASSUME_NONNULL_BEGIN

/// A barcode object scanned by the plugin. You can call `getBarcodeImage()` on
/// it to obtain the cropped image containing the barcode found, as well as
/// `getBarcodeRect()` to get the CGRect value of the detected barcode.
@interface ALDetectedBarcode : NSObject

/// Unique identifier for the detected barcode
@property (nonatomic, readonly) NSString *label;

/// The object corresponding to the barcode detected.
@property (nonatomic, readonly) ALBarcode *barcode;

/// The CGRect of the scanned barcode within the frame at the time
/// of its detection.
@property (nonatomic, readonly) CGRect enclosingCGRect;

/// Creates and returns a cropped image containing the barcode.
- (UIImage *)barcodeImage;

@end

NS_ASSUME_NONNULL_END
