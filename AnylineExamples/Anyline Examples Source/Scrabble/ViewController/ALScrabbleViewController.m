//
//  ALScrabbleViewController.m
//  ExampleApi
//
//  Created by David Dengg on 14.02.16.
//  Copyright © 2016 9yards. All rights reserved.
//

#import "ALScrabbleViewController.h"
#import "ALScrabbleLabel.h"
#import "ALAnagramAPI.h"
#import "ALScrabbleWord.h"

@interface ALScrabbleViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSDictionary *cellHeights;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *wordArray;
@end

@implementation ALScrabbleViewController

/*
 The word setter triggers the search for an anagram
 */
- (void)setScrabbleWord:(NSString *)word {
    if(![self checkConnectionAndWarnUser]) {
        return;
    }
    _scrabbleWord = word;
    [self startLoading];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        ALAnagramAPI *anagramApi = [[ALAnagramAPI alloc] init];
        NSArray *words = [anagramApi wordsForString:word];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setWordAndLoadWordArray:words];
        });
    });
}

/*
 Setup the table view only if needed
 */
- (void)_setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
                                                  style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setAllowsSelection:NO];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    ALScrabbleLabel *lbl = [[ALScrabbleLabel alloc] initWithFrame:CGRectMake(0, 60, self.tableView.bounds.size.width, 60)];
    lbl.text = self.scrabbleWord;
    lbl.backgroundColor = [UIColor colorWithRed:(float)46 / 255.0 green:(float)91 / 255.0 blue:(float)72 / 255.0 alpha:1.0];
    self.tableView.tableHeaderView = lbl;
    
    [self.view addSubview:self.tableView];
}

/*
 Setting the word array triggers the
 */
- (void)setWordAndLoadWordArray:(NSArray *)wordArray {
    self.wordArray = wordArray;
    [self stopLoading];
    if( wordArray ) {
        // We found some words. Load table view
        [self _setupTableView];
        [self.tableView reloadData];
    } else {
        // Nothing found :(
        [self displayLabelWithString:@"Sorry, I was not able to find a match for your letters"];
    }
}

#pragma mark UITableView delegate and data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.wordArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.wordArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ALScrabbleLabel *lbl;
    if (![cell viewWithTag:11]) {
        ALScrabbleLabel * lbl = [[ALScrabbleLabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 40)];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:lbl];
        [lbl setTag:11];
        [lbl bringSubviewToFront:lbl];
    }
    
    lbl = [cell viewWithTag:11];
    ALScrabbleWord *word = self.wordArray[indexPath.section][indexPath.row];
    lbl.text = word.word;
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // Create and return a header containing the points for the section
    ALScrabbleWord *word = [self.wordArray[section] lastObject];
    NSString *title = [NSString stringWithFormat:@"%ld Points" , (long)[word points]];
    
    UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 20)];
    pointsLabel.text = title;
    pointsLabel.font = [UIFont boldSystemFontOfSize:12];
    pointsLabel.textAlignment = NSTextAlignmentCenter;
    pointsLabel.backgroundColor = [UIColor colorWithRed:(float)46 / 255.0 green:(float)91 / 255.0 blue:(float)72 / 255.0 alpha:1.0];
    pointsLabel.textColor = [UIColor whiteColor];
    
    return pointsLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

@end
