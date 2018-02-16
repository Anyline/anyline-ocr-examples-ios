//
//  CustomerSelfReadingConfirmationViewController.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 29/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "ALEnergyBaseViewController.h"
#import "Reading.h"

@interface CustomerSelfReadingConfirmationViewController : ALEnergyBaseViewController

- (instancetype)initWithReading:(Reading*)reading;

@end
