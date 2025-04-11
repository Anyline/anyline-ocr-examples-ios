#import <UIKit/UIKit.h>
#import "ALBarcodeOverlayCallbacks.h"

NS_ASSUME_NONNULL_BEGIN

@class ALDetectedBarcode, CADisplayLink, ALImage, ALBarcodeResult, ALCaptureDeviceManager;


@interface ALBarcodeOverlayContainerView : UIView

- (instancetype)initWithCaptureDeviceManager:(ALCaptureDeviceManager *)captureDeviceManager;

- (void)addBarcodeResult:(ALBarcodeResult *)latestBarcodeResult image:(ALImage *)image;

- (void)setCallbacksWithAddedBlock:(ALBarcodeOverlayCreateBlock _Nullable)addedBlock
                      updatedBlock:(ALBarcodeOverlayUpdateBlock _Nullable)updatedBlock
                      deletedBlock:(ALBarcodeOverlayDeleteBlock _Nullable)deletedBlock;

- (void)setBarcodeOverlayExpiryLength:(NSTimeInterval)duration;

- (void)removeAllOverlays;

@end


NS_ASSUME_NONNULL_END
