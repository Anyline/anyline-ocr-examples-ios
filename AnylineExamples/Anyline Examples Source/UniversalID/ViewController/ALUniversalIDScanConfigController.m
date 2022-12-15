#import "ALUniversalIDScanConfigController.h"
#import "ALIDCountryHelper.h"
#import "ALSelectionTable.h"

NSString * const kSelectRegionText = @"Select Region";
NSString * const kSelectScriptText = @"Select Script";
NSString * const kAllRegionsText = @"All Regions";
NSString * const kAllRegionsFormat = @"%u Regions";

@implementation ALUniversalIDScanConfig

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setRegions:[self.regions copyWithZone:zone]];
        [copy setScriptType:self.scriptType];
    }
    return copy;
}

- (instancetype)initWithRegions:(NSArray<NSString *> *)regions scriptType:(ALScriptType)scriptType {
    if (self = [self init]) {
        _regions = regions;
        _scriptType = scriptType;
    }
    return self;
}

@end

@interface ALUniversalIDScanConfigController () <ALConfigurationDialogViewControllerDelegate, ALSelectionTableDelegate, UIAdaptivePresentationControllerDelegate>

@property (nonatomic, strong) ALUniversalIDScanConfig *savedConfig;

@property (nonatomic, assign) ALConfigDialogType selectMode;

@property (nonatomic, weak) ALIDCountryHelper *idCountryHelper;

@end

@implementation ALUniversalIDScanConfigController

- (instancetype)initWithPresentingVC:(UIViewController *)presentingVC
                       countryHelper:(ALIDCountryHelper *)idCountryHelper
                          selectMode:(ALConfigDialogType)selectMode
                            delegate:(nonnull id<ALUniversalIDScanConfigControllerDelegate>)delegate {
    if (self = [super init]) {
        _presentingViewController = presentingVC;
        _delegate = delegate;
        _selectMode = selectMode;
        _idCountryHelper = idCountryHelper;
    }
    return self;
}

- (void)setConfig:(ALUniversalIDScanConfig *)config {
    _config = config;
    self.savedConfig = [config copy];
}

- (void)start {
    switch (self.selectMode) {
        case ALConfigDialogTypeOverview:
            [self showOptionsSelectionDialog];
            break;
        case ALConfigDialogTypeScriptSelection:
            [self showSelectScriptDialog];
            break;
        default:
            break;
    }
}

- (void)showOptionsSelectionDialog {
    UIViewController *pvc = self.presentingViewController;
    NSArray<NSString *> *choices = @[ kSelectScriptText, kSelectRegionText ];
    NSArray<NSString *> *subTexts = [self getSubTextsFromRegions:self.config.regions scriptType:self.config.scriptType];
    NSArray<NSNumber *> *selections = nil;
    BOOL hasChanges = [self configHasChanged];
    ALConfigurationDialogViewController *vc = [[ALConfigurationDialogViewController alloc]
                                               initWithChoices:choices
                                               selections:selections
                                               secondaryTexts:subTexts
                                               showApplyBtn:hasChanges
                                               dialogType:ALConfigDialogTypeOverview];
    vc.delegate = self;
    [pvc presentViewController:vc animated:YES completion:nil];
    [self.delegate dialogStarted];
}

- (void)showSelectRegionDialog {
    NSDictionary<NSString *, NSArray<NSString *> *> *regionTemplateMap = [_idCountryHelper idTemplateList];
    NSArray *headers = [self sortedHeadersForRegionTemplateMap:regionTemplateMap];
    
    NSString *title = kSelectRegionText;
    NSArray<NSString *> *countryList = [_idCountryHelper defaultTemplates];
    ALSelectionTable *selectionTable = [[ALSelectionTable alloc] initWithSelectedItems:self.config.regions
                                                                              allItems:regionTemplateMap
                                                                          headerTitles:headers
                                                                          defaultItems:countryList
                                                                                 title:title
                                                                          singleSelect:YES];
    selectionTable.delegate = self;
    
    
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:selectionTable];
    [self.presentingViewController presentViewController:navC animated:YES completion:NULL];
    navC.presentationController.delegate = self;
}

- (void)showSelectScriptDialog {
    [self showSelectScriptDialogWithApplyButton:NO];
}

- (void)showSelectScriptDialogWithApplyButton:(BOOL)showApplyBtn {
    NSArray<NSString *> *choices = [[self class] scripts];
    NSArray<NSNumber *> *selections = [self scriptsSelected];
    ALConfigurationDialogViewController *vc = [[ALConfigurationDialogViewController alloc]
                                               initWithChoices:choices
                                               selections:selections
                                               secondaryTexts:@[]
                                               showApplyBtn:showApplyBtn
                                               dialogType:ALConfigDialogTypeScriptSelection];
    vc.delegate = self;
    [self.presentingViewController presentViewController:vc animated:YES completion:nil];
}

// MARK: - ALConfigurationDialogViewControllerDelegate

- (void)concludeWithMode:(ALConfigDialogType)mode {
    switch (mode) {
        case ALConfigDialogTypeOverview:
            [self showOptionsSelectionDialog];
            break;
        case ALConfigDialogTypeScriptSelection:
            [self.delegate idScanConfigController:self
                        finishedWithUpdatedConfig:[self configHasChanged]];
            break;
    }
}

- (void)configDialog:(nonnull ALConfigurationDialogViewController *)dialog selectedIndex:(NSUInteger)index {
    __weak __block typeof(self) weakSelf = self;
    switch (dialog.type) {
        case ALConfigDialogTypeScriptSelection:
            [self updateConfigForCommittedScriptIndex:index];
            [self dismissDialog:dialog afterDelay:0.5 completion:^{
                [weakSelf concludeWithMode:weakSelf.selectMode];
            }];
            break;
        case ALConfigDialogTypeOverview:
            [dialog dismissViewControllerAnimated:YES completion:^{
                switch (index) {
                    case 0: [weakSelf showSelectScriptDialog]; break;
                    case 1: [weakSelf showSelectRegionDialog]; break;
                    default: break;
                }
            }];
            break;
    }
}

- (void)configDialogCommitted:(BOOL)commited dialog:(nonnull ALConfigurationDialogViewController *)dialog {
    if (dialog.type == ALConfigDialogTypeOverview) {
        BOOL hasUpdates = [self configHasChanged];
        __weak __block typeof(self) weakSelf = self;
        [dialog dismissViewControllerAnimated:YES completion:^{
            [weakSelf.delegate idScanConfigController:self finishedWithUpdatedConfig:hasUpdates];
        }];
    } else if (dialog.type == ALConfigDialogTypeScriptSelection) {
        [self updateConfigForCommittedScriptIndex:dialog.selectedIndex.unsignedIntValue];
        __weak __block typeof(self) weakSelf = self;
        [dialog dismissViewControllerAnimated:YES completion:^{
            if (dialog.showApplyButton) {
                [weakSelf.delegate idScanConfigController:self finishedWithUpdatedConfig:YES];
            } else {
                [weakSelf showOptionsSelectionDialog];
            }
        }];
    }
}

- (void)configDialogCancelled:(ALConfigurationDialogViewController *)dialog {
    [self.delegate dialogCancelled];
}

// MARK: - ALSelectionTableDelegate

- (void)selectionTable:(ALSelectionTable *)selectionTable selectedItems:(NSArray<NSString *> *)selectedItems {
    self.config.regions = selectedItems;
    [self showOptionsSelectionDialog];
}

- (void)selectionTableCancelled:(ALSelectionTable *)selectionTable {
    [self showOptionsSelectionDialog];
}

// when pulling down the region selection dialog to dismiss it...
- (void)presentationControllerDidDismiss:(UIPresentationController *)presentationController {
    UIViewController *presented = presentationController.presentedViewController;
    if ([presented isKindOfClass:[UINavigationController class]]) {
        UIViewController *topVC = [((UINavigationController *)presented) topViewController];
        if ([topVC isKindOfClass:[ALSelectionTable class]]) {
            [self showOptionsSelectionDialog];
        }
    }
}

// MARK: - Miscellaneous

- (void)dismissDialog:(ALConfigurationDialogViewController *)dialog afterDelay:(NSTimeInterval)delay completion:(void (^ __nullable)(void))completion {
    __weak __block ALConfigurationDialogViewController *weakDialog = dialog;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        [weakDialog dismissViewControllerAnimated:YES completion:completion];
    });
}

- (NSArray<NSString *> *)sortedHeadersForRegionTemplateMap:(NSDictionary<NSString *, NSArray<NSString *> *> *)regionTemplateMap {
    
    // NOTE: this sort will put shorter header names first (prioritizing "USA"). It only works as intended
    // with the default template region map. I kept it here because it is found on the original code,
    // before non-Latin scripts configurations had been introduced.
    NSComparisonResult (^sortByDecreasingHeaderLength)(NSString * _Nonnull obj1, NSString *  _Nonnull obj2) = ^NSComparisonResult(NSString * _Nonnull obj1, NSString *  _Nonnull obj2) {
        if (obj1.length < obj2.length) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    };
    
    // the sensible default would be a case insensitive sort of the headers
    NSComparisonResult (^sortCaseInsensitive)(NSString * _Nonnull obj1, NSString *  _Nonnull obj2) = ^NSComparisonResult(NSString * _Nonnull obj1, NSString *  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    };
    
    if (self.idCountryHelper.scriptType == ALScriptTypeLatin) {
        return [regionTemplateMap.allKeys sortedArrayUsingComparator:sortByDecreasingHeaderLength];
    }
    return [regionTemplateMap.allKeys sortedArrayUsingComparator:sortCaseInsensitive];
}

- (void)updateConfigForCommittedScriptIndex:(NSUInteger)index {
    ALScriptType selectedScriptType = [self scriptTypeForIndex:index];
    BOOL scriptIsChanging = _config.scriptType != selectedScriptType;
    if (scriptIsChanging) {
        [self.delegate idScanConfigController:self isChangingScript:selectedScriptType];
        self.config.regions = [_idCountryHelper defaultTemplates];
    }
    self.config.scriptType = selectedScriptType;
}

// when config (region / script) is already different from one originally loaded
- (BOOL)configHasChanged {
    BOOL scriptChanged = self.config.scriptType != self.savedConfig.scriptType;
    BOOL newRegionConfigHasChanged = ![[NSSet setWithArray:self.config.regions] isEqualToSet:[NSSet setWithArray:self.savedConfig.regions]];
    return scriptChanged || newRegionConfigHasChanged;
}

- (NSArray<NSNumber *> *)scriptsSelected {
    // result is an array with a single int -- the index of the enum value.
    return @[@(self.config.scriptType)];
}

- (ALScriptType)scriptTypeForIndex:(NSUInteger)index {
    return (ALScriptType)index;
}

- (NSArray<NSString *> *)getSubTextsFromRegions:(NSArray *)regions scriptType:(ALScriptType)scriptType {
    NSString *script = [[self class] scripts][scriptType];
    NSString *region = [NSString stringWithFormat:kAllRegionsText];
    if (regions.count == 1) {
        region = regions[0];
    } else if (regions.count != [self.idCountryHelper defaultTemplates].count) {
        region = [NSString stringWithFormat:kAllRegionsFormat, (unsigned)regions.count];
    }
    return @[script, region];
}

// NOTE: the array MUST correspond to the values of enum ALScriptType
+ (NSArray<NSString *> *)scripts {
    return @[ @"Latin", @"Arabic", @"Cyrillic" ];
}

@end
