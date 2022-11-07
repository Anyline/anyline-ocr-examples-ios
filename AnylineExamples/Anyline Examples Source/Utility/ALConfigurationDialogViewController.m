//
//  ALConfigurationDialogViewController.m
//  AnylineExamples
//
//  Created by Aldrich Co on 7/23/21.
//

#import "ALConfigurationDialogViewController.h"
#import "ALDialogSelectionTableViewCell.h"
#import "UIFont+ALExamplesAdditions.h"

CGFloat const kCellHeight = 48.0f;
NSString * const kHeaderTextGeneric = @"Customize Scanner";
NSString * const kHeaderTextSelectScript = @"Select Script";
NSString * const kHeaderTextSelectScanMode = @"Select Scan Mode";
NSString * const kApplyButtonText = @"Apply";

@interface ALConfigurationDialogViewController () <UITableViewDelegate, UITableViewDataSource, UIAdaptivePresentationControllerDelegate>

@property (nonatomic, strong) NSArray<NSString *> *choices;
@property (nonatomic, strong) NSArray<NSString *> *secondaryTexts;

// Representing the selection(s) made using their 0-based index(es)
// Though this may change later, we are currently only supporting single-value selections.
@property (nonatomic, strong) NSArray<NSNumber *> *selections;

@property (nonatomic, retain) UIView *container;
@property (nonatomic, retain) UILabel *header;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIButton *applyButton;
@property (nonatomic, retain) UIView *clickShield;
@property (nonatomic, strong) UIGestureRecognizer *clickShieldTapGestureRecognizer;
@property (nonatomic, assign) CGFloat dialogSelectionCellFontSize;

@end


@implementation ALConfigurationDialogViewController

- (instancetype)initWithChoices:(NSArray<NSString *> *)choices
                     selections:(NSArray<NSNumber *> *)selections
                 secondaryTexts:(NSArray<NSString *> *)secondaryTexts
                   showApplyBtn:(BOOL)showApplyBtn
                     dialogType:(ALConfigDialogType)dialogType {
    
    if (self = [super init]) {
        _dialogSelectionCellFontSize = 0;
        _choices = choices;
        _selections = selections;
        _type = dialogType;
        _secondaryTexts = secondaryTexts;
        _showApplyButton = showApplyBtn;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    _container = [[UIView alloc] init];
    [self.view addSubview:_container];
    [_container setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_container setBackgroundColor: [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]];
    [_container.layer setCornerRadius: 8.0f];
    if (@available(iOS 13.0, *)) {
        [_container setBackgroundColor:[UIColor systemGroupedBackgroundColor]];
    }
    
    _header = [[UILabel alloc] init];
    [self.container addSubview:_header];
    [_header setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSString *headerText = kHeaderTextGeneric;
    
    switch (_type) {
        case ALConfigDialogTypeScriptSelection:
            headerText = kHeaderTextSelectScript;
            break;
        case ALConfigDialogTypeScanModeSelection:
            headerText = kHeaderTextSelectScanMode;
            break;
        default:
            break;
    }
    
    [_header setText:headerText];
    [_header setFont:[UIFont AL_proximaBoldWithSize:16]];
    [_header setTextColor:[UIColor blackColor]];
    if (@available(iOS 13.0, *)) {
        [_header setTextColor:[UIColor labelColor]];
    }
    
    _applyButton = [[UIButton alloc] init];
    [self.container addSubview:_applyButton];
    [_applyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_applyButton setTitle:kApplyButtonText forState:UIControlStateNormal];
    [_applyButton.titleLabel setFont:[UIFont AL_proximaBoldWithSize:16]];
    [_applyButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [_applyButton addTarget:self action:@selector(didPressApplyButton:) forControlEvents:UIControlEventTouchUpInside];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_container addSubview:_tableView];
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_tableView registerClass:[ALDialogSelectionTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:NO];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView.layer setCornerRadius:8.0];
    
    self.clickShieldTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedClickShield:)];
    
    _clickShield = [[UIView alloc] init];
    [_clickShield setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_clickShield addGestureRecognizer:self.clickShieldTapGestureRecognizer];
    [self.view insertSubview:_clickShield atIndex:0];
    
    if (!_showApplyButton) {
        _applyButton.hidden = YES;
    }
    
    [self setupConstraints];
    self.presentationController.delegate = self;
}

- (void)setupConstraints {
    
    CGFloat tableHeight = self.choices.count * kCellHeight;
    CGFloat margin = 20.0f;
    
    NSArray<NSLayoutConstraint *> *containerConstraints = @[
        [_container.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [_container.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:margin],
        [_container.widthAnchor constraintEqualToAnchor:self.view.widthAnchor constant:-2 * margin],
    ];
    [self.view addConstraints:containerConstraints];
    [NSLayoutConstraint activateConstraints:containerConstraints];
    
    NSArray<NSLayoutConstraint *> *headerConstraints = @[
        [_header.topAnchor constraintEqualToAnchor:_container.topAnchor constant:margin],
        [_header.leadingAnchor constraintEqualToAnchor:_container.leadingAnchor constant:margin],
    ];
    [self.view addConstraints:headerConstraints];
    [NSLayoutConstraint activateConstraints:headerConstraints];
        
    NSArray<NSLayoutConstraint *> *applyButtonConstraints = @[
        [_applyButton.centerYAnchor constraintEqualToAnchor:_header.centerYAnchor],
        [_applyButton.trailingAnchor constraintEqualToAnchor:_container.trailingAnchor constant:-1.5 * margin],
        [_applyButton.leadingAnchor constraintGreaterThanOrEqualToAnchor:_header.trailingAnchor constant:margin],
    ];
    [self.view addConstraints:applyButtonConstraints];
    [NSLayoutConstraint activateConstraints:applyButtonConstraints];
    
    NSArray<NSLayoutConstraint *> *tableViewConstraints = @[
        [_tableView.leadingAnchor constraintEqualToAnchor:_container.leadingAnchor constant:margin],
        [_tableView.widthAnchor constraintEqualToAnchor:_container.widthAnchor constant:-2 * margin],
        [_tableView.heightAnchor constraintEqualToConstant:tableHeight],
        [_tableView.topAnchor constraintEqualToAnchor:_header.bottomAnchor constant:margin],
        [_tableView.bottomAnchor constraintEqualToAnchor:_container.bottomAnchor constant:-1.5* margin],
    ];
    [self.view addConstraints:tableViewConstraints];
    [NSLayoutConstraint activateConstraints:tableViewConstraints];
    
    NSArray<NSLayoutConstraint *> *clickShieldConstraints = @[
        [_clickShield.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [_clickShield.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_clickShield.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [_clickShield.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],
    ];
    [self.view addConstraints:clickShieldConstraints];
    [NSLayoutConstraint activateConstraints:clickShieldConstraints];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ALDialogSelectionTableViewCell *cell = (ALDialogSelectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[ALDialogSelectionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                     reuseIdentifier:@"cell"];
    }
    [cell setMainText:self.choices[indexPath.item]];
    
    // if row is the last one we don't want to show a separator line at the bottom.
    BOOL isLastRow = indexPath.row == self.choices.count - 1;
    [cell showSeparator:!isLastRow];
     if (_dialogSelectionCellFontSize > 0) {
        [cell setMainTextFontSize:_dialogSelectionCellFontSize];
    }
    if (self.type == ALConfigDialogTypeOverview) {
        [cell setSelectionStatusText:self.secondaryTexts[indexPath.row]];
    } else {
        BOOL showCheckmark = NO;
        NSNumber *selectedIndex = [self selectedIndex];
        if (selectedIndex) {
            showCheckmark = indexPath.row == selectedIndex.unsignedIntValue;
        }
        [cell showCheckmark:showCheckmark];
        [cell setSelectionStatusText:@""];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _choices.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_type) {
        case ALConfigDialogTypeScriptSelection:
        case ALConfigDialogTypeScanModeSelection:
            self.selections = @[@(indexPath.row)];
            [tableView reloadData];
            break;
        default: break;
    }
    [self.delegate configDialog:self selectedIndex:indexPath.row];
}

- (void)didPressApplyButton:(id)button {
    [self.delegate configDialogCommitted:YES dialog:self];
}

- (void)presentationControllerDidDismiss:(UIPresentationController *)presentationController {
    [self.delegate configDialogCancelled:self];
}

// MARK: - Miscellaneous

// applicable for display modes that return only one selected index, if at all
- (NSNumber *)selectedIndex {
    if (((self.type == ALConfigDialogTypeScriptSelection) || (self.type == ALConfigDialogTypeScanModeSelection)) &&
        (self.selections.count > 0)){
        return self.selections[0];
    }
    return nil;
}

- (void)setSelectionDialogFontSize:(CGFloat)dialogFontSize {
    _dialogSelectionCellFontSize = dialogFontSize;
}

- (void)tappedClickShield:(UIGestureRecognizer *)gestureRecognizer {
    __weak __block typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf.delegate configDialogCancelled:self];
    }];
}

@end
