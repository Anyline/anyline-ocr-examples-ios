//
//  CustomerSelfReadingResultViewController.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 29/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "CustomerSelfReadingResultViewController.h"
#import "CustomerDataView.h"
#import "Customer.h"
#import "ALScanResultViewController.h"
#import "CustomerSelfReadingConfirmationViewController.h"
#import "ALUtils.h"
#import "CustomerSelfReadingViewController.h"
#import "ALEnergyMeterScanViewController.h"
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"
#import "NSManagedObjectContext+ALExamplesAdditions.h"
#import "NSManagedObject+ALExamplesAdditions.h"

@interface CustomerSelfReadingResultViewController ()

@property (strong, nonatomic) Reading                       *reading;
@property (strong, nonatomic) ALMeterReading                *meterReading;

@property (strong, nonatomic) CustomerDataView              *customerDataView;
@property (strong, nonatomic) ALScanResultViewController    *scanResultVC;

@property (strong, nonatomic) IBOutlet UILabel *resultTitle;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;


@property (strong, nonatomic) IBOutlet UIView               *resultContainer;
@property (strong, nonatomic) IBOutlet UIView               *customerDataContainer;

@end

@implementation CustomerSelfReadingResultViewController

- (instancetype)initWithReading:(Reading*)reading andMeterReading:(ALMeterReading*)meterReading {
    self = [super init];
    if (self) {
        self.reading = reading;
        self.meterReading = meterReading;
    }
    return self;
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
    self.customerDataView.facets = CustomerDataFacetCustomerID | CustomerDataFacetAddress | CustomerDataFacetReadingValueBig | CustomerDataFacetReadingDate | CustomerDataFacetReadingImage;
    self.customerDataView.customer = self.reading.customer;
    [self.customerDataContainer addSubview:self.customerDataView];
    
    [self.customerDataContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customerView]|" options:0 metrics:nil views:@{@"customerView": self.customerDataView}]];// full width
    [self.customerDataContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customerView]|" options:0 metrics:nil views:@{@"customerView": self.customerDataView}]];// full height
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        if (self.delegate) {
            [self.delegate backFromResultView:self isReset:YES];
        }
        [self discardMeterReading];
    }
}

- (void)back{
    [super back];
    if (self.delegate) {
        [self.delegate backFromResultView:self isReset:NO];
    }
    [self discardMeterReading];
}

- (void)discardMeterReading {
    [self.reading deleteEntityInContext:self.reading.managedObjectContext];
    [self.reading.managedObjectContext saveToPersistentStoreAndWait];
}
#pragma mark - Actions

- (IBAction)sendAction:(id)sender {
    [self.navigationController pushViewController:[[CustomerSelfReadingConfirmationViewController alloc] initWithReading:self.reading] animated:YES];
}

- (IBAction)cancelAction:(id)sender {
    [self discardMeterReading];
    if (self.delegate) {
        [self.delegate backFromResultView:self isReset:YES];
    }
    [self popToALEnergyMeterScanView];
}

- (void)popToCustomerSelfReading{
    UINavigationController *navigationController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    for (UIViewController *vc in navigationController.viewControllers) {
        if ([vc isKindOfClass:[CustomerSelfReadingViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
- (void)popToALEnergyMeterScanView {
    for (ALEnergyMeterScanViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ALEnergyMeterScanViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

@end
