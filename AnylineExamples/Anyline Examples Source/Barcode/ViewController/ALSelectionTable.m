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

const CGFloat kSearchBarHeight = 70;
NSString * const kResetSettingsConfirmationMsg = @"This will reset all your barcode type settings to their original defaults.";
NSString * const kResetSettingsBtnTitleCancel = @"Cancel";
NSString * const kResetSettingsBtnTitleReset = @"Reset All Settings";
NSString * const kSearchRegionsPlaceholderText = @"Search regions";

NSString * const kCellTextAll = @"All";
NSString * const kCellTextDeselectAll = @"Deselect all";
NSString * const kCellTextSelectAll = @"Select all";

@interface ALSelectionTable () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) NSDictionary<NSString *, NSArray*>* items;

@property (nonatomic, strong) NSMutableArray *selectedItems;

@property (nonatomic, strong) NSArray<NSString *> *defaultItems;

@property (nonatomic, strong) NSArray<NSString *> *headerTitles;

@property (nonatomic, assign) BOOL singleSelect;

@property (nonatomic, strong) NSString *searchText;

@property (nonatomic, strong) NSArray<NSString *> *filteredItems;

@end


@implementation ALSelectionTable

- (instancetype)initWithSelectedItems:(NSArray<NSString *> *)selectedItems
                             allItems:(NSDictionary<NSString *,NSArray *> *)items
                         headerTitles:(NSArray<NSString *> *)headerTitles
                         defaultItems:(NSArray<NSString *> *)defaultItems
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
    [doneButton setTintColor:[UIColor AL_examplesBlue]];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    [cancelButton setTintColor:[UIColor AL_examplesBlue]];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UISearchBar *searchBar = [[self class] getSearchBar];
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"item"];
}

- (IBAction)doneButtonPressed:(id)sender {
    __weak __block typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.delegate) {
            [weakSelf.delegate selectionTable:weakSelf selectedItems:weakSelf.selectedItems];
        }
    }];
}

- (IBAction)cancelButtonPressed:(id)sender {
    __weak __block typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(selectionTableCancelled:)]) {
            [weakSelf.delegate selectionTableCancelled:weakSelf];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int add = 0;
    if (!self.singleSelect) {
        add += 1;
    }
    if ([self inSearchMode]) {
        return 1 + add; // all search results go inside a single section.
    } else {
        return self.items.allKeys.count + add;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isSelectAllSection:section]) {
        return 1;
    }
    if ([self inSearchMode]) {
        return self.filteredItems.count;
    }
    NSString *header = self.headerTitles[section-1];
    return self.items[header].count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self isSelectAllSection:section]) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
    view.backgroundColor = [UIColor AL_SectionGridBG];

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 305, 38)];
    lbl.font = [UIFont AL_proximaLightWithSize:14];
    lbl.textColor = [UIColor AL_LabelBlackWhite];
    lbl.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lbl];
    
    if ([self inSearchMode]) {
        lbl.text = self.filteredItems.count < 1 ? @"Empty Search Results" : @"Search Results";
    } else {
        lbl.text = self.headerTitles[section-1];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self isSelectAllSection:section]) {
        return 0;
    }
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isSelectAllSection:indexPath.section]) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = kCellTextAll;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor AL_LabelBlackWhite];
        cell.textLabel.font = [UIFont AL_proximaLightWithSize:18];
        __block int numCount = 0;
        [self.items enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
            numCount += obj.count;
        }];
        if (self.selectedItems.count == numCount) {
            cell.detailTextLabel.text = kCellTextDeselectAll;
        } else {
            cell.detailTextLabel.text = kCellTextSelectAll;
        }
        cell.detailTextLabel.font = [UIFont AL_proximaLightWithSize:18];
        cell.detailTextLabel.textColor = [UIColor AL_examplesBlue];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor AL_LabelBlackWhite];
    cell.textLabel.font = [UIFont AL_proximaLightWithSize:18];
    
    if ([self inSearchMode]) {
        cell.textLabel.text = self.filteredItems[indexPath.row];
    } else {
        NSString *key = self.headerTitles[indexPath.section-1];
        cell.textLabel.text = self.items[key][indexPath.row];
    }
    return cell;
    
    NSAssert(NO, @"Something went wrong with %@", NSStringFromClass([self class]));
    return nil; // Never happens ;)
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isSelectAllSection:indexPath.section]) {
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
        [self refreshDoneBtnEnableState];
        [self.tableView reloadData];
        return;
    }

    NSString *key = self.headerTitles[indexPath.section-1];
    NSString *symb = [self inSearchMode] ? self.filteredItems[indexPath.row] : self.items[key][indexPath.row];
    if (!self.singleSelect) {
        if ([self.selectedItems containsObject:symb]) {
            [self.selectedItems removeObject:symb];
        } else {
            [self.selectedItems addObject:symb];
        }
        [self refreshDoneBtnEnableState];
        NSIndexPath *all = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath, all] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        self.selectedItems = [@[symb] mutableCopy];
        [self refreshDoneBtnEnableState];
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    NSString *key = self.headerTitles[indexPath.section-1];
    NSString *symb = [self inSearchMode] ? self.filteredItems[indexPath.row] : self.items[key][indexPath.row];
    if ([self.selectedItems containsObject:symb]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

// MARK: - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchText = searchText;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchText = @"";
    [searchBar resignFirstResponder];
}

// MARK: - Miscellaneous

- (void)refreshDoneBtnEnableState {
    self.navigationItem.rightBarButtonItem.enabled = self.selectedItems.count > 0;
}

- (void)showResetDialog:(void (^ __nullable)(void))resetHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:kResetSettingsConfirmationMsg
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:kResetSettingsBtnTitleCancel
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:kResetSettingsBtnTitleReset
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
        resetHandler();
    }]];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

// MARK: - Search Mode

+ (UISearchBar *)getSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 1, kSearchBarHeight)];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = kSearchRegionsPlaceholderText;
    searchBar.returnKeyType = UIReturnKeyDone;
    searchBar.showsCancelButton = YES;
    [searchBar sizeToFit];
    return searchBar;
}

- (void)setSearchText:(NSString *)searchText {
    _searchText = searchText;
    [self fillFilteredItems];
}

- (void)fillFilteredItems {
    if (_searchText.length < 1) {
        _filteredItems = nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", _searchText];
    self.filteredItems = [_defaultItems filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

- (BOOL)inSearchMode {
    return _searchText.length > 0;
}

- (BOOL)isSelectAllSection:(NSInteger)section {
    return section == 0;
}

@end
