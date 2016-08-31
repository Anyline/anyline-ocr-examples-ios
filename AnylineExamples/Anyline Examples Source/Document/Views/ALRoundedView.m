//
//  ALRoundedView.m
//  Anyline
//
//  Created by David Dengg on 18.01.16.
//  Copyright © 2016 9Yards GmbH. All rights reserved.
//

#import "ALRoundedView.h"


@implementation ALRoundedView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.borderColor = [UIColor greenColor];
        self.fillColor = [UIColor yellowColor];
        self.cornerRadius = 15;
        self.opaque = NO;
        
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGRect frame = CGRectInset(self.bounds, 0, 0);
    
    CGRect mainRect = frame;
    if(nil != _borderColor && _borderWidth > 0) {
        UIBezierPath *outlinePath = [UIBezierPath bezierPathWithRoundedRect:frame
                                                               cornerRadius:self.cornerRadius + _borderWidth/2];
        
        [_borderColor set];
        [outlinePath fill];
        
        mainRect = CGRectInset(frame, _borderWidth, _borderWidth);
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:mainRect cornerRadius:self.cornerRadius];
    
    [_fillColor set];
    [path fill];
}

@end
