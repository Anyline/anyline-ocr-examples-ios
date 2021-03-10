//
//  UIButton+ALExamplesExtensions.m
//  AnylineExamples
//
//  Created by Angela Brett on 09.10.20.
//

#import "UIButton+ALExamplesExtensions.h"
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"

@interface ALButton : UIButton

@end

@implementation ALButton

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled) {
        self.backgroundColor = UIColor.AL_examplesBlue;
    } else {
        self.backgroundColor = UIColor.lightGrayColor;
    }
}

@end

@implementation UIButton (ALExamplesExtensions)


+ (CGFloat)roundedButtonHeight {
    return 44.0;
}

+ (CGFloat)socialButtonSize {
    return 24.0;
}

+ (CGFloat)roundedButtonHorizontalMargin {
    return 24;
}

+ (instancetype)roundedButton {
    UIButton *button = [ALButton buttonWithType:UIButtonTypeCustom];
    if (button) {
        button.backgroundColor = [UIColor AL_examplesBlue];
        button.titleLabel.textColor = UIColor.whiteColor;
        button.titleLabel.tintColor = UIColor.whiteColor;
        button.layer.cornerRadius = [self roundedButtonHeight]/2;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = [UIFont AL_proximaBoldWithSize:16];
    }
    return button;
}

@end
