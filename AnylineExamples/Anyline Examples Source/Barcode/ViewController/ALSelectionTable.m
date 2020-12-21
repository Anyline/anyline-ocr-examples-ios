//
//  ALSymbologySelectionTable.m
//  AnylineExamples
//
//  Created by David Dengg on 03.12.20.
//

#import "ALSelectionTable.h"
#import <Anyline/Anyline.h>
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"

@interface ALSelectionTable () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary<NSString *,NSArray*>* items;
@property (nonatomic, strong) NSMutableArray* selectedItems;
@property (nonatomic, strong) NSArray<NSString *>* defaultItems;
@property (nonatomic, strong) NSArray<NSString *>* headerTitles;

@property (nonatomic, assign) BOOL singleSelect;

@end

@implementation ALSelectionTable

- (instancetype)initWithSelectedItems:(NSArray<NSString*>*)selectedItems
                             allItems:(NSDictionary<NSString *,NSArray*>*)items
                         headerTitles:(NSArray<NSString *>*)headerTitles
                         defaultItems:(NSArray<NSString*>*)defaultItems
                                title:(NSString *)title
                         singleSelect:(BOOL)singleSelect
{
    self = [super init];
    if (self) {
        self.items = items;
        self.selectedItems = [selectedItems mutableCopy];
        self.singleSelect = singleSelect;
        self.defaultItems = defaultItems;
        self.headerTitles = headerTitles;
        
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (IBAction)doneButtonPressed:(id)sender {
    if (self.delegate) {
        [self.delegate selectionTable:self selectedItems:self.selectedItems];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)cancelButtonPressed:(id)sender {    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int add = 1;
    if (!self.singleSelect) {
        add = 2;
    }
    return self.items.allKeys.count + add;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (!self.singleSelect) {
        if (section == self.headerTitles.count + 1) {
            return 1;
        }
    }
    NSString *header = self.headerTitles[section-1];
    return self.items[header].count;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if( section == 0) {
        
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
    
    view.backgroundColor = [UIColor AL_gray];
    
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 305, 38)];
    lbl.font      = [UIFont AL_proximaLightWithSize:14];
    lbl.textColor = [UIColor darkTextColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    
    [view addSubview:lbl];
    
    if (!self.singleSelect) {
        if( section == (self.items.allKeys.count + 1)) {
            lbl.text      = @"";
            return view;
        }
    }
    lbl.text = self.headerTitles[section-1];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = @"All";
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor secondaryLabelColor];
        cell.textLabel.font = [UIFont AL_proximaLightWithSize:18];
        __block int numCount = 0;
        [self.items enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
            numCount += obj.count;
        }];
        if (self.selectedItems.count == numCount) {
            cell.detailTextLabel.text = @"Deselect all";
        } else {
            cell.detailTextLabel.text = @"Select all";
        }
        
        cell.detailTextLabel.font = [UIFont AL_proximaLightWithSize:18];
        cell.detailTextLabel.textColor = [UIColor AL_examplesBlue];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        
        return cell;
    }
    if (!self.singleSelect) {
        if(indexPath.section == self.items.allKeys.count + 1) {
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"Reset Settings";
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.textColor = [UIColor AL_examplesBlue];
            cell.textLabel.font = [UIFont AL_proximaLightWithSize:18];
            return cell;
        }
    }

    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    NSString *key = self.headerTitles[indexPath.section-1];
    cell.textLabel.text = self.items[key][indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor labelColor];
    cell.textLabel.font = [UIFont AL_proximaLightWithSize:18];
    
    return cell;
    
    NSAssert(NO, @"Something went wrong with %@", NSStringFromClass([self class]));
    // Never happens ;)
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            __block int numCount = 0;
            [self.items enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
                numCount += obj.count;
            }];
            if (self.selectedItems.count == numCount) {
                self.selectedItems = [@[] mutableCopy];
            } else {
                NSMutableArray *allItems = [@[] mutableCopy];
                for (NSArray *items in self.items.allValues) {
                    [allItems addObjectsFromArray:items];
                }
                self.selectedItems = allItems;
            }
            
            if (self.selectedItems.count == 0) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            } else {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            
            [self.tableView reloadData];
            return;
        }
    }
    if (!self.singleSelect) {
        if(indexPath.section == self.items.allKeys.count + 1) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                     message:@"This will reset all your barcode type settings to their original defaults."
                                                                              preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Reset All Settings" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                self.selectedItems = [self.defaultItems mutableCopy];
                
                if (self.selectedItems.count == 0) {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                } else {
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                }
                
                [self.tableView reloadData];
            }]];
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
    }
    
    NSString *key = self.headerTitles[indexPath.section-1];
    NSString *symb = self.items[key][indexPath.row];
    
    if (!self.singleSelect) {
        if([self.selectedItems containsObject:symb]) {
            [self.selectedItems removeObject:symb];
        } else {
            [self.selectedItems addObject:symb];
        }
        
        if (self.selectedItems.count == 0) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        } else {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        
        NSIndexPath *all = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath,all] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        self.selectedItems = [@[symb] mutableCopy];
            
        if (self.selectedItems.count == 0) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        } else {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == self.items.allKeys.count + 1 || indexPath.section == 0) {
        return;
    }
    NSString *key = self.headerTitles[indexPath.section-1];
    NSString * symb = self.items[key][indexPath.row];
    
    if([self.selectedItems containsObject:symb]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
