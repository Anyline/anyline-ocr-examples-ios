//
//  ALScanResultViewController.m
//  eScan
//
//  Created by Daniel Albertini on 01/02/15.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "ALMeterScanResultViewController.h"
#import "ALAppDemoLicenses.h"

@interface ALMeterScanResultViewController ()

@property (nonatomic, strong) IBOutlet UILabel *unitLabel;
@property (nonatomic, strong) IBOutlet UILabel *meterReadingLabel;
@property (nonatomic, strong) IBOutlet UILabel *resultHeaderLabel;

@property (nonatomic, strong) IBOutlet UIImageView *meterImageView;

@property (nonatomic, strong) IBOutlet UILabel *barcodeHeaderLabel;
@property (nonatomic, strong) IBOutlet UILabel *barcodeResultsLabel;

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
    self.meterReadingLabel.font = [UIFont fontWithName:@"Avenir Next" size:34];
    self.meterReadingLabel.adjustsFontSizeToFitWidth = YES;
    self.meterReadingLabel.textColor = backgroundFontColor;
    self.meterReadingLabel.backgroundColor = [UIColor whiteColor];
    self.meterReadingLabel.textAlignment = NSTextAlignmentCenter;
    self.meterReadingLabel.text = self.result;
    [self.view addSubview:self.meterReadingLabel];
    
    self.resultHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, 170, 272, 50)];
    self.resultHeaderLabel.font = [UIFont fontWithName:@"Avenir Next" size:34];
    self.resultHeaderLabel.adjustsFontSizeToFitWidth = YES;
    self.resultHeaderLabel.textColor = [UIColor whiteColor];
    self.resultHeaderLabel.textAlignment = NSTextAlignmentCenter;
    self.resultHeaderLabel.text = @"Meter Reading";
    [self.view addSubview:self.resultHeaderLabel];
    
//    self.unitLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, 170, 272, 50)];
//    self.unitLabel.font = [UIFont fontWithName:@"Apple Color Emoji" size:34];
//    self.unitLabel.adjustsFontSizeToFitWidth = YES;
//    self.unitLabel.textColor = [UIColor whiteColor];
//    self.unitLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:self.unitLabel];
//    
//    NSString *unit = @"";
//    
//    switch (self.scanMode) {
//        case ALElectricMeter:
//        case ALElectricMeter5_1:
//        case ALElectricMeter6_1:
//        case ALDigitalMeter:
//            unit = @"kWh";
//            break;
//        case ALGasMeter:
//        case ALGasMeter6:
//        case ALHeatMeter4:
//        case ALHeatMeter5:
//        case ALHeatMeter6:
//        case ALWaterMeterBlackBackground:
//        case ALWaterMeterWhiteBackground:
//            unit = @"m\u00B3";
//            break;
//        default:
//            break;
//    }
//    
//    self.unitLabel.text = unit;
    
    
    if (self.barcodeResults.count > 0) {
        self.barcodeHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, 400, 272, 50)];
        self.barcodeHeaderLabel.font = [UIFont fontWithName:@"Avenir Next" size:22];
        self.barcodeHeaderLabel.adjustsFontSizeToFitWidth = YES;
        self.barcodeHeaderLabel.textColor = [UIColor whiteColor];
        self.barcodeHeaderLabel.textAlignment = NSTextAlignmentCenter;
        self.barcodeHeaderLabel.text = @"Barcode Result";
        [self.view addSubview:self.barcodeHeaderLabel];
        
        self.barcodeResultsLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, 450, 272, 50)];
        self.barcodeResultsLabel.font = [UIFont fontWithName:@"Avenir Next" size:16];
        self.barcodeResultsLabel.adjustsFontSizeToFitWidth = YES;
        self.barcodeResultsLabel.numberOfLines = 0;
        self.barcodeResultsLabel.textColor = backgroundFontColor;
        self.barcodeResultsLabel.backgroundColor = [UIColor whiteColor];
        self.barcodeResultsLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.barcodeResultsLabel];
    
        self.barcodeResultsLabel.text = [NSString stringWithFormat:@"%@", [[self.barcodeResults allKeys] lastObject]];
    }
}

@end
