//
//  WorkforceToolResultViewController.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 01/11/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "WorkforceToolResultViewController.h"
#import "ALScanResultViewController.h"
#import "CustomerDataView.h"
#import "WorkForceViewController.h"
#import "CoreDataManager.h"
#import "ALEnergyMeterScanViewController.h"
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"
#import "NSManagedObjectContext+ALExamplesAdditions.h"
#import "NSManagedObject+ALExamplesAdditions.h"
#import "ALUtils.h"



@interface WorkforceToolResultViewController ()
@property (strong, nonatomic) IBOutlet UIView *resultContainer;
@property (strong, nonatomic) IBOutlet UILabel *resultTitle;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutlet UIView *customerDataContainer;
@property (strong, nonatomic) ALScanResultViewController *scanResultVC;

@property (strong, nonatomic) Reading *reading;
@property (strong, nonatomic) ALMeterReading *meterReading;
@property (strong, nonatomic) CustomerDataView *customerDataView;

@end

@implementation WorkforceToolResultViewController

- (instancetype)initWithReading:(Reading*)reading andMeterReading:(ALMeterReading*)meterReading{
    self = [super init];
    if (self) {
        self.reading = reading;
        self.meterReading = meterReading;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Scan Result", @"title");
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    self.resultTitle.textColor = [UIColor blackColor];
    self.resultTitle.adjustsFontSizeToFitWidth = YES;
    
    self.resultLabel.text = [self.reading localizedReadingValue];
    self.resultLabel.font = [UIFont AL_proximaBoldWithSize:28];
    self.resultLabel.textColor = [UIColor blackColor];
    self.resultLabel.adjustsFontSizeToFitWidth = YES;
    
    self.customerDataView = TranslateAutoresizing(v(@"CustomerDataView"));
    self.customerDataView.facets = CustomerDataFacetCustomerID | CustomerDataFacetAddress | CustomerDataFacetReadingValueBig | CustomerDataFacetReadingDate | CustomerDataFacetNotes | CustomerDataFacetReadingImage;
    self.customerDataView.customer = self.reading.customer;
    [self.customerDataContainer addSubview:self.customerDataView];
    
    [self.customerDataContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customerView]|" options:0 metrics:nil views:@{@"customerView": self.customerDataView}]];// full width
    [self.customerDataContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customerView]|" options:0 metrics:nil views:@{@"customerView": self.customerDataView}]];// full height

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        if (self.delegate) {
            [self.delegate backFromWorkforceResultView:self isReset:YES];
        }
        [self discardMeterReading];
    }
}

- (void)back{
    [super back];
    [self discardMeterReading];
}

- (void)discardMeterReading {
    [self.reading deleteEntityInContext:self.reading.managedObjectContext];
    [self.reading.managedObjectContext saveToPersistentStoreAndWait];
}


- (void)popToALEnergyMeterScanView {
    for (ALEnergyMeterScanViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ALEnergyMeterScanViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

#pragma mark - Actions

- (IBAction)cancelAction:(id)sender {
    [self discardMeterReading];
    if (self.delegate) {
        [self.delegate backFromWorkforceResultView:self isReset:YES];
    }
    [self popToALEnergyMeterScanView];
}
- (IBAction)confirmAction:(id)sender {
    self.reading.customer.isCompleted = @YES;
    self.reading.customer.isSynced = @NO;
    
    [self.reading.managedObjectContext saveWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if (!contextDidSave) {
            NSLog(@"Error while saving context");
        }
    } isSynchronously:NO];
    
    if (self.delegate) {
        [self.delegate backFromWorkforceResultView:self isReset:YES];
    }
    [self popToALEnergyMeterScanView];

}

@end
