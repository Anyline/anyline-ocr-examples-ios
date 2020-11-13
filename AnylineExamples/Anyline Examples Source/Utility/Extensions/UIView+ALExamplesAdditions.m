//
//  UIView+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Philipp Müller on 29/01/18.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import "UIView+ALExamplesAdditions.h"

@implementation UIView (ALExamplesAdditions)

- (void)removeAllSubviews {
    NSArray *subviews = [self.subviews copy];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)addConstraintsToSuperviewWithMargin:(CGFloat)margin {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.superview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor constant:margin].active = YES;
    [self.rightAnchor constraintEqualToAnchor:self.superview.rightAnchor constant:-margin].active = YES;
    [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:margin].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor constant:-margin].active = YES;
}
    
@end
