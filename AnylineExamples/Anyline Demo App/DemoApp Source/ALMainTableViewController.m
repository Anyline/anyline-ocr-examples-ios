//
//  MasterViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 05/02/15.
//  Copyright (c) 2015 9yards GmbH. All rights reserved.
//

#import "ALMainTableViewController.h"

#import "ALExampleManager.h"

#import "ALExample.h"

@interface ALMainTableViewController ()

@property (nonatomic, strong) ALExampleManager *exampleManager;

@end

@implementation ALMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.exampleManager = [[ALExampleManager alloc] init];
    self.title = @"All Samples";
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.exampleManager numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.exampleManager numberOfExamplesInSectionIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.exampleManager titleForSectionIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    ALExample *example = [self.exampleManager exampleForIndexPath:indexPath];
    cell.textLabel.text = example.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ALExample *example = [self.exampleManager exampleForIndexPath:indexPath];
    
    UIViewController *vc = [[example.viewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
