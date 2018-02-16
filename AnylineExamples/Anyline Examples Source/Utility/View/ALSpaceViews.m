//
//  ALSpaceViews.h
//  AnylineExamples
//
//  Created by David on 30/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALSpaceViews.h"

@implementation ALSpaceViews

+ (void)spaceViewsVertically:(NSArray*)views spacing:(NSInteger)spacing; {
    
    
    
    UIView * superview = [[views lastObject] superview];
    CGFloat width = superview.bounds.size.width;
    
    CGFloat offsetWidth = width - (spacing*views.count+2);
    CGFloat viewWidth =  views.count > 0 ? lroundf(offsetWidth / views.count) : superview.frame.size.width-spacing*2;

    CGFloat position = spacing;
    
    for (UIView * v in views) {
        v. frame = CGRectMake(position,  v.frame.origin.y,
                              viewWidth, v.frame.size.height );
        position += spacing+viewWidth;
    }
    
}

@end
