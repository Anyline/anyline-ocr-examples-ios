//
//  CustomerSelfReadingResultViewController.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 29/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reading.h"
#import "ALMeterReading.h"
#import "ALEnergyBaseViewController.h"

@protocol CustomerSelfReadingResultDelegate;

@interface CustomerSelfReadingResultViewController : ALEnergyBaseViewController

- (instancetype)initWithReading:(Reading*)reading andMeterReading:(ALMeterReading*)meterReading;

@property (nonatomic, weak) id<CustomerSelfReadingResultDelegate> delegate;

@end

@protocol CustomerSelfReadingResultDelegate <NSObject>

@required
- (void)backFromResultView:(CustomerSelfReadingResultViewController *)customerSelfReadingResultView isReset:(BOOL)isReset;
@end
