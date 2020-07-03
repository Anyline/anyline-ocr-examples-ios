//
//  ALWarningView.h
//  AnylineExamples
//
//  Created by David on 01/06/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

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

- (void)setInfoString:(NSString*)text;
- (void)setInfoImage:(UIImage*)image;

@property (nonatomic) NSInteger animationState;
@property (nonatomic) NSDate * disappearanceDate;

- (void)showWarning:(ALWarningState)newState;
- (void)hideWarning;

@end
