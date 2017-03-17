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

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UILabel *unitLabel;
@property (nonatomic, strong) IBOutlet UILabel *meterReadingLabel;
@property (nonatomic, strong) IBOutlet UILabel *resultHeaderLabel;

@property (nonatomic, strong) IBOutlet UILabel *secondMeterReadingLabel;
@property (nonatomic, strong) IBOutlet UILabel *secondResultHeaderLabel;

@property (nonatomic, strong) IBOutlet UIImageView *meterImageView;
@property (nonatomic, strong) IBOutlet UIImageView *secondMeterImageView;

@property (nonatomic, strong) IBOutlet UILabel *barcodeHeaderLabel;
@property (nonatomic, strong) IBOutlet UILabel *barcodeResultsLabel;

@end

@implementation ALMeterScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    double offset = 0;
    self.title = @"Result";
    UIColor *backgroundFontColor = [UIColor colorWithRed:85.0 / 255
                                              green:144.0 / 255
                                               blue:163.0 / 255
                                              alpha:1];
    
    self.view.backgroundColor = backgroundFontColor;

    
    int startPos = 80;
    
    self.resultHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, startPos, 272, 50)];
    self.resultHeaderLabel.font = [UIFont fontWithName:@"Avenir Next" size:34];
    self.resultHeaderLabel.adjustsFontSizeToFitWidth = YES;
    self.resultHeaderLabel.textColor = [UIColor whiteColor];
    self.resultHeaderLabel.textAlignment = NSTextAlignmentCenter;
    self.resultHeaderLabel.text = @"Meter Reading";
    [self.scrollView addSubview:self.resultHeaderLabel];
    
    self.meterReadingLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, startPos+60, 272, 50)];
    self.meterReadingLabel.font = [UIFont fontWithName:@"Avenir Next" size:34];
    self.meterReadingLabel.adjustsFontSizeToFitWidth = YES;
    self.meterReadingLabel.textColor = backgroundFontColor;
    self.meterReadingLabel.backgroundColor = [UIColor whiteColor];
    self.meterReadingLabel.textAlignment = NSTextAlignmentCenter;
    self.meterReadingLabel.text = self.result;
    [self.scrollView addSubview:self.meterReadingLabel];
    
    self.meterImageView = [[UIImageView alloc] initWithImage:self.meterImage];
    self.meterImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.meterImageView.frame = CGRectMake((self.view.frame.size.width - 272)/2, startPos+130, 272, 70);
    [self.scrollView addSubview:self.meterImageView];
    
    offset += 220;
    
    if (self.secondResult.length > 0) {
        
        self.secondResultHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, startPos+offset, 272, 50)];
        self.secondResultHeaderLabel.font = [UIFont fontWithName:@"Avenir Next" size:34];
        self.secondResultHeaderLabel.adjustsFontSizeToFitWidth = YES;
        self.secondResultHeaderLabel.textColor = [UIColor whiteColor];
        self.secondResultHeaderLabel.textAlignment = NSTextAlignmentCenter;
        self.secondResultHeaderLabel.text = @"Meter Reading 2";
        [self.scrollView addSubview:self.secondResultHeaderLabel];
        
        self.secondMeterReadingLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, startPos+offset+60, 272, 50)];
        self.secondMeterReadingLabel.font = [UIFont fontWithName:@"Avenir Next" size:34];
        self.secondMeterReadingLabel.adjustsFontSizeToFitWidth = YES;
        self.secondMeterReadingLabel.textColor = backgroundFontColor;
        self.secondMeterReadingLabel.backgroundColor = [UIColor whiteColor];
        self.secondMeterReadingLabel.textAlignment = NSTextAlignmentCenter;
        self.secondMeterReadingLabel.text = self.secondResult;
        [self.scrollView addSubview:self.secondMeterReadingLabel];
        
        self.secondMeterImageView = [[UIImageView alloc] initWithImage:self.secondMeterImage];
        self.secondMeterImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.secondMeterImageView.frame = CGRectMake((self.view.frame.size.width - 272)/2, startPos+offset+130, 272, 70);
        [self.scrollView addSubview:self.secondMeterImageView];

        offset += 230;
    }
   
    
    if (self.barcodeResults.count > 0) {
        self.barcodeHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, startPos+offset, 272, 50)];
        self.barcodeHeaderLabel.font = [UIFont fontWithName:@"Avenir Next" size:22];
        self.barcodeHeaderLabel.adjustsFontSizeToFitWidth = YES;
        self.barcodeHeaderLabel.textColor = [UIColor whiteColor];
        self.barcodeHeaderLabel.textAlignment = NSTextAlignmentCenter;
        self.barcodeHeaderLabel.text = @"Barcode Result";
        [self.scrollView addSubview:self.barcodeHeaderLabel];
        
        self.barcodeResultsLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 272)/2, startPos+offset+60, 272, 50)];
        self.barcodeResultsLabel.font = [UIFont fontWithName:@"Avenir Next" size:16];
        self.barcodeResultsLabel.adjustsFontSizeToFitWidth = YES;
        self.barcodeResultsLabel.numberOfLines = 0;
        self.barcodeResultsLabel.textColor = backgroundFontColor;
        self.barcodeResultsLabel.backgroundColor = [UIColor whiteColor];
        self.barcodeResultsLabel.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:self.barcodeResultsLabel];
        
        self.barcodeResultsLabel.text = [NSString stringWithFormat:@"%@", [[self.barcodeResults allKeys] lastObject]];
        offset += 120;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, startPos + offset + 10);
}

@end
