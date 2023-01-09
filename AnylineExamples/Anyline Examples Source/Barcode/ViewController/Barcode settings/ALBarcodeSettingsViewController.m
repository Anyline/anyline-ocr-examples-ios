//
//  ALBarcodeSettingsViewController.m
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 11.10.22.
//

#import "ALBarcodeSettingsViewController.h"
#import "ALBarcodeFormatHelper.h"
#import "ALSelectionTable.h"
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"
#import "ALBarcodeSettingsTableViewCell.h"

@interface ALBarcodeSettingsViewController () <ALSelectionTableDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *sectionsNamesArray;
@property (nonatomic, strong) NSDictionary *tableContentDictionary;
@property (nonatomic, strong) UITableView *settingsTableView;
@property (nonatomic, strong) UISwitch *switchSingleScan;
@property (nonatomic, strong) UISwitch *switchMultiScan;

@end
NSString * const kKeyTitle = @"title";
NSString * const kKeySelector = @"selector";

NSString * const kSymbolgiesSettings = @"SYMBOLOGIES SETTINGS";
NSString * const kSymbologies = @"Symbologies";

NSString * const kTriggerButtonSettings = @"TRIGGER BUTTON SETTINGS";
NSString * const kSingleScanTriggerButton = @"Single scan trigger button";
NSString * const kMultiScanTriggerButton = @"Multi scan trigger button";

NSString * const kResetSettings = @"RESET SETTINGS";
NSString * const kResetAllSettingsToDefault = @"Reset all settings to default";

NSString * const kBarcodeSettingsCellId = @"barcodeSettingsCellId";

@implementation ALBarcodeSettingsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupVariables];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    [self setupSubviews];
    [self setupSubviewsConstraints];
    // Do any additional setup after loading the view.
}

- (void)setupVariables {
    self.sectionsNamesArray = @[kSymbolgiesSettings, kTriggerButtonSettings, kResetSettings];
    self.tableContentDictionary = @{
        kSymbolgiesSettings : @[@{kKeyTitle : kSymbologies,
                                kKeySelector : [NSValue valueWithPointer:@selector(showSymbologySelector)]}],
        kTriggerButtonSettings : @[@{kKeyTitle : kSingleScanTriggerButton,
                                           kKeySelector : [NSValue valueWithPointer:@selector(isSingleScanTriggerEnabled)]},
                                           @{kKeyTitle : kMultiScanTriggerButton,
                                             kKeySelector : [NSValue valueWithPointer:@selector(isMultiScanTriggerEnabled)]}],
        kResetSettings : @[@{kKeyTitle : kResetAllSettingsToDefault,
                           kKeySelector : [NSValue valueWithPointer:@selector(resetAllConfigurations)]}]
    };
}
- (void)setupSubviews {    
    self.settingsTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.settingsTableView.dataSource = self;
    self.settingsTableView.delegate = self;
    [self.settingsTableView registerClass:[ALBarcodeSettingsTableViewCell class] forCellReuseIdentifier:kBarcodeSettingsCellId];
    [self.settingsTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.settingsTableView.backgroundColor = [UIColor AL_BackgroundSettingsHeaderColor];
    [self.settingsTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.settingsTableView setScrollEnabled:NO];
    [self.view addSubview:self.settingsTableView];
    
    self.switchSingleScan = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 51, 44)];
    [self.switchSingleScan setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.switchSingleScan addTarget:self action:@selector(tapOnSwitchManualSingleScan:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchSingleScan setOnTintColor:[UIColor AL_examplesBlue]];
    [self.switchSingleScan setOn:_isSingleManualScanEnabled];
    
    self.switchMultiScan = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 51, 44)];
    [self.switchMultiScan setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.switchMultiScan addTarget:self action:@selector(tapOnSwitchMultiSingleScan:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchMultiScan setOnTintColor:[UIColor AL_examplesBlue]];
    [self.switchMultiScan setOn:_isMultiManualScanEnabled];
}

- (void)setupSubviewsConstraints {
    NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:10];
    
    [constraints addObjectsFromArray:@[[self.settingsTableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
                                       [self.settingsTableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
                                       [self.settingsTableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                       [self.settingsTableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]]];
    
    [self.view addConstraints:constraints];
    [NSLayoutConstraint activateConstraints:self.view.constraints];
}

// MARK: - Getters and Setters

- (NSArray<ALBarcodeFormat *> *)getDefaultFormatsForDefaultReadableNames {
    NSArray<NSString *> *defaultReadableNames = [ALBarcodeFormatHelper defaultSymbologiesReadableNames];
    NSArray<ALBarcodeFormat *> *formatsForDefaultReadableNames = [ALBarcodeFormatHelper formatsForReadableNames:defaultReadableNames];
    return formatsForDefaultReadableNames;
}

- (NSArray<NSString *> *)getBarcodeFormatOptions {
    return self.barcodeFormatOptions;
}

// MARK: - UITableViewDataSource and UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionsNamesArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *contentArray = [self.tableContentDictionary objectForKey:[self.sectionsNamesArray objectAtIndex:section]];
    return contentArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionsNamesArray[section];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ALBarcodeSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBarcodeSettingsCellId forIndexPath:indexPath];
    NSArray *contentArray = [self.tableContentDictionary objectForKey:[self.sectionsNamesArray objectAtIndex:indexPath.section]];
    NSDictionary *content = contentArray[indexPath.row];
    [[cell textLabel] setText:[content objectForKey:kKeyTitle]];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [[cell rightContentView] addSubview:self.switchSingleScan];
            [[self.switchSingleScan.centerYAnchor constraintEqualToAnchor:cell.rightContentView.centerYAnchor] setActive:YES];
            [[self.switchSingleScan.centerXAnchor constraintEqualToAnchor:cell.rightContentView.centerXAnchor] setActive:YES];
        } else {
            [[cell rightContentView] addSubview:self.switchMultiScan];
            [[self.switchMultiScan.centerYAnchor constraintEqualToAnchor:cell.rightContentView.centerYAnchor] setActive:YES];
            [[self.switchMultiScan.centerXAnchor constraintEqualToAnchor:cell.rightContentView.centerXAnchor] setActive:YES];
        }
    }
    
    if (indexPath.section == 2) {
        [[cell textLabel] setTextColor:[UIColor redColor]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *contentArray = [self.tableContentDictionary objectForKey:[self.sectionsNamesArray objectAtIndex:indexPath.section]];
    NSDictionary *content = contentArray[indexPath.row];
    SEL aSelector = [[content objectForKey:kKeySelector] pointerValue];
    if ([self respondsToSelector:aSelector]) {
        // Since we do a check this will not cause a leak or crashes
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:aSelector];
#pragma clang diagnostic pop
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.frame = CGRectMake(15, 0, tableView.contentSize.width, 20);
    headerLabel.font = [UIFont AL_proximaRegularWithSize:13];
    headerLabel.textColor = [UIColor AL_colorWithHexString:@"85858A"];
    headerLabel.text = [self tableView:tableView titleForHeaderInSection:section];

    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerLabel];

    return headerView;
}

// MARK: - ALSelectionTableDelegate
- (void)showSymbologySelector {
    ALSelectionTable *table = [[ALSelectionTable alloc] initWithSelectedItems:self.barcodeFormatOptions
                                                                     allItems:[ALBarcodeFormatHelper readableBarcodeNamesDict]
                                                                 headerTitles:[ALBarcodeFormatHelper readableHeaderArray]
                                                                 defaultItems:[ALBarcodeFormatHelper defaultSymbologiesReadableNames]
                                                                        title:@"Select Symbologies"
                                                                 singleSelect:NO];
    table.delegate = self;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:table];
    navC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:navC animated:YES completion:NULL];
}

- (void)selectionTable:(ALSelectionTable *)selectionTable selectedItems:(NSArray<NSString *> *)selectedItems {
    self.barcodeFormatOptions = selectedItems;
    [self.delegate selectedSymbologies:selectedItems];
}

// MARK: - ALBarcodeSettingsDelegate
- (IBAction)tapOnSwitchManualSingleScan:(id)sender {
    [self.delegate isSingleScanTriggerEnabled:[self.switchSingleScan isOn]];
}

- (void)isSingleScanTriggerEnabled {
    [self.switchSingleScan setOn:![self.switchSingleScan isOn] animated:YES];
    [self.delegate isSingleScanTriggerEnabled:[self.switchSingleScan isOn]];
}

- (IBAction)tapOnSwitchMultiSingleScan:(id)sender {
    [self.delegate isMultiScanTriggerEnabled:[self.switchMultiScan isOn]];
}

- (void)isMultiScanTriggerEnabled {
    [self.switchMultiScan setOn:![self.switchMultiScan isOn] animated:YES];
    [self.delegate isMultiScanTriggerEnabled:[self.switchMultiScan isOn]];
}

- (void)resetAllConfigurations {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Restore default settings" message:@"Are you sure you want to restore to the default settings" preferredStyle:UIAlertControllerStyleAlert];
    __weak __block ALBarcodeSettingsViewController *weakSelf = self;
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray<NSString *> *formatsForDefaultReadableNames = [ALBarcodeFormatHelper readableNameForFormats:[weakSelf getDefaultFormatsForDefaultReadableNames]];
        weakSelf.barcodeFormatOptions = formatsForDefaultReadableNames;
        [weakSelf.delegate selectedSymbologies:formatsForDefaultReadableNames];
        [weakSelf.switchSingleScan setOn:NO animated:YES];
        [weakSelf.delegate isSingleScanTriggerEnabled:[weakSelf.switchSingleScan isOn]];
        [weakSelf.switchMultiScan setOn:YES animated:YES];
        [weakSelf.delegate isMultiScanTriggerEnabled:[weakSelf.switchMultiScan isOn]];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // do nothing
    }]];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

@end
