//
//  ALEnergyBaseViewController.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 25/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "ALEnergyBaseViewController.h"

@interface ALEnergyBaseViewController ()

@end

@implementation ALEnergyBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIImage *backIcon = [[UIImage imageNamed:@"back arrow iOS"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:backIcon style:UIBarButtonItemStylePlain target:self action:@selector(back)]];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
