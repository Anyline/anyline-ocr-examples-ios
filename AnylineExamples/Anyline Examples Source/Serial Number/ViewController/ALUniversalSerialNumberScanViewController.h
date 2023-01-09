//
//  ALUniversalSerialNumberScanViewController.h
//  AnylineExamples
//
//  Created by Philipp Müller on 01/12/15.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Anyline/Anyline.h>
#import "ALBaseScanViewController.h"

@interface ALUniversalSerialNumberScanViewController : ALBaseScanViewController

// The Anyline plugin used for OCR
@property (nonatomic, strong, nullable) ALScanViewPlugin *scanViewPlugin;
// @property (nullable, nonatomic, strong) ALScanView *scanView;

@end
