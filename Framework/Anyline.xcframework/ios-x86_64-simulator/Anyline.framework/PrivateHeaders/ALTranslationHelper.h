#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class ALViewPluginConfig;
@class ALCaptureDeviceManager;
@class ALSquare;
@class ALRect;
@class ALCutoutConfigAlignment;
@class ALOffset;


@interface ALTranslationHelper : NSObject

+ (CGPoint)convertedPointFromPoint:(CGPoint)point captureDeviceManager:(ALCaptureDeviceManager *)cdm;

+ (ALSquare *)convertedSquareFromRect:(ALRect *)rect
                 captureDeviceManager:(ALCaptureDeviceManager *)cdm;

+ (ALSquare *)convertedSquareFromSquare:(ALSquare *)square
                   captureDeviceManager:(ALCaptureDeviceManager *)cdm;

+ (CGSize)targetSizeForFrame:(CGRect)frame
                  cutoutPath:(UIBezierPath *)cutoutPath
          cutoutWidthPercent:(CGFloat)cutoutWidthPercent
       cutoutMaxPercentWidth:(CGFloat)cutoutMaxPercentWidth
      cutoutMaxPercentHeight:(CGFloat)cutoutMaxPercentHeight;

+ (UIBezierPath *)bezierPathForTranslatePath:(UIBezierPath *)path
                                       frame:(CGRect)frame
                                 toAlignment:(ALCutoutConfigAlignment *)cutoutAlignment
                                  targetSize:(CGSize)targetSize
                             cameraFrameSize:(CGSize)cameraFrameSize
                                cutoutOffset:(ALOffset *)cutoutOffset
                        interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

+ (CGRect)rectForRect:(CGRect)rect withPadding:(CGSize)padding;

+ (CGRect)rectForRect:(CGRect)rect withOffset:(CGPoint)offset;

+ (CGRect)rectSafeguard:(CGRect)rect forFrameSize:(CGSize)frameSize;

/// The interface orientation of the scene `view` is in, or `UIInterfaceOrientationUnknown`
/// when it is not in a window yet. Run on main thread only (it reads `view.window`).
+ (UIInterfaceOrientation)interfaceOrientationForView:(UIView *)view;

+ (AVCaptureVideoOrientation)interfaceOrientationToVideoOrientation:(UIInterfaceOrientation)orientation;

+ (UIInterfaceOrientation)videoOrientationToInterfaceOrientation:(AVCaptureVideoOrientation)orientation;

@end
