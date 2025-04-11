#import <UIKit/UIKit.h>

@interface ALZoomHelper : NSObject

+ (UIGestureRecognizer *)createZoomGestureForTarget:(id)target selector:(SEL)selector;

+ (CGFloat)defaultMinZoomFactor;

+ (CGFloat)defaultCustomMaxZoomFactor;

// Utility Calculation between Focal Length and AVCaptureDevice.videoZoomFactor
+ (CGFloat)zoomFactorForFocalLength:(CGFloat)focalLength;

+ (CGFloat)focalLengthForZoomFactor:(CGFloat)factor;

// Utility Calculation between Zoom Ratio and AVCaptureDevice.videoZoomFactor
+ (CGFloat)zoomFactorForZoomRatio:(CGFloat)ratio;

+ (CGFloat)zoomRatioForZoomFactor:(CGFloat)factor;

@end
