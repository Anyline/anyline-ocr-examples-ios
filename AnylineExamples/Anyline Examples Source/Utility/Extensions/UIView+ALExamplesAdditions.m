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
    
@end
