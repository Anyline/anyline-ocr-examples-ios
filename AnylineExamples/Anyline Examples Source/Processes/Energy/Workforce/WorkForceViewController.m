//
//  WorkForceViewController.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 26/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "WorkForceViewController.h"
#import "CoreDataManager.h"
#import "ReadingTableViewCell.h"
#import "WorkorderViewController.h"
#import "WorkforceTool.h"
#import "ALUtils.h"
#import "NSManagedObjectContext+ALExamplesAdditions.h"
#import "NSManagedObject+ALExamplesAdditions.h"

@interface WorkForceViewController ()

@property (strong, nonatomic) IBOutlet UIImageView          *anylineLogoView;
@property (strong, nonatomic) IBOutlet UILabel              *workOrdersLabel;
@property (strong, nonatomic) IBOutlet UITableView          *workOrdersTableView;
@property (strong, nonatomic) IBOutlet UILabel              *reportsSyncStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton               *syncButton;
@property (weak, nonatomic) IBOutlet UIImageView            *syncStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel                *syncingLabel;
@property (weak, nonatomic) IBOutlet UIProgressView         *syncingProgressView;

@property (nonatomic, strong) NSArray                       *orders;
@property (assign, nonatomic) BOOL                          isSyncing;
@property (assign, nonatomic, readonly) NSArray<Customer *> *unsyncedCustomers;

@end

@implementation WorkForceViewController

#pragma mark - CA

- (NSArray<Customer *> *)unsyncedCustomers {
    return (self.orders) ? [Customer findAllWithPredicate:[NSPredicate predicateWithFormat:@"order IN %@ AND isCompleted = YES AND isSynced = NO", self.orders] inContext:self.managedObjectContext] : nil;
}

- (void)setIsSyncing:(BOOL)isSyncing {
    _isSyncing = isSyncing;
    if (isSyncing) {
        self.syncButton.enabled = NO;
        self.syncingProgressView.hidden = NO;
    } else {
        self.syncButton.enabled = YES;
        self.syncingProgressView.hidden = YES;
    }
    
    [self _updateSyncingLabelAndSymbol];
}

#pragma mark - Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WorkforceTool *workForce = [[WorkforceTool findAllInContext:self.managedObjectContext] firstObject];
    self.orders = [[workForce.orders allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(orderNr)) ascending:YES]]];
    
    [self.workOrdersTableView registerNib:[UINib nibWithNibName:@"ReadingTableViewCell" bundle:nil] forCellReuseIdentifier:[ReadingTableViewCell reuseIdentifier]];
    
    self.isSyncing = false;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.workOrdersTableView reloadData];
    
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.title = @"Workforce";

    [self _updateSyncingLabelAndSymbol];
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadingTableViewCell *cell = (ReadingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[ReadingTableViewCell reuseIdentifier]];
    
    cell.order = self.orders[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WorkorderViewController *vc = [[WorkorderViewController alloc] initWithOrder:self.orders[indexPath.row]];
    vc.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (IBAction)syncAction:(id)sender {
    [self _startSync];
}

#pragma mark - Private

- (void)_startSync {
    self.isSyncing = YES;
    self.syncingProgressView.progress = 0;
    
    // get all our unsynced orders together
    __block NSInteger processed = 0;
    NSArray<Customer *> *unsyncedCustomers = [self.unsyncedCustomers copy];
    
    // go through them and attempt to sync each one of them
    for (Customer *customer in unsyncedCustomers) {
        // get the last reading
        Reading *lastReading = customer.lastReading;
        
        // sync it
        [ALUtils syncReading:lastReading withBlock:^(BOOL success) {
            if (success) {
                // mark the report as synced in core data
                customer.isSynced = @YES;
                [customer.managedObjectContext saveWithCompletion:^(BOOL contextDidSave, NSError *error) {
                    if (!contextDidSave) {
                        NSLog(@"Error while saving context");
                    }
                } isSynchronously:NO];
            }
            
            // update our UI to indicate that we're done with this guy
            processed += 1;
            [self _updateSyncingLabelAndSymbol];
            self.syncingProgressView.progress = (CGFloat)processed/(CGFloat)unsyncedCustomers.count;
            
            // if we've processed all it means we're done
            if (processed == unsyncedCustomers.count) {
                self.isSyncing = false;
            }
        }];
    }
}

- (void)_updateSyncingLabelAndSymbol {
    if (self.unsyncedCustomers.count == 0) {
        self.syncButton.hidden = YES;
        self.syncStatusImageView.image = [UIImage imageNamed:@"blue round checkmark"];
        self.syncingLabel.text = NSLocalizedString(@"All orders synced", @"orders synced string");
    } else {
        self.syncButton.hidden = NO;
        self.syncStatusImageView.image = [UIImage imageNamed:@"warning icon"];
        self.syncingLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d unsynced readings", @"orders synced string"), self.unsyncedCustomers.count];
    }
}

@end
