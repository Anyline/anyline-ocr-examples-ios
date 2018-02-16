//
//  ALMeterSelectView.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 29/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALMeterSelectView.h"
#import "ALRoundedView.h"

#import "ALSpaceViews.h"

@interface ALMeterSelectView ()

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView * selectionView;

@property (nonatomic, assign) NSInteger maxDigits;
@property (nonatomic, assign) NSInteger minDigits;

@property (nonatomic, assign) BOOL isAnimating;

@end


NSInteger kMeterSelectDigitSpacing = 3;

@implementation ALMeterSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame maxDigits:7 minDigits:4 startDigits:5];
}

- (instancetype)initWithFrame:(CGRect)frame
                    maxDigits:(NSInteger)maxDigitCount
                    minDigits:(NSInteger)minDigitCount
                  startDigits:(NSInteger)startDigits
{
    self.digitCount = maxDigitCount;
    
    self.maxDigits = maxDigitCount;
    self.minDigits = minDigitCount;
    
    self = [super initWithFrame:frame];
    if (self) {
        {
            UIView * bg = [[UIView alloc] initWithFrame:CGRectMake(50, 0, frame.size.width/1.5, frame.size.height)];
            bg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
            bg.center = CGPointMake(lroundf(frame.size.width/2), frame.size.height/2);
            [self addSubview:bg];
            self.selectionView = bg;
        }
        
        {
            for (int i = 1; i<= maxDigitCount; i++) {
                ALRoundedView * digit = [[ALRoundedView alloc] initWithFrame:CGRectMake(0, 5, 20, frame.size.height - 10)];
                digit.backgroundColor = [UIColor clearColor];
                digit.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
                digit.cornerRadius = 0;
                digit.borderWidth = 3;
                [digit.textLabel setText:[NSString stringWithFormat:@"%i", i]];
                [digit.textLabel setTextAlignment:NSTextAlignmentCenter];
                [digit.textLabel setFont:[UIFont systemFontOfSize:19]];
                [self.selectionView addSubview:digit];
                
            }
            
            [ALSpaceViews spaceViewsVertically:self.selectionView.subviews spacing:kMeterSelectDigitSpacing];
        }
        
        CGFloat buttonWidth = frame.size.height-10;
        CGFloat borderOffset = self.selectionView.frame.origin.x;
        
        { // Left button
            ALRoundedView * bt = [[ALRoundedView alloc] initWithFrame:CGRectMake(borderOffset/2 - buttonWidth/2, 5, buttonWidth, buttonWidth)];
            bt.cornerRadius = 100;
            bt.borderColor = [UIColor clearColor];
            bt.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
            [bt.textLabel setText:@"-"];
            [bt.textLabel setFont:[UIFont systemFontOfSize:29]];
            [self addSubview:bt];
            [bt addTarget:self selector:@selector(leftButtonPressed:)];
        }
        
        
        { // Right button
            ALRoundedView * bt = [[ALRoundedView alloc] initWithFrame:CGRectMake(frame.size.width-borderOffset/2-buttonWidth/2, 5, buttonWidth, buttonWidth)];
            bt.cornerRadius = 100;
            bt.borderColor = [UIColor clearColor];
            bt.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
            [bt.textLabel setText:@"+"];
            [bt.textLabel setFont:[UIFont systemFontOfSize:29]];
            [self addSubview:bt];
            [bt addTarget:self selector:@selector(rightButtonPressed:)];
        }
        
        [self changeSelectionTo:startDigits animated:NO];
    }
    return self;
}

- (IBAction)leftButtonPressed:(id)sender {
    [self changeSelectionTo:(_digitCount-1) animated:YES];
}

- (IBAction)rightButtonPressed:(id)sender {
    [self changeSelectionTo:(_digitCount+1) animated:YES];
}

- (void)changeSelectionTo:(NSInteger)digitsCount animated:(BOOL)animated {
    if (self.isAnimating == YES) {
        return;
    }
    self.isAnimating = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
    
    NSArray * digits = self.selectionView.subviews;
    digitsCount = MIN(digitsCount, self.maxDigits);
    digitsCount = MAX(digitsCount, self.minDigits);
    
    if(digitsCount == self.digitCount) {
        return;
    }
    
    [self.layer removeAllAnimations];
    BOOL shrinks = (digitsCount < self.digitCount);
    
    for (NSInteger i = 0; i < digits.count; i++) {
        ALRoundedView * digit = digits[i];
        
        CGFloat newWidth = digitsCount*(digit.frame.size.width+kMeterSelectDigitSpacing) + kMeterSelectDigitSpacing;
        
        [UIView animateWithDuration:animated ? 0.5 : 0  animations:^{
            self.selectionView.frame = CGRectMake(self.selectionView.frame.origin.x,
                                                  self.selectionView.frame.origin.y,
                                                  newWidth,
                                                  self.selectionView.frame.size.height);
            self.selectionView.center = CGPointMake(self.center.x, self.selectionView.center.y);
        }];
        
        NSInteger newAlpha = i+1 > digitsCount ? 0 : 1;
        BOOL viewChanges = newAlpha != digit.alpha;
        
        if (shrinks && viewChanges) {
            [digit setTransform:CGAffineTransformIdentity];
        }
        if (!shrinks && viewChanges) {
            [digit setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 2, 2)];
        }

        
        [UIView animateWithDuration:animated ? 0.4 : 0  animations:^{
            [digit setAlpha:newAlpha];
            
            if( viewChanges && !shrinks ) {
                [digit setTransform:CGAffineTransformIdentity];
            }
            if( viewChanges && shrinks ) {
                [digit setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)];
            }

        } completion:^(BOOL finished) {
            [digit setTransform:CGAffineTransformIdentity];
        }];
    }
    
    self.digitCount = digitsCount;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(meterSelectView:didChangeDigitCount:)]) {
        [self.delegate meterSelectView:self didChangeDigitCount:digitsCount];
    }
}

@end
