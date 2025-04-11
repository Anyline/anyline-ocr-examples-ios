#ifndef Anyline_ALViewConstants_h
#define Anyline_ALViewConstants_h

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

typedef NS_ENUM(NSUInteger, ALCaptureViewMode) {
    ALCaptureViewModeBGRA=0,
    ALCaptureViewModeYUV=1
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
