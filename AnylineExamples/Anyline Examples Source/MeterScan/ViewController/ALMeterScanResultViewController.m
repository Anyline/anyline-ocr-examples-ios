//
//  ALScanResultViewController.m
//  eScan
//
//  Created by Daniel Albertini on 01/02/15.
//  Copyright (c) 2015 Daniel Albertini. All rights reserved.
//

#import "ALMeterScanResultViewController.h"
NSString * const fontName = @"Avenir Next";
@interface ALMeterScanResultViewController ()

@property (nonatomic, strong) IBOutlet UILabel *meterReadingLabel;
@property (nonatomic, strong) IBOutlet UILabel *unitLabel;
@property (nonatomic, strong) IBOutlet UILabel *resultHeaderLabel;

@property (nonatomic, strong) IBOutlet UIImageView *meterImageView;

@property (nonatomic, strong) IBOutlet UILabel *barcodeLabel;
@property (nonatomic, strong) IBOutlet UILabel *barcodeResultLabel;

@end

@implementation ALMeterScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Result",@"Ergebnis");
    UIColor *backgroundFontColor = [UIColor blackColor];
    
    self.view.backgroundColor = backgroundFontColor;

    self.resultHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, 170, 272, 50)];
    self.resultHeaderLabel.font = [UIFont fontWithName:fontName size:34];
    self.resultHeaderLabel.adjustsFontSizeToFitWidth = YES;
    self.resultHeaderLabel.textColor = [UIColor whiteColor];
    self.resultHeaderLabel.textAlignment = NSTextAlignmentCenter;
    self.resultHeaderLabel.text = (self.resultTitle) ? self.resultTitle : @"Meter Reading";
    [self.view addSubview:self.resultHeaderLabel];
    
    self.meterImageView = [[UIImageView alloc] initWithImage:self.meterImage];
    self.meterImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.meterImageView.frame = CGRectMake((self.view.frame.size.width - 272)/2, 300, 272, 70);
    [self.view addSubview:self.meterImageView];
    
    self.meterReadingLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, 230, 272, 50)];
    self.meterReadingLabel.font = [UIFont fontWithName:fontName size:34];
    self.meterReadingLabel.adjustsFontSizeToFitWidth = YES;
    self.meterReadingLabel.textColor = backgroundFontColor;
    self.meterReadingLabel.backgroundColor = [UIColor whiteColor];
    self.meterReadingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.meterReadingLabel];
    
    self.meterReadingLabel.text = self.result;
    
    self.unitLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, 170, 272, 50)];
    self.unitLabel.font = [UIFont fontWithName:fontName size:34];
    self.unitLabel.adjustsFontSizeToFitWidth = YES;
    self.unitLabel.textColor = [UIColor whiteColor];
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:self.unitLabel];
    
    NSString *unit = @"";
    
    switch (self.scanMode) {
        case ALDigitalMeter:
        case ALAutoAnalogDigitalMeter:
            unit = @"kWh";
            break;
        case ALHeatMeter4:
        case ALHeatMeter5:
        case ALHeatMeter6:
        case ALAnalogMeter:
            unit = @"m\u00B3";
            break;
        default:
            unit = @"";
            break;
    }
    self.unitLabel.text = unit;
    
    if (![self.barcodeResult isEqualToString:@""] && self.barcodeResult.length > 0) {
        self.barcodeLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, 400, 272, 30)];
        self.barcodeLabel.font = [UIFont fontWithName:fontName size:22];
        self.barcodeLabel.adjustsFontSizeToFitWidth = YES;
        self.barcodeLabel.textColor = [UIColor whiteColor];
        self.barcodeLabel.textAlignment = NSTextAlignmentCenter;
        self.barcodeLabel.text = @"Barcode Result";
        [self.view addSubview:self.barcodeLabel];

        self.barcodeResultLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, 430, 272, 30)];
        self.barcodeResultLabel.font = [UIFont fontWithName:fontName size:18];
        self.barcodeResultLabel.adjustsFontSizeToFitWidth = YES;
        self.barcodeResultLabel.textColor = backgroundFontColor;
        self.barcodeResultLabel.textAlignment = NSTextAlignmentCenter;
        self.barcodeResultLabel.textColor = [UIColor whiteColor];
        self.barcodeResultLabel.text = self.barcodeResult;
        [self.view addSubview:self.barcodeResultLabel];
    }
}

#pragma mark - private methods

//- (void)initViews {
//
//    self.meterReadingView = [[ALMeterReadingView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 150)];
//    [self.view addSubview:self.meterReadingView];
//    
//}
//
//- (void)setupMeterReadingView {
//    
//    [self.meterReadingView setText:self.result];
//    
//    switch (self.scanMode) {
//        case ALElectricMeter:
//            self.meterReadingView.state = ALMeterReadingViewStatePower;
//            break;
//        case ALGasMeter:
//        default:
//            self.meterReadingView.state = ALMeterReadingViewStateGas;
//            break;
//    }
//}

@end
