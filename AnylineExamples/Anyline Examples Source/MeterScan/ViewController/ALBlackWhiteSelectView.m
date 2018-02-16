//
//  ALBlackWhiteSelectView
//  AnylineExamples
//
//  Created by Daniel Albertini on 29/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALBlackWhiteSelectView.h"
#import "ALRoundedView.h"

#import "ALSpaceViews.h"
#import "UIColor+ALExamplesAdditions.h"


@interface ALBlackWhiteSelectView ()

@property (nonatomic, strong) ALRoundedView *leftButton;
@property (nonatomic, strong) ALRoundedView *rightButton;

@property (nonatomic, strong) UIView * selectionView;

@property (nonatomic, assign) NSInteger digitCount;

@end

NSInteger kBlackWhiteSelectDigitSpacing = 3;


@implementation ALBlackWhiteSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame digits:5 activeSelection:ALBWReadingTypeBlackText];
}

- (instancetype)initWithFrame:(CGRect)frame digits:(NSInteger)digits activeSelection:(ALBWReadingType)activeSelection {
    
    self = [super initWithFrame:frame];
    if (self) {
        {
            UIView * bg = [[UIView alloc] initWithFrame:CGRectMake(50, 0, lround(frame.size.width/1.5), frame.size.height)];
            bg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
            bg.center = CGPointMake(lroundf(frame.size.width/2), frame.size.height/2);
            [self addSubview:bg];
            self.selectionView = bg;
        }
        
        {
            for (int i = 1; i<= digits; i++) {
                ALRoundedView * digit = [[ALRoundedView alloc] initWithFrame:CGRectMake(0, 5, 20, frame.size.height - 10)];
                digit.backgroundColor = [UIColor clearColor];
                digit.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
                digit.cornerRadius = 0;
                digit.borderWidth = 3;
                digit.fillColor = [UIColor clearColor];
                [digit.textLabel setText:[NSString stringWithFormat:@"%i", i]];
                [digit.textLabel setTextAlignment:NSTextAlignmentCenter];
                [digit.textLabel setFont:[UIFont systemFontOfSize:19]];
                [self.selectionView addSubview:digit];
            }
            
            
            [ALSpaceViews spaceViewsVertically:self.selectionView.subviews spacing:3];
        }
        
        {
            ALRoundedView * digit = [self.selectionView.subviews lastObject];
            CGFloat newWidth = digits*(digit.frame.size.width+kBlackWhiteSelectDigitSpacing) + kBlackWhiteSelectDigitSpacing;
            [self.selectionView setFrame:CGRectMake(self.selectionView.frame.origin.x,
                                                    self.selectionView.frame.origin.y,
                                                    newWidth,
                                                    self.selectionView.frame.size.height)];
        }
        
        CGFloat buttonWidth = frame.size.height-10;
        CGFloat borderOffset = self.selectionView.frame.origin.x;
        
        { // Left button
            ALRoundedView * bt = [[ALRoundedView alloc] initWithFrame:CGRectMake(borderOffset/2 - buttonWidth/2, 5, buttonWidth, buttonWidth)];
            bt.cornerRadius = 100;
            bt.borderColor = [UIColor clearColor];
            bt.borderWidth = 3;
            bt.fillColor = RGBA(0,0,0,0.7);
            [bt.textLabel setTextColor:[UIColor whiteColor]];
            [bt.textLabel setText:@"txt"];
            [bt addImage:[UIImage imageNamed:@"meter_black"]];
            [bt.textLabel setFont:[UIFont systemFontOfSize:12]];
            [self addSubview:bt];
            
            self.leftButton = bt;
            [bt addTarget:self selector:@selector(leftButtonPressed:)];
        }
        
        
        { // Right button
            ALRoundedView * bt = [[ALRoundedView alloc] initWithFrame:CGRectMake(frame.size.width-borderOffset/2-buttonWidth/2, 5, buttonWidth, buttonWidth)];
            bt.cornerRadius = 100;
            bt.borderColor = [UIColor clearColor];
            bt.borderWidth = 3;
            bt.fillColor = RGBA(255,255,255,0.7);
            [bt.textLabel setText:@"txt"];
            [bt addImage:[UIImage imageNamed:@"meter_white"]];
            [bt.textLabel setTextColor:[UIColor blackColor]];
            [bt.textLabel setFont:[UIFont systemFontOfSize:12]];
            [self addSubview:bt];
            
            self.rightButton = bt;
            [bt addTarget:self selector:@selector(rightButtonPressed:)];
        }
        if (activeSelection == ALBWReadingTypeBlackText) {
            [self rightButtonPressed:nil];
        } else {
            [self leftButtonPressed:nil];
        }
        
    }
    return self;
}


- (IBAction)leftButtonPressed:(id)sender {
    self.rightButton.borderColor = [UIColor clearColor];
    self.leftButton.borderColor  = [UIColor clearColor];
    self.leftButton.borderColor  = [UIColor AL_examplesBlue];
    self.activeSelection = ALBWReadingTypeWhiteText;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(blackWhiteSelectView:didChangeMode:)]) {
        [self.delegate blackWhiteSelectView:self didChangeMode:ALBWReadingTypeWhiteText];
    }
    
    [self updateDigits];
}

- (IBAction)rightButtonPressed:(id)sender {
    self.rightButton.borderColor = [UIColor clearColor];
    self.leftButton.borderColor  = [UIColor clearColor];
    self.rightButton.borderColor = [UIColor AL_examplesBlue];
    self.activeSelection = ALBWReadingTypeBlackText;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(blackWhiteSelectView:didChangeMode:)]) {
        [self.delegate blackWhiteSelectView:self didChangeMode:ALBWReadingTypeBlackText];
    }
    
    [self updateDigits];
}

- (void)updateDigits {
    
    RGBA(255,255,255,0.7);

    UIColor * mainColor;
    UIColor * bgColor;

    if( self.activeSelection == ALBWReadingTypeWhiteText) {
       mainColor = RGBA(255,255,255,0.7);
       bgColor   = RGBA(0,0,0,0.7);
    } else {
        mainColor = RGBA(0,0,0,0.7);
        bgColor   = RGBA(255,255,255,0.7);
    }
    
    
    NSArray * digits = self.selectionView.subviews;

    for (ALRoundedView * v in digits) {
        v.textColor = mainColor;
        v.borderColor = mainColor;
        v.textLabel.textColor = mainColor;
        self.selectionView.backgroundColor = bgColor;
    }
    
    

}

@end
