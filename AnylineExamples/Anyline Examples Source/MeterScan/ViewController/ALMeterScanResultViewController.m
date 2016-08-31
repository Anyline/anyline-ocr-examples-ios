//
//  ALScanResultViewController.m
//  eScan
//
//  Created by Daniel Albertini on 01/02/15.
//  Copyright (c) 2015 Daniel Albertini. All rights reserved.
//

#import "ALMeterScanResultViewController.h"

@interface ALMeterScanResultViewController ()

@property (nonatomic, strong) IBOutlet UILabel *meterReadingLabel;
@property (nonatomic, strong) IBOutlet UILabel *unitLabel;

@property (nonatomic, strong) IBOutlet UIImageView *meterImageView;

@end

@implementation ALMeterScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Result";
    UIColor *backgroundFontColor = [UIColor colorWithRed:85.0 / 255
                                              green:144.0 / 255
                                               blue:163.0 / 255
                                              alpha:1];
    
    self.view.backgroundColor = backgroundFontColor;

    self.meterImageView = [[UIImageView alloc] initWithImage:self.meterImage];
    self.meterImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.meterImageView.frame = CGRectMake((self.view.frame.size.width - 272)/2, 300, 272, 70);
    [self.view addSubview:self.meterImageView];
    
    self.meterReadingLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, 230, 272, 50)];
    self.meterReadingLabel.font = [UIFont fontWithName:@"Apple Color Emoji" size:34];
    self.meterReadingLabel.adjustsFontSizeToFitWidth = YES;
    self.meterReadingLabel.textColor = backgroundFontColor;
    self.meterReadingLabel.backgroundColor = [UIColor whiteColor];
    self.meterReadingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.meterReadingLabel];
    
    self.meterReadingLabel.text = self.result;
    
    self.unitLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, 170, 272, 50)];
    self.unitLabel.font = [UIFont fontWithName:@"Apple Color Emoji" size:34];
    self.unitLabel.adjustsFontSizeToFitWidth = YES;
    self.unitLabel.textColor = [UIColor whiteColor];
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.unitLabel];
    
    NSString *unit = @"";
    
    switch (self.scanMode) {
        case ALElectricMeter:
        case ALElectricMeter5_1:
        case ALElectricMeter6_1:
        case ALDigitalMeter:
            unit = @"kWh";
            break;
        case ALGasMeter:
        case ALGasMeter6:
        case ALHeatMeter4:
        case ALHeatMeter5:
        case ALHeatMeter6:
        case ALWaterMeterBlackBackground:
        case ALWaterMeterWhiteBackground:
            unit = @"m\u00B3";
            break;
        default:
            break;
    }
    
    self.unitLabel.text = unit;
}

@end
