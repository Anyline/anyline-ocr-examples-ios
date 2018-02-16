//
//  ReadingDetailsViewController.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 29/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "ReadingDetailsViewController.h"
#import "Reading.h"
#import "Customer.h"
#import "CustomerDataView.h"
#import "ALUtils.h"

@interface ReadingDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIView *customerDataContainer;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) Reading *reading;

@end

@implementation ReadingDetailsViewController

- (instancetype)initWithReading:(Reading*)reading
{
    self = [super init];
    if (self) {
        self.reading = reading;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"Reading", @"title");
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    self.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Reading #%d", @"subheading"), [self.reading.sort intValue]];
    
    CustomerDataView *customerView = TranslateAutoresizing(v(@"CustomerDataView"));
    customerView.facets = CustomerDataFacetCustomerID | CustomerDataFacetAddress | CustomerDataFacetReadingValueBig | CustomerDataFacetReadingDate | CustomerDataFacetReadingImage;
    customerView.customer = self.reading.customer;
    [self.customerDataContainer addSubview:customerView];
    
    [self.customerDataContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customerView]|" options:0 metrics:nil views:@{@"customerView": customerView}]];// full width
    [self.customerDataContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customerView]|" options:0 metrics:nil views:@{@"customerView": customerView}]];// full height
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [ALUtils styleNavbarForViewController:self withStyle:ALNavbarStyleShow];
//    [ALUtils styleStatusBar:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
