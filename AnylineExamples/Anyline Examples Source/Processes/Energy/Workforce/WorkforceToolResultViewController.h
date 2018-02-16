//
//  WorkforceToolResultViewController.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 01/11/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "ALEnergyBaseViewController.h"
#import "Reading.h"
#import "ALMeterReading.h"

@protocol WorkforceToolResultDelegate;

@interface WorkforceToolResultViewController : ALEnergyBaseViewController

- (instancetype)initWithReading:(Reading*)reading andMeterReading:(ALMeterReading*)meterReading;

@property (nonatomic, weak) id<WorkforceToolResultDelegate> delegate;

@end

@protocol WorkforceToolResultDelegate <NSObject>

@required
- (void)backFromWorkforceResultView:(WorkforceToolResultViewController *)workforceToolResultViewController isReset:(BOOL)isReset;
@end
