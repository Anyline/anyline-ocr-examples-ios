//
//  ALWarningView.m
//  AnylineExamples
//
//  Created by David on 01/06/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALWarningView.h"
#import "ALRoundedView.h"

@interface ALWarningView ()
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * infoLabel;
@property (nonatomic, strong) NSTimer * animationTimer;
@property (nonatomic, assign) ALWarningState currentWarning;
@end

@implementation ALWarningView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat labelheight = 30;
        
        {
            CGFloat roundedOffset = 22;
            //fill the whole width and centre in it, so there is room for longer text
            UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - roundedOffset)];
            self.imageView = view;
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:self.imageView];
        }
        
        {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - labelheight, frame.size.width, labelheight)];
            label.backgroundColor = [UIColor clearColor];
            label.text = @"Placeholder";
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:11];
            label.numberOfLines = 0; //allow multiple lines for the longer version of the 'ID not recognized' string
            self.infoLabel = label;
            
            [self addSubview:self.infoLabel];
        }
        
        NSAssert(self.infoLabel.superview, @"");
        NSAssert(self.imageView.superview, @"");
    }
    self.currentWarning = ALWarningStateNone;
    self.animationState = ALAnimationStateReady;
    
    return self;
}


- (void)setInfoString:(NSString*)text; {
    self.infoLabel.text = text;
    //if they need to adjust something, announce the instruction with VoiceOver
    if (![text isEqualToString:@"perfect"] && self.window) {
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text);
    }
}


- (void)setInfoImage:(UIImage*)image; {
    [self.imageView setImage:image];
}

- (void)showWarning:(ALWarningState)newState {
    @synchronized (self.disappearanceDate) {
        
        if (self.currentWarning == newState) {
            self.disappearanceDate = [NSDate dateWithTimeIntervalSinceNow:2];
            return;
        }

        if(self.animationState != ALAnimationStateReady) {
            return;
        }
        
        switch (newState) {
            case ALWarningStateHoldStill: {
                [self setInfoString:@"hold still"];
                [self setInfoImage:[UIImage imageNamed:@"icn_holdstill"]];
                break;
            }
            case ALWarningStateTooDark: {
                [self setInfoString:@"too dark"];
                [self setInfoImage:[UIImage imageNamed:@"icn_dark"]];
                break;
            }
            case ALWarningStateTooBright: {
                [self setInfoString:@"too bright"];
                [self setInfoImage:[UIImage imageNamed:@"icn_bright"]];
                break;
            }
            case ALWarningStatePerfect: {
                [self setInfoString:@"perfect"];
                [self setInfoImage:[UIImage imageNamed:@"icn_perfect"]];
                break;
            }
            case ALWarningStateIDNotSupported: {
                [self setInfoString:@"This version doesn't support all document types yet. Stay tuned for more."];
                [self setInfoImage:nil];
                break;
            }
            default:
                break;
        }
        
        self.disappearanceDate = [NSDate dateWithTimeIntervalSinceNow:2];
        
        self.animationState = ALAnimationStateVisible;
        
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformIdentity;
            self.alpha = 1;
        }];
        
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateVisibility:) userInfo:nil repeats:YES];
    }
}

- (void)hideWarning {
    @synchronized (self.disappearanceDate) {
        self.animationState = ALAnimationStateAnimating;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha = 0;
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            self.animationState = ALAnimationStateReady;
            self.currentWarning = ALWarningStateNone;
        }];
    }
}

- (void)updateVisibility:(id)sender {
    @synchronized (self.disappearanceDate) {
        if(   self.disappearanceDate
           && [self.disappearanceDate timeIntervalSinceNow] < 0
           && self.animationState == ALAnimationStateVisible) {
            [self hideWarning];
        }
    }
}


@end
