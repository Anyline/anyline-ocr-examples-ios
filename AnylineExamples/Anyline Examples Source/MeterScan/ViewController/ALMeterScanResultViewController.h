//
//  ALScanResultViewController.h
//  eScan
//
//  Created by Daniel Albertini on 01/02/15.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Anyline/Anyline.h>

@interface ALMeterScanResultViewController : UIViewController

@property (nonatomic) ALScanMode scanMode;

@property (nonatomic, strong) NSString *result;

@property (nonatomic, strong) UIImage *meterImage;

@property (nonatomic, strong) NSDictionary *barcodeResults;

@end
