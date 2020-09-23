//
//  ALViewConstants.h
//  Anyline
//
//  Created by Matthias Gasser on 04/05/15.
//  Copyright (c) 2015 9Yards GmbH. All rights reserved.
//

#ifndef Anyline_ALViewConstants_h
#define Anyline_ALViewConstants_h

/** Where the cutout should appear vertically on the screen
*/
typedef NS_ENUM(NSUInteger, ALCutoutAlignment) {
    /** Align to the TOP
    */
    ALCutoutAlignmentTop=0,
    /** Align in the middle between TOP and MIDDLE
    */
    ALCutoutAlignmentTopHalf=1,
    /** Align MIDDLE
    */
    ALCutoutAlignmentMiddle=2,
    /** Align in the middle between MIDDLE and BOTTOM
    */
    ALCutoutAlignmentBottomHalf=3,
    /** Align BOTTOM
    */
    ALCutoutAlignmentBottom=4
};

/** How the cutout should animate when starting or stopping the plugin
*/
typedef NS_ENUM(NSUInteger, ALCutoutAnimation) {
    /** No Animation
    */
    ALCutoutAnimationNone=0,
    /** Cutout will zoom in/out when starting/stopping a scanViewPlugin
    */
    ALCutoutAnimationZoom=1,
    /** Cutout will fade in/out when starting/stopping a scanViewPlugin
    */
    ALCutoutAnimationFade=2,
};


typedef NS_ENUM(NSUInteger, ALPictureResolution) {
    ALPictureResolutionNone=0,
    ALPictureResolutionHighest=1,
    ALPictureResolution1080=2,
    ALPictureResolution720=3,
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

typedef NS_ENUM(NSUInteger, ALCaptureViewMode) {
    ALCaptureViewModeBGRA=0,
    ALCaptureViewModeYUV=1
};

typedef NS_ENUM(NSUInteger, ALFlashMode) {
    ALFlashModeManual=0,
    ALFlashModeNone=1,
    ALFlashModeAuto=2
};

/**
 *  Alignment of the flash button within the scan view.
*/
typedef NS_ENUM(NSUInteger, ALFlashAlignment) {
    /**
     *  Top center. Equivalent to TOP in JSON config.
    */
    ALFlashAlignmentTop=0,
    /**
     *  Top left. Equivalent to TOP_LEFT in JSON config.
    */
    ALFlashAlignmentTopLeft=1,
    /**
     *  Top right. Equivalent to TOP_RIGHT in JSON config.
    */
    ALFlashAlignmentTopRight=2,
    /**
     *  Bottom center. Equivalent to BOTTOM in JSON config.
    */
    ALFlashAlignmentBottom=3,
    /**
     *  Bottom left. Equivalent to BOTTOM_LEFT in JSON config.
    */
    ALFlashAlignmentBottomLeft=4,
    /**
     *  Bottom right. Equivalent to BOTTOM_RIGHT in JSON config.
    */
    ALFlashAlignmentBottomRight=5
};

typedef NS_ENUM(NSInteger, ALUIFeedbackStyle) {
    ALUIFeedbackStyleRect=0,
    ALUIFeedbackStyleContourRect=1,
    ALUIFeedbackStyleContourUnderline=2,
    ALUIFeedbackStyleContourPoint=3,
    ALUIFeedbackStyleNone=4
};

typedef NS_ENUM(NSInteger, ALUIVisualFeedbackAnimation) {
    ALUIVisualFeedbackAnimationTraverseSingle=0,
    ALUIVisualFeedbackAnimationTraverseMulti=1,
    ALUIVisualFeedbackAnimationKitt=2,
    ALUIVisualFeedbackAnimationBlink=3,
    ALUIVisualFeedbackAnimationResize=4,
    ALUIVisualFeedbackAnimationPulse=5,
    ALUIVisualFeedbackAnimationPulseRandom=6,
    ALUIVisualFeedbackAnimationNone=7
};

#endif
