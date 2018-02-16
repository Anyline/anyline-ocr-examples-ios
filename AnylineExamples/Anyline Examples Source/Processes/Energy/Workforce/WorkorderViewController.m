//
//  WorkorderViewController.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 27/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "WorkorderViewController.h"
#import "ReadingTableViewCell.h"
#import "CustomerDataViewController.h"
#import "WorkforceToolResultViewController.h"
#import "ALMeter.h"
#import "ALMeterReading.h"
#import "ALUtils.h"
#import <Anyline/Anyline.h>

#import "ALEnergyMeterScanViewController.h"

@interface WorkorderViewController ()

@property (nonatomic, strong) Order *order;
@property (nonatomic, strong) NSArray *customers;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *customerTableView;

@end

@implementation WorkorderViewController

#pragma mark - Life

- (instancetype)initWithOrder:(Order*)order {
    self = [super init];
    if (self) {
        self.order = order;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = NSLocalizedString(@"Workorder", @"title");
    
    self.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Order #%d", @"title"), [self.order.orderNr intValue]];

    self.customers = [[self.order.customers allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(meterID)) ascending:YES]]];
    
    [self.customerTableView registerNib:[UINib nibWithNibName:@"ReadingTableViewCell" bundle:nil] forCellReuseIdentifier:[ReadingTableViewCell reuseIdentifier]];

    [self.customerTableView setContentInset:UIEdgeInsetsMake(0, 0, 55, 0)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.customerTableView reloadData];
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.title = @"Workforce";
//    [ALUtils styleNavbarForViewController:self withStyle:ALNavbarStyleShow];
//    [ALUtils styleStatusBar:UIStatusBarStyleLightContent];
}

#pragma mark - Table View Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.customers.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadingTableViewCell *cell = (ReadingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[ReadingTableViewCell reuseIdentifier]];
    
    cell.customer = self.customers[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:[[CustomerDataViewController alloc]initWithCustomer:self.customers[indexPath.row]] animated:YES];
}

#pragma mark - Actions

- (IBAction)startAction:(id)sender {
    ALEnergyMeterScanViewController *meterScanner = [[ALEnergyMeterScanViewController alloc] init];
    meterScanner.managedObjectContext = self.managedObjectContext;
    meterScanner.order = self.order;
    
    [self.navigationController pushViewController:meterScanner animated:YES];
}

#pragma mark -

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
