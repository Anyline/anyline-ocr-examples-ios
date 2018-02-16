//
//  CustomerDataViewController.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 27/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"
#import "ALEnergyBaseViewController.h"

@interface CustomerDataViewController : ALEnergyBaseViewController

- (instancetype)initWithCustomer:(Customer*)customer;

@end
