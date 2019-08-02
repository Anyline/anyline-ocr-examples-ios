//
//  ALFlashButtonDelegate.h
//  rb-code-scanner
//
//  Created by David Dengg on 17.10.14.
//  Copyright (c) 2014 David Dengg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALViewConstants.h"
#import "ALFlashButtonConfig.h"

typedef NS_ENUM(NSInteger, ALFlashStatus) {
    ALFlashStatusOn,
    ALFlashStatusOff,
    ALFlashStatusAuto
};


@class ALFlashButton;

@protocol ALFlashButtonStatusDelegate <NSObject>
- (void)flashButton:(ALFlashButton * _Nonnull)flashButton statusChanged:(ALFlashStatus)flashStatus;
@end

@protocol ALFlashButtonAnimationDelegate <NSObject>
@optional
- (void)flashButton:(ALFlashButton * _Nonnull)flashButton expanded:(BOOL)expanded;
@end

@interface ALFlashButton : UIControl

@property (nonatomic, assign, readonly) BOOL expanded;

@property (nullable, nonatomic, strong, readonly) UIImageView *flashImage;

@property (nonatomic, assign) ALFlashStatus flashStatus;

@property (nullable, nonatomic, weak) id<ALFlashButtonStatusDelegate> delegate;
@property (nullable, nonatomic, weak) id<ALFlashButtonAnimationDelegate> animationDelegate;

- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated;

- (_Nullable instancetype)initWithFrame:(CGRect)frame
                      flashButtonConfig:(ALFlashButtonConfig *_Nonnull)flashButtonConfig;


@end

