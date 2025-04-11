#import <UIKit/UIKit.h>
#import "ALViewConstants.h"

/**
 * Flash status
 */
typedef NS_ENUM(NSInteger, ALFlashStatus) {
    /**
     * Flash always on
     */
    ALFlashStatusOn,
    /**
     * Flash always off
     */
    ALFlashStatusOff,
    /**
     * Flash automatically turning on or off depending on the amount of light in the environment
     */
    ALFlashStatusAuto
};


@class ALFlashButton;
@class ALFlashConfig;
@class ALFlashConfig;

@protocol ALFlashButtonStatusDelegate <NSObject>

- (void)flashButton:(ALFlashButton * _Nonnull)flashButton statusChanged:(ALFlashStatus)flashStatus;

@end


@protocol ALFlashButtonAnimationDelegate <NSObject>

@optional
- (void)flashButton:(ALFlashButton * _Nonnull)flashButton expanded:(BOOL)expanded;

@end


@interface ALFlashButton : UIControl

@property (nonatomic, assign) BOOL expanded;

@property (nullable, nonatomic, readonly) UIImageView *flashImageView;

@property (nonatomic, assign) ALFlashStatus flashStatus;

@property (nullable, nonatomic, weak) id<ALFlashButtonStatusDelegate> delegate;

@property (nullable, nonatomic, weak) id<ALFlashButtonAnimationDelegate> animationDelegate;

- (_Nullable instancetype)initWithFrame:(CGRect)frame
                            flashConfig:(ALFlashConfig * _Nonnull)flashConfig;

@end
