//
//  ALIntroHelpView.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 18/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALIntroHelpViewElectric.h"
#import "UIFont+ALExamplesAdditions.h"
#import "UIColor+ALExamplesAdditions.h"
#import "ALBlackWhiteSelectView.h"
#import "ALMeterSelectView.h"

NSString * const digitalIntro = @"That is basically all you need to know - now give it a try!";
NSString * const analogIntro = @"Scan all sorts of analog energy meters with this mode. It doesn’t matter how many digits or if there is a black or white background.";
NSString * const digitAndBWIntro = @"Choose black or white background with the help of this widget. In this mode meters with 5 or 6 pre-decimal digits will be scanned.";
NSString * const digitWidgetIntro = @"Choose the correct number of pre-decimal digits you want to scan by clicking on the minus or plus symbol.";
NSString * const autoAnalogDigitalIntro = @"Scan analog or digital meters with this mode. It doesn't matter how many digits, or if the analog meter has a black or white background.";
NSString * const dialIntro = @"Scan dial meters with this mode. Please only put relevant dials in the cutout in order to get the correct result.";
NSString * const serialNumberIntro = @"Scan serial numbers with this mode. Please only put relevant numbers in the cutout in order to get the correct result.";

NSString * const detectBarcodeIntro = @"Hint: The \"Barcode Detection\" allows to simultaneously scan the meter identifier.";


@interface ALIntroHelpViewElectric ()

@property (nonatomic, strong) UILabel *cutoutLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *feedbackLabel;

@property (nonatomic, strong) UIImageView *analogExampleGas;
@property (nonatomic, strong) UIImageView *analogExampleWater;

@property (nonatomic, strong) UIImageView *holdStillImageView;
@property (nonatomic, strong) UIImageView *tooBrightImageView;
@property (nonatomic, strong) UIImageView *tooDarkImageView;

@property (nonatomic, strong) UILabel *holdStillLabel;
@property (nonatomic, strong) UILabel *tooBrightLabel;
@property (nonatomic, strong) UILabel *tooDarkLabel;

@property (nonatomic, strong) UIButton *goButton;

@property (nonatomic, strong) id selectionWidget;

@property (nonatomic, strong) CAShapeLayer *strokeLayer;

@end

@implementation ALIntroHelpViewElectric

- (instancetype)initWithFrame:(CGRect)frame cutoutPath:(UIBezierPath *)cutoutPath type:(ALIntroHelpViewMode)widgetType; {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        CGFloat offset = 0;
        {
            [self.strokeLayer removeFromSuperlayer];
            self.strokeLayer = [CAShapeLayer layer];
            self.strokeLayer.path = cutoutPath.CGPath;
            
            self.strokeLayer.lineWidth = 3;
            self.strokeLayer.strokeColor = [[UIColor AL_examplesBlue] CGColor];
            self.strokeLayer.fillColor = [[UIColor clearColor] CGColor];
            self.strokeLayer.cornerRadius = 3;
        
            self.strokeLayer.position = CGPointMake(self.strokeLayer.position.x, self.strokeLayer.position.y);
            [self.layer addSublayer:self.strokeLayer];
            
            self.sampleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:CGPathCreateMutableCopy(cutoutPath.CGPath)];
            [path applyTransform:CGAffineTransformMakeScale(0.9, 0.9)];
            self.sampleImageView.frame = path.bounds;
            CGRect boundingRect = CGPathGetBoundingBox(self.strokeLayer.path);
            self.sampleImageView.center = CGPointMake(boundingRect.origin.x + boundingRect.size.width/2,
                                                      boundingRect.origin.y + boundingRect.size.height/2);
            [self addSubview:self.sampleImageView];
            
            offset += cutoutPath.bounds.origin.y + cutoutPath.bounds.size.height;
            
            //add label above cutout
            self.cutoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, boundingRect.origin.y-40, frame.size.width - 70, 30)];
            self.cutoutLabel.text = @"Place your item like this";
            self.cutoutLabel.textAlignment = NSTextAlignmentCenter;
            self.cutoutLabel.numberOfLines = 0;
            self.cutoutLabel.font = [UIFont AL_proximaBoldWithSize:18];
            self.cutoutLabel.textColor = [UIColor AL_examplesBlue];
            [self addSubview:self.cutoutLabel];
            
        }
        
        offset += 30;//35;
        
        NSString *cutoutInfoText = @"";
        if (widgetType == ALIntroHelpViewModeAnalog) {
            offset += 10;
            
            CGRect frame = self.sampleImageView.frame;
            frame.size.height = frame.size.height -5;
            
            self.analogExampleGas = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.analogExampleGas.image = [UIImage imageNamed:@"intro_gas"];
            self.analogExampleGas.frame = frame; //self.sampleImageView.frame;
            self.analogExampleGas.center = CGPointMake(self.center.x,
                                                            offset + self.analogExampleGas.frame.size.height/2);
            offset += 10 + self.analogExampleGas.frame.size.height;
            [self addSubview:self.analogExampleGas];
            
            self.analogExampleWater = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.analogExampleWater.image = [UIImage imageNamed:@"intro_water"];
            self.analogExampleWater.frame = frame;
            self.analogExampleWater.center = CGPointMake(self.center.x,
                                                            offset + self.analogExampleWater.frame.size.height/2);
            offset += self.analogExampleWater.frame.size.height;
            [self addSubview:self.analogExampleWater];
            
            cutoutInfoText = [NSString stringWithFormat: @"%@\n\n%@", analogIntro, detectBarcodeIntro];
            
        } else if (widgetType == ALIntroHelpViewModeAutoAnalogDigital) {
            offset += 10;
            
            CGRect frame = self.sampleImageView.frame;
            frame.size.height = frame.size.height -60;
            
            self.analogExampleGas = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.analogExampleGas.image = [UIImage imageNamed:@"intro_gas"];
            self.analogExampleGas.frame = frame; //self.sampleImageView.frame;
            self.analogExampleGas.center = CGPointMake(self.center.x,
                                                       offset + self.analogExampleGas.frame.size.height/2);
            offset += 10 + self.analogExampleGas.frame.size.height;
            [self addSubview:self.analogExampleGas];
            
            self.analogExampleWater = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.analogExampleWater.image = [UIImage imageNamed:@"intro_water"];
            self.analogExampleWater.frame = frame;
            self.analogExampleWater.center = CGPointMake(self.center.x,
                                                         offset + self.analogExampleWater.frame.size.height/2);
            offset += self.analogExampleWater.frame.size.height;
            [self addSubview:self.analogExampleWater];
            
            cutoutInfoText = [NSString stringWithFormat: @"%@\n\n%@", autoAnalogDigitalIntro, detectBarcodeIntro];
            
        
        } else if (widgetType == ALIntroHelpViewModeDialMeter) {
            offset -= 25;
            cutoutInfoText = [NSString stringWithFormat: @"%@\n\n%@", dialIntro, detectBarcodeIntro];
        } else if (widgetType == ALIntroHelpViewModeSerialNumber) {
            offset += 10;
            cutoutInfoText = [NSString stringWithFormat: @"%@\n\n%@", serialNumberIntro, detectBarcodeIntro];
            
        } else if (widgetType == ALIntroHelpViewModeNone) {
            cutoutInfoText = [NSString stringWithFormat: @"%@\n\n%@", digitalIntro, detectBarcodeIntro];;
        } else {
            CGRect widgetRect = CGRectMake(0, offset, frame.size.width, 50);
            switch (widgetType) {
                case ALIntroHelpViewModeBW:
                    self.selectionWidget = [[ALBlackWhiteSelectView alloc] initWithFrame:widgetRect];
                    cutoutInfoText = [NSString stringWithFormat: @"%@\n\n%@", digitAndBWIntro, detectBarcodeIntro];
                    break;
                case ALIntroHelpViewModeDigits:
                default:
                    self.selectionWidget = [[ALMeterSelectView alloc] initWithFrame:widgetRect maxDigits:7 minDigits:6 startDigits:7];
                    cutoutInfoText = [NSString stringWithFormat: @"%@\n\n%@", digitWidgetIntro, detectBarcodeIntro];
                    break;
            }
            
            [self.selectionWidget setUserInteractionEnabled:NO];
            [self addSubview:self.selectionWidget];
            
            offset += [self.selectionWidget frame].size.height + 10;
        }
        
        offset += 10;
        
        {
            self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, offset, frame.size.width - 70, 120)];
            self.infoLabel.text = cutoutInfoText;
            self.infoLabel.textAlignment = NSTextAlignmentCenter;
            self.infoLabel.numberOfLines = 0;
            self.infoLabel.font = [UIFont AL_proximaRegularWithSize:14];
            self.infoLabel.textColor = [UIColor AL_examplesBlue];
            [self addSubview:self.infoLabel];
            
            offset += self.infoLabel.frame.size.height;
        }
        
        {
            self.goButton = [UIButton buttonWithType:UIButtonTypeSystem];
            self.goButton.frame = CGRectMake(0, 0, 120, 44);
            [self.goButton addTarget:self action:@selector(goPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.goButton setTitle:@"LET'S GO" forState:UIControlStateNormal];
            self.goButton.titleLabel.font = [UIFont AL_proximaBoldWithSize:14];
            self.goButton.titleLabel.textColor = [UIColor AL_examplesBlue];
            self.goButton.layer.cornerRadius = 22;
            self.goButton.layer.borderColor = [[UIColor AL_examplesBlue] CGColor];
            self.goButton.layer.borderWidth = 1.0;
            [self addSubview:self.goButton];
            
            self.goButton.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height - 50);
        }
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.95;
        
    }
    return self;
}


#pragma mark - Button Action

- (IBAction)goPressed:(id)sender {
    if (self.delegate) {
        [self.delegate goButtonPressedOnIntroHelpView:self];
    }
}

@end
