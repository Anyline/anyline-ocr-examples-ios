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

@property (nonatomic, assign) BOOL expanded;

@property (nonatomic, assign) BOOL expandLeft;

@property (nullable, nonatomic, strong) UIImageView *flashImage;

@property (nullable, nonatomic, strong) ALFlashButtonConfig *flashButtonConfig;

@property (nonatomic, assign) ALFlashStatus flashStatus;

@property (nullable, nonatomic, weak) id<ALFlashButtonStatusDelegate> delegate;
@property (nullable, nonatomic, weak) id<ALFlashButtonAnimationDelegate> animationDelegate;

- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated;

- (_Nullable instancetype)initWithFrame:(CGRect)frame
                      flashButtonConfig:(ALFlashButtonConfig *_Nonnull)flashButtonConfig;


@end

