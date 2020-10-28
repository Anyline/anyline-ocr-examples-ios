//
//  CustomerSelfReadingViewController.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 25/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "CustomerSelfReadingViewController.h"
#import "ReadingTableViewCell.h"
#import "CustomerSelfReading.h"
#import "CustomerSelfReadingResultViewController.h"
#import "ReadingDetailsViewController.h"
#import "ALUtils.h"
#import "NSManagedObjectContext+ALExamplesAdditions.h"
#import "NSManagedObject+ALExamplesAdditions.h"

#import "ALEnergyMeterScanViewController.h"


@interface CustomerSelfReadingViewController ()

@property (strong, nonatomic) NSArray *readings;
@property (strong, nonatomic) CustomerSelfReading *csr;

@property (strong, nonatomic) IBOutlet UITableView *readingTableView;

@end

@implementation CustomerSelfReadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.title = @"Self Reading";
    
    [self.readingTableView registerNib:[UINib nibWithNibName:@"ReadingTableViewCell" bundle:nil] forCellReuseIdentifier:[ReadingTableViewCell reuseIdentifier]];
    
    self.csr = [[CustomerSelfReading findAllInContext:self.managedObjectContext] firstObject];
    self.readings = [self.csr customerCreatedReadings];
    
    [self.readingTableView setContentInset:UIEdgeInsetsMake(0, 0, 55, 0)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.readings = [self.csr customerCreatedReadings];
    [self.readingTableView reloadData];
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - Table View Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.readings.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadingTableViewCell *cell = (ReadingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[ReadingTableViewCell reuseIdentifier]];

    cell.reading = self.readings[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:[[ReadingDetailsViewController alloc] initWithReading:self.readings[indexPath.row]] animated:YES];
}

#pragma mark - Actions

- (IBAction)scanAction:(id)sender {
    ALEnergyMeterScanViewController *meterScanner = [[ALEnergyMeterScanViewController alloc] init];
    meterScanner.managedObjectContext = self.managedObjectContext;
    meterScanner.csr = self.csr;
    [self.navigationController pushViewController:meterScanner animated:YES];
}

@end
