//
//  WorkorderViewController.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 27/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "ALEnergyBaseViewController.h"

@interface WorkorderViewController : ALEnergyBaseViewController

- (instancetype)initWithOrder:(Order*)order;

@end
