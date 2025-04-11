@class ALOverlayConfig;
@class ALBarcodeOverlayLayoutGuide;
@class ALBarcode;
@class ALDetectedBarcode;
@class ALBarcodeOverlayView;

NS_ASSUME_NONNULL_BEGIN

/// A UIView that serves as the overlay to barcodes. You may
/// use it as a parent of a more complex view hierarchy. Once
/// supplied in the block `-[ALScanView enableBarcodeOverlays:]`,
/// the Scan View installs the view to itself, positioning it
/// where detected barcodes are found, and takes over the management
/// of its life cycle.
@interface ALBarcodeOverlayView : UIView

/// String uniquely identifying the overlay view
@property (nonatomic, readonly) NSString *label;

/// Initializes an ALBarcodeOverlayView.
- (instancetype)init;

/// Causes the view to be marked for deletion, allowing you to define
/// a different view in the next update cycle.
- (instancetype)initWithConfig:(ALOverlayConfig *)config;

/// Causes the view to be marked for deletion, allowing you to define
/// a different view in the next update cycle.
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
