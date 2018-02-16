//
//  ALToggleControl.m
//  AnylineExamples
//
//  Created by Philipp Müller on 29/01/2018.
//  Copyright © 2018 9yards GmbH. All rights reserved.
//

#import "ALToggleControl.h"

@interface ALToggleControl ()
    
@property (strong, nonatomic) UIButton  *button;
    
@end

@implementation ALToggleControl
    
#pragma mark - CA
    
-(void)setImageWhenOff:(UIImage *)imageWhenOff {
    if (_imageWhenOff != imageWhenOff) {
        _imageWhenOff = imageWhenOff;
        
        [self _handleButton];
    }
}
    
-(void)setImageWhenOn:(UIImage *)imageWhenOn {
    if (_imageWhenOn != imageWhenOn) {
        _imageWhenOn = imageWhenOn;
        
        [self _handleButton];
    }
}
    
-(void)setBackgroundImageWhenOff:(UIImage *)backgroundImageWhenOff {
    if (_backgroundImageWhenOff != backgroundImageWhenOff) {
        _backgroundImageWhenOff = backgroundImageWhenOff;
        
        [self _handleButton];
    }
}
    
-(void)setBackgroundImageWhenOn:(UIImage *)backgroundImageWhenOn {
    if (_backgroundImageWhenOn != backgroundImageWhenOn) {
        _backgroundImageWhenOn = backgroundImageWhenOn;
        
        [self _handleButton];
    }
}
    
-(void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    
    [self _handleButton];
}
    
#pragma mark - Life
    
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}
    
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
    }
    return self;
}
    
-(CGSize)intrinsicContentSize {
    return self.imageWhenOn.size;
}
    
-(void)_init {
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = self.bounds;
    self.button.adjustsImageWhenHighlighted = NO;
    self.button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.button addTarget:self action:@selector(internalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.button];
}
    
#pragma mark - Actions
    
- (void)internalButtonAction:(UIButton *)sender {
    self.isOn = !self.isOn;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
    
#pragma mark - Util
    
-(void)_handleButton {
    [self invalidateIntrinsicContentSize];
    
    if (self.isOn) {
        [self.button setImage:self.imageWhenOn forState:UIControlStateNormal];
        [self.button setBackgroundImage:self.backgroundImageWhenOn forState:UIControlStateNormal];
    }
    else {
        [self.button setImage:self.imageWhenOff forState:UIControlStateNormal];
        [self.button setBackgroundImage:self.backgroundImageWhenOff forState:UIControlStateNormal];
    }
}
    
    @end
