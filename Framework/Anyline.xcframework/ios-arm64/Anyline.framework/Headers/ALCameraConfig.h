#import <UIKit/UIKit.h>
#import "ALJSONUtilities.h"

/// Picture resolution for ALCameraConfig
typedef NS_ENUM(NSUInteger, ALPictureResolution) {

    /// none specified
    ALPictureResolutionNone=0,

    /// the highest resolution possible
    ALPictureResolutionHighest=1,

    /// 1080p
    ALPictureResolution1080=2,

    /// 720p
    ALPictureResolution720=3,

    /// 480p
    ALPictureResolution480=4,
};

/**
 *  Capture resolution for ALCameraConfig. Only ALCaptureViewResolution1080 is supported.
 */
typedef NS_ENUM(NSUInteger, ALCaptureViewResolution) {
    /**
     *  1080p resolution
     */
    ALCaptureViewResolution1080=0,
    /**
     *  @deprecated since Anyline 3.22. Use ALCaptureViewResolution1080 instead
     */
    ALCaptureViewResolution720 DEPRECATED_ATTRIBUTE = 1,
    /**
     *  @deprecated since Anyline 3.22. Use ALCaptureViewResolution1080 instead
     */
    ALCaptureViewResolution480 DEPRECATED_ATTRIBUTE = 2
};

NS_ASSUME_NONNULL_BEGIN

/// An object that configures the scan view camera
@interface ALCameraConfig : NSObject <ALJSONStringRepresentable>

/// Camera to be used for scanning. Could be "FRONT" or "BACK"
@property (nonatomic, readonly, nullable) NSString *defaultCamera;

/// Resolution in which the camera operates. Currently only 1080p is supported.
@property (nonatomic, readonly) ALCaptureViewResolution captureResolution;

/// Picture resolution in which the camera operates. Currently only 1080p is supported.
@property (nonatomic, readonly) ALPictureResolution pictureResolution;

/// Camera focal length (default: 1)
@property (nonatomic, readonly) CGFloat zoomFactor;

/// Camera max focal length. Default: 0 => Device maxAvailableVideoZoom
@property (nonatomic, readonly) CGFloat maxZoomFactor;

/// Determines whether the pinch-to-zoom gesture is enabled. Defaults to false
@property (nonatomic, readonly) BOOL zoomGesture;

/// Initializes an ALCameraConfig with an NSDictionary representing the JSON config object
/// @param JSONDictionary NSDictionary representing the JSON config object
/// @param error NSError object which is filled with appropriate information when initialization fails
/// @return an instance of ALCameraConfig
- (instancetype _Nullable)initWithJSONDictionary:(NSDictionary * _Nonnull)JSONDictionary
                                           error:(NSError * _Nullable * _Nullable)error;

/// Creates an ALCameraConfig with an NSDictionary representing the JSON config object
/// @param JSONDictionary NSDictionary representing the JSON config object
/// @return an instance of ALCameraConfig
+ (instancetype _Nullable)withJSONDictionary:(NSDictionary * _Nonnull)JSONDictionary;

/// Creates an ALCameraConfig with default values, suitable for further custimization
/// @return an instance of ALCameraConfig
+ (instancetype)defaultCameraConfig;

/// Initializes an `ALCameraConfig` object.
/// @param defaultCamera Camera to be used for scanning. Could be "FRONT" or "BACK"
/// @param captureResolution Resolution in which the camera operates. Currently only 1080p is supported.
/// @param pictureResolution Picture resolution in which the camera operates. Currently only 1080p is supported.
/// @param zoomFactor Camera focal length (default: 1)
/// @param maxZoomFactor Camera max focal length. Default: 0 => Device maxAvailableVideoZoom
/// @param zoomGesture Determines whether the pinch-to-zoom gesture is enabled. Defaults to false
- (instancetype)initWithDefaultCamera:(NSString *)defaultCamera
                captureViewResolution:(ALCaptureViewResolution)captureResolution
                    pictureResolution:(ALPictureResolution)pictureResolution
                           zoomFactor:(CGFloat)zoomFactor
                        maxZoomFactor:(CGFloat)maxZoomFactor
                          zoomGesture:(BOOL)zoomGesture NS_DESIGNATED_INITIALIZER;

/// Creates an `ALCameraConfig` object.
/// @param defaultCamera Camera to be used for scanning. Could be "FRONT" or "BACK"
/// @param captureResolution Resolution in which the camera operates. Currently only 1080p is supported.
/// @param pictureResolution Picture resolution in which the camera operates. Currently only 1080p is supported.
/// @param zoomFactor Camera focal length (default: 1)
/// @param maxZoomFactor Camera max focal length. Default: 0 => Device maxAvailableVideoZoom
/// @param zoomGesture Determines whether the pinch-to-zoom gesture is enabled. Defaults to false
+ (ALCameraConfig *)withDefaultCamera:(NSString *)defaultCamera
                captureViewResolution:(ALCaptureViewResolution)captureResolution
                    pictureResolution:(ALPictureResolution)pictureResolution
                           zoomFactor:(CGFloat)zoomFactor
                        maxZoomFactor:(CGFloat)maxZoomFactor
                          zoomGesture:(BOOL)zoomGesture;

@end

NS_ASSUME_NONNULL_END
