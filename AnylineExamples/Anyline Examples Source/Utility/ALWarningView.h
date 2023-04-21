#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ALWarningState) {
    ALWarningStateNone,
    ALWarningStateHoldStill,
    ALWarningStateTooDark,
    ALWarningStateTooBright,
    ALWarningStatePerfect,
    ALWarningStateIDNotSupported,
};

typedef NS_ENUM(NSUInteger, ALAnimationState) {
    ALAnimationStateVisible,
    ALAnimationStateAnimating,
    ALAnimationStateReady,
};

@interface ALWarningView : UIView

@property (nonatomic, readonly) NSInteger animationState;

- (void)setInfoString:(NSString *)text;

- (void)showWarning:(ALWarningState)newState;

- (void)hideWarning;

@end
