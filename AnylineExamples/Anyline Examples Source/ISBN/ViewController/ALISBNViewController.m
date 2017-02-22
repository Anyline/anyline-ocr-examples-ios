//
//  ALISBNViewController.m
//  ExampleApi
//
//  Created by David Dengg on 15.02.16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "ALISBNViewController.h"
#import "ISBNInfo.h"
#import "ALISBNHeaderCell.h"
#import "ALTextViewCell.h"
#import "ALISBNAPI.h"
#import "Reachability.h"

NSInteger iLeftDistance = 10;

@interface ALISBNViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSDictionary *cellHeights;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ISBNInfo *isbnInfo;
@property (nonatomic, strong) UIActivityIndicatorView *progessView;
@end

@implementation ALISBNViewController

- (void)setIsbnString:(NSString *)isbnString {
    _isbnString = isbnString;
    
    [self startLoading];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        ALISBNAPI *isbnApi = [[ALISBNAPI alloc] init];
        ISBNInfo *info = [isbnApi infoForISBN:isbnString];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setIsbnInfo:info];
        });
    });
}

- (void)_setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
                                                  style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setAllowsSelection:NO];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    self.cellHeights = [NSMutableDictionary dictionary];
}

- (void)setIsbnInfo:(ISBNInfo *)isbnInfo {
    _isbnInfo = isbnInfo;
    [self stopLoading];
    if( isbnInfo ) {
        [self _setupTableView];
        [self.tableView reloadData];
    } else {
        NSString *isbn = self.isbnString;
        isbn = [isbn stringByReplacingOccurrencesOfString:@"ISBN" withString:@""];
        isbn = [isbn stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [self startWebSearchWithURL:[NSString stringWithFormat:@"https://www.google.at/search?q=ISBN+%@", isbn]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cell = nil;
    if(indexPath.row == 0) {
        
        cell = [[ALISBNHeaderCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 180)];
        [cell updateCellWithTitle:self.isbnInfo.title
                           author:self.isbnInfo.author
                        publisher:self.isbnInfo.publisher
                             year:self.isbnInfo.year
                    thumbnailLink:self.isbnInfo.thumbnailLink];
    }
    
    if(indexPath.row == 1) {
        cell = [[ALTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        self.isbnInfo.summary ? [cell updateCellWithHeader:@"Description" mainText:self.isbnInfo.summary] : 0;
    }
    
    if(indexPath.row == 2) {
        cell = [[ALTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        [cell updateCellWithHeader:@"Product Description" mainText:@""];
        
        // Append the information if available
        self.isbnInfo.pageCount   ? [cell appendMainText:[NSString stringWithFormat:@"Pages: %@\n\n", self.isbnInfo.pageCount]] : 0;
        self.isbnInfo.isbn10      ? [cell appendMainText:[NSString stringWithFormat:@"ISBN 10: %@\n", self.isbnInfo.isbn10]] : 0;
        self.isbnInfo.isbn13      ? [cell appendMainText:[NSString stringWithFormat:@"ISBN 13: %@\n", self.isbnInfo.isbn13]] : 0;
        self.isbnInfo.infoLink    ? [cell appendHyperlink:@"\nSee more Details on Google Books" link:self.isbnInfo.infoLink] : 0;
        self.isbnInfo.previewLink ? [cell appendHyperlink:@"\nPreview available on Google Books" link:self.isbnInfo.previewLink] : 0;
    }
    
    [self.cellHeights setValue:@([cell cellHeight]) forKey:[NSString stringWithFormat:@"%@", @(indexPath.row)]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [[self.cellHeights valueForKey:[NSString stringWithFormat:@"%@", @(indexPath.row)]] floatValue];
    // Some times the loading gets done before self.cellHeights is filled. Return the default value for the header.
    if(height == 0 && indexPath.row == 0) {
        return [ALISBNHeaderCell cellHeight];
    }
    return height;
}

@end
