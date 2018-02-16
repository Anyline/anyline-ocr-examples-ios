//
//  ALCustomBarButtonItemView.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 18/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALCustomBarButton.h"

@implementation ALCustomBarButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType image:(UIImage *)image title:(NSString *)title {
    ALCustomBarButton *button = (ALCustomBarButton *)[super buttonWithType:buttonType];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    //button.frame = CGRectMake(0, 0, 100, 40);
    
    return button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.imageView.frame;
    frame = CGRectMake(truncf((self.bounds.size.width - frame.size.width) / 2), 0.0f, frame.size.width, frame.size.height);
    self.imageView.frame = frame;
    
    frame = self.titleLabel.frame;
    frame = CGRectMake(truncf((self.bounds.size.width - frame.size.width) / 2), self.bounds.size.height - frame.size.height, frame.size.width, frame.size.height);
    self.titleLabel.frame = frame;
}

@end
