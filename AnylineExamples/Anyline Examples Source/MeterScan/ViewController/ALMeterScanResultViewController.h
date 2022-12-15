//
//  ALScanResultViewController.h
//  eScan
//
//  Created by Daniel Albertini on 01/02/15.
//  Copyright (c) 2015 Daniel Albertini. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Anyline/Anyline.h>

@interface ALMeterScanResultViewController : UIViewController

//@property (nonatomic) ALScanMode scanMode;

@property (nonatomic, strong) NSString *result;

@property (nonatomic, strong) UIImage *meterImage;

@property (nonatomic, strong) NSString *barcodeResult;

@property (nonatomic, strong) NSString *resultTitle;

@end
