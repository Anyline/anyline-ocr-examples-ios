//
//  ALIntroHelpView.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 18/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALIntroHelpView.h"
#import "UIFont+ALExamplesAdditions.h"
#import "UIColor+ALExamplesAdditions.h"

@interface ALIntroHelpView ()

@property (nonatomic, strong) UILabel *cutoutInfoLabel;
@property (nonatomic, strong) UILabel *feedbackLabel;

@property (nonatomic, strong) UIImageView *holdStillImageView;
@property (nonatomic, strong) UIImageView *tooBrightImageView;
@property (nonatomic, strong) UIImageView *tooDarkImageView;

@property (nonatomic, strong) UILabel *holdStillLabel;
@property (nonatomic, strong) UILabel *tooBrightLabel;
@property (nonatomic, strong) UILabel *tooDarkLabel;

@property (nonatomic, strong) UILabel *introDescriptionLabel;

@property (nonatomic, strong) UIButton *goButton;

@property (nonatomic, strong) CAShapeLayer *strokeLayer;

@end

@implementation ALIntroHelpView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    self.introType = ALInfoHelpViewTypeAll;
    self.sampleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.sampleImageView];
    
    self.cutoutInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.cutoutInfoLabel.text = @"Place your item like this";
    self.cutoutInfoLabel.textAlignment = NSTextAlignmentCenter;
    self.cutoutInfoLabel.font = [UIFont AL_proximaRegularWithSize:17];
    self.cutoutInfoLabel.textColor = [UIColor AL_examplesBlue];
    [self addSubview:self.cutoutInfoLabel];
    
    self.feedbackLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.feedbackLabel.text = @"This feedback helps you during scanning";
    self.feedbackLabel.textAlignment = NSTextAlignmentCenter;
    self.feedbackLabel.numberOfLines = 0;
    self.feedbackLabel.font = [UIFont AL_proximaRegularWithSize:14];
    self.feedbackLabel.textColor = [UIColor AL_examplesBlue];
    [self addSubview:self.feedbackLabel];
    
    self.holdStillImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hold_still"]];
    [self addSubview:self.holdStillImageView];
    
    self.tooBrightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"too_bright"]];
    [self addSubview:self.tooBrightImageView];
    
    self.tooDarkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"too_dark"]];
    [self addSubview:self.tooDarkImageView];
    
    self.holdStillLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    self.holdStillLabel.text = @"Hold still";
    self.holdStillLabel.textAlignment = NSTextAlignmentCenter;
    self.holdStillLabel.font = [UIFont AL_proximaRegularWithSize:14];
    self.holdStillLabel.textColor = [UIColor AL_examplesBlue];
    [self addSubview:self.holdStillLabel];
    
    self.tooBrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    self.tooBrightLabel.text = @"Too Bright";
    self.tooBrightLabel.textAlignment = NSTextAlignmentCenter;
    self.tooBrightLabel.font = [UIFont AL_proximaRegularWithSize:14];
    self.tooBrightLabel.textColor = [UIColor AL_examplesBlue];
    [self addSubview:self.tooBrightLabel];
    
    self.tooDarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    self.tooDarkLabel.text = @"Too Dark";
    self.tooDarkLabel.textAlignment = NSTextAlignmentCenter;
    self.tooDarkLabel.font = [UIFont AL_proximaRegularWithSize:14];
    self.tooDarkLabel.textColor = [UIColor AL_examplesBlue];
    [self addSubview:self.tooDarkLabel];
    
    self.goButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.goButton.frame = CGRectMake(0, 0, 120, 36);
    [self.goButton addTarget:self action:@selector(goPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.goButton setTitle:@"LET'S GO" forState:UIControlStateNormal];
    self.goButton.titleLabel.font = [UIFont AL_proximaBoldWithSize:14];
    self.goButton.titleLabel.textColor = [UIColor AL_examplesBlue];
    self.goButton.layer.cornerRadius = 18;
    self.goButton.layer.borderColor = [[UIColor AL_examplesBlue] CGColor];
    self.goButton.layer.borderWidth = 1.0;
    [self addSubview:self.goButton];
    
    self.introDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:self.introDescriptionLabel];
    
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.95;
}

- (void)setCutoutPath:(UIBezierPath *)cutoutPath {
    _cutoutPath = [cutoutPath copy];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [self.strokeLayer removeFromSuperlayer];
    self.strokeLayer = [CAShapeLayer layer];
    {
        self.strokeLayer.path = self.cutoutPath.CGPath;
        self.strokeLayer.lineWidth = 1;
        self.strokeLayer.strokeColor = [[UIColor AL_examplesBlue] CGColor];
        
        
        self.strokeLayer.fillColor = [[UIColor clearColor] CGColor];
        self.strokeLayer.cornerRadius = 3;
    }
    self.strokeLayer.position = CGPointMake(self.strokeLayer.position.x, self.strokeLayer.position.y);
    
    [self.layer addSublayer:self.strokeLayer];
    
    
    //resize sampleImageView
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:CGPathCreateMutableCopy(self.cutoutPath.CGPath)];
    [path applyTransform:CGAffineTransformMakeScale(0.95, 0.95)];
    self.sampleImageView.frame = path.bounds;
    CGRect boundingRect = CGPathGetBoundingBox(self.cutoutPath.CGPath);
    self.sampleImageView.center = CGPointMake(boundingRect.origin.x + boundingRect.size.width/2,
                                             boundingRect.origin.y + boundingRect.size.height/2);
    self.sampleImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    self.cutoutInfoLabel.frame = CGRectMake(0, self.cutoutPath.bounds.origin.y - 40, self.bounds.size.width, 30);
    self.feedbackLabel.frame = CGRectMake(20, self.cutoutPath.bounds.origin.y + self.cutoutPath.bounds.size.height + 10, self.bounds.size.width - 40, 20);
    
    
    CGFloat possibleHeight = self.bounds.size.height - 80 - (self.feedbackLabel.frame.origin.y + self.feedbackLabel.frame.size.height);
    
    CGSize infoImagesSize = CGSizeMake(MIN(self.holdStillImageView.frame.size.width, possibleHeight), MIN(self.holdStillImageView.frame.size.width, possibleHeight));
    
    self.holdStillImageView.frame = CGRectMake(self.holdStillImageView.frame.origin.x,
                                               self.holdStillImageView.frame.origin.y,
                                               infoImagesSize.width,
                                               infoImagesSize.height);
    self.holdStillImageView.center = CGPointMake(self.bounds.size.width/4*2, self.feedbackLabel.frame.origin.y + self.feedbackLabel.frame.size.height + 30);
    
    
    self.tooBrightImageView.frame = CGRectMake(self.tooBrightImageView.frame.origin.x,
                                               self.tooBrightImageView.frame.origin.y,
                                               infoImagesSize.width,
                                               infoImagesSize.height);
    self.tooBrightImageView.center = CGPointMake(self.bounds.size.width/4, self.feedbackLabel.frame.origin.y + self.feedbackLabel.frame.size.height + 30);
    

    
    self.tooDarkImageView.frame = CGRectMake(self.tooDarkImageView.frame.origin.x,
                                             self.tooDarkImageView.frame.origin.y,
                                             infoImagesSize.width,
                                             infoImagesSize.height);
    self.tooDarkImageView.center = CGPointMake(self.bounds.size.width/4*3, self.feedbackLabel.frame.origin.y + self.feedbackLabel.frame.size.height + 30);
    
    self.holdStillLabel.center = CGPointMake(self.holdStillImageView.center.x, self.holdStillImageView.frame.origin.y + self.holdStillImageView.frame.size.height + 10);
    self.tooBrightLabel.center = CGPointMake(self.tooBrightImageView.center.x, self.holdStillLabel.center.y);
    self.tooDarkLabel.center = CGPointMake(self.tooDarkImageView.center.x, self.holdStillLabel.center.y);
    
    self.goButton.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height - 30);
    
    
    self.tooBrightLabel.alpha = self.introType == ALInfoHelpViewTypeAll ? 1 : 0;
    self.tooBrightImageView.alpha = self.introType == ALInfoHelpViewTypeAll ? 1 : 0;
    
    self.tooDarkLabel.alpha = self.introType == ALInfoHelpViewTypeAll ? 1 : 0;
    self.tooDarkImageView.alpha = self.introType == ALInfoHelpViewTypeAll ? 1 : 0;
    
    self.holdStillLabel.alpha = self.introType == ALInfoHelpViewTypeAll ? 1 : 0;
    self.holdStillImageView.alpha = self.introType == ALInfoHelpViewTypeAll ? 1 : 0;
    
    self.feedbackLabel.alpha = self.introType == ALInfoHelpViewTypeAll ? 1 : 0;
    
    if ([self.introDescriptionText length] > 0) {
        
        self.introDescriptionLabel.frame = CGRectMake(0, 0, self.frame.size.width - 70, 120);
        self.introDescriptionLabel.hidden = false;
        
        CGFloat centerPosY = (self.introType == ALInfoHelpViewTypeNone)
            ? (boundingRect.origin.y + boundingRect.size.height + 10 + self.introDescriptionLabel.frame.size.height/2)
            : (self.tooDarkLabel.frame.origin.y + self.tooDarkLabel.frame.size.height + 10 + self.introDescriptionLabel.frame.size.height/2);
        
        self.introDescriptionLabel.center = CGPointMake(self.center.x, centerPosY);
        self.introDescriptionLabel.text = self.introDescriptionText;
        self.introDescriptionLabel.textAlignment = NSTextAlignmentCenter;
        self.introDescriptionLabel.numberOfLines = 0;
        self.introDescriptionLabel.font = [UIFont AL_proximaRegularWithSize:13];
        self.introDescriptionLabel.textColor = [UIColor AL_examplesBlue];
    } else {
        self.introDescriptionLabel.hidden = true;
    }
    
}

#pragma mark - Button Action

- (IBAction)goPressed:(id)sender {
    if (self.delegate) {
        [self.delegate goButtonPressedOnIntroHelpView:self];
    }
}

@end
