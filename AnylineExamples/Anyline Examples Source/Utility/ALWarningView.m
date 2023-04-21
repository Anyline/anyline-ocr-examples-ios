#import "ALWarningView.h"

static const NSUInteger kWarningViewDisplayDuration = 2; // in seconds
static const CGSize kWarningViewIconImageSize = (CGSize) { 48, 48 };

@interface ALWarningView ()

@property (nonatomic, assign) NSInteger animationState;

@property (nonatomic, strong) NSDate *disappearanceDate;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) NSTimer *animationTimer;

@property (nonatomic, assign) ALWarningState currentWarning;

- (void)setInfoImage:(UIImage *)image;

@end


@implementation ALWarningView
- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero]) {
        self.currentWarning = ALWarningStateNone;
        self.animationState = ALAnimationStateReady;

        // fill the whole width and centre in it, so there is room for longer text
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView = view;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11];

        // allow multiple lines for the longer version of the 'ID not recognized' string
        label.numberOfLines = 0;

        self.infoLabel = label;
        [self addSubview:self.infoLabel];
        NSAssert(self.infoLabel.superview, @"");
        NSAssert(self.imageView.superview, @"");

        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        [self.imageView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        [self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;

        // icon image size is 48 x 48
        [self.imageView.heightAnchor
         constraintEqualToConstant:kWarningViewIconImageSize.height].active = YES;

        self.infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.infoLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        [self.infoLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        [self.infoLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [self.infoLabel.heightAnchor constraintEqualToConstant:15].active = YES;
        [self.infoLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor
                                                 constant:4].active = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectNull];
    NSAssert(false, @"not implemented! use -init and use autolayout");
    return nil;
}

- (void)setInfoString:(NSString *)text; {
    self.infoLabel.text = text;
    // if they need to adjust something, announce the instruction with VoiceOver
    if (![text isEqualToString:@"perfect"] && self.window) {
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text);
    }
}

- (void)setInfoImage:(UIImage *)image; {
    [self.imageView setImage:image];
}

- (void)showWarning:(ALWarningState)newState {
    @synchronized (self.disappearanceDate) {

        if (newState == ALWarningStateNone) {
            [self setInfoString:@""];
            [self setInfoImage:nil];
            return;
        }
        
        if (self.currentWarning == newState) {
            self.disappearanceDate = [NSDate dateWithTimeIntervalSinceNow:kWarningViewDisplayDuration];
            return;
        }

        if (self.animationState != ALAnimationStateReady) {
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
        
        self.disappearanceDate = [NSDate dateWithTimeIntervalSinceNow:kWarningViewDisplayDuration];
        
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
        if (self.disappearanceDate && [self.disappearanceDate timeIntervalSinceNow] < 0 && self.animationState == ALAnimationStateVisible) {
            [self hideWarning];
        }
    }
}

@end
