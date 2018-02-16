//
//  CustomerDataViewController.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 27/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "CustomerDataViewController.h"
#import "CustomerDataView.h"
#import "ALUtils.h"


@interface CustomerDataViewController ()

@property (strong, nonatomic) Customer *customer;
@property (strong, nonatomic) CustomerDataView *customerView;

@property (strong, nonatomic) IBOutlet UIView *customerDataContainer;

@end

@implementation CustomerDataViewController

- (instancetype)initWithCustomer:(Customer *)customer {
    if (self = [super init]) {
        self.customer = customer;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Customer", @"title");
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    self.customerDataContainer.backgroundColor = [UIColor clearColor];
    
    self.customerView = TranslateAutoresizing(v(@"CustomerDataView"));
    self.customerView.facets = CustomerDataFacetCustomerID | CustomerDataFacetAddress | CustomerDataFacetReadingValueBig | CustomerDataFacetReadingDate | CustomerDataFacetNotes | CustomerDataFacetReadingImage;
    self.customerView.customer = self.customer;
    [self.customerDataContainer addSubview:self.customerView];
    [self.customerDataContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customerView]|" options:0 metrics:nil views:@{@"customerView": self.customerView}]];// full width
    [self.customerDataContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customerView]|" options:0 metrics:nil views:@{@"customerView": self.customerView}]];// full height
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.customerView.customer = self.customer;
}

@end
