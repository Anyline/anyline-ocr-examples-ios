//
//  ALEnergyBaseViewController.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 25/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALEnergyBaseViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)back;

@end

