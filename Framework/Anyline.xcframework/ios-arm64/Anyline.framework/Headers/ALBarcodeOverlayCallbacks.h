NS_ASSUME_NONNULL_BEGIN

@class ALDetectedBarcode, ALBarcodeOverlayView;


/// A callback type used in `-[ALScanView enableBarcodeOverlays:updateBlock:deleteBlock:]`.
/// When calling the method, pass a block of this type to the first parameter. In it,
/// you are to return an array of `ALBarcodeOverlayView`, based on the given
/// `ALDetectedBarcode` object.
typedef NSArray<ALBarcodeOverlayView *> *_Nonnull (^ALBarcodeOverlayCreateBlock)(ALDetectedBarcode *);

/// A callback type used in `-[ALScanView enableBarcodeOverlays:updateBlock:deleteBlock:]`.
/// When calling the method, you may pass a block of this type to the second parameter.
/// In it, you receive an array of `ALBarcodeOverlayView` as well as an `ALDetectedBarcode`
/// corresponding to the barcode whose position has been updated.
typedef void (^ALBarcodeOverlayUpdateBlock)(ALDetectedBarcode *, NSArray<ALBarcodeOverlayView *> *);

/// A callback type used in `-[ALScanView enableBarcodeOverlays:updateBlock:deleteBlock:]`.
/// When calling the method, you may pass a block of this type to the third parameter.
/// When called, you get an array of `ALBarcodeOverlayView` that are removed from
/// the Scan View when their barcode is no longer detected by the plugin.
typedef void (^ALBarcodeOverlayDeleteBlock)(NSArray<ALBarcodeOverlayView *> *);

NS_ASSUME_NONNULL_END
