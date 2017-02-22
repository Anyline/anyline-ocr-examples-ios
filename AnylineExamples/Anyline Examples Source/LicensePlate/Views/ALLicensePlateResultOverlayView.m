//
//  ALLicensePlateResultOverlayView.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 14/02/2017.
//  Copyright © 2017 9yards GmbH. All rights reserved.
//

#import "ALLicensePlateResultOverlayView.h"

@interface ALLicensePlateResultOverlayView ()

@property (nonatomic, strong) UILabel *countryCodeLabel;

@end

@implementation ALLicensePlateResultOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.countryCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 25, 20)];
        self.countryCodeLabel.center = CGPointMake(self.imageView.center.x - 136, self.imageView.center.y + 15);
        self.countryCodeLabel.font          = [UIFont boldSystemFontOfSize:14];
        self.countryCodeLabel.textColor     = [UIColor whiteColor];
        self.countryCodeLabel.backgroundColor = [UIColor clearColor];
        self.countryCodeLabel.numberOfLines = 1;
        self.countryCodeLabel.textAlignment = NSTextAlignmentCenter;
        self.countryCodeLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.countryCodeLabel];
    }
    return self;
}

- (void)setCountryCode:(NSString *)countryCode {
    self.countryCodeLabel.text = countryCode;
}

@end
