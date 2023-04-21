//
//  ALConfigurationDialogViewController.h
//  AnylineExamples
//
//  Created by Aldrich Co on 7/23/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum selectionType {
    ALConfigDialogTypeOverview = 0,
    ALConfigDialogTypeScriptSelection,
    ALConfigDialogTypeScanModeSelection
} ALConfigDialogType;

@protocol ALConfigurationDialogViewControllerDelegate;

@interface ALConfigurationDialogViewController : UIViewController

@property (nonatomic, weak) id<ALConfigurationDialogViewControllerDelegate> delegate;

@property (nonatomic, assign) ALConfigDialogType type;

@property (nonatomic, assign) BOOL showApplyButton;

/// Creates a controller that manages a (potentially) multi-stage dialog and gives back the user selections.
/// @param choices Shown as the main text on the tableview cells
/// @param selections If not nil, will be used to determine if an entry contains the checkmark.
/// @param secondaryTexts Typically contain supplementary data; in /Options/ mode, contains what was previously
/// selected on Regions and Scripts.
/// @param showApplyBtn If YES, makes the dialog _terminal_, meaning clicking on the Apply button marks the end
/// of the flow.
/// @param dialogType Choices can be found in ALConfigDialogType
- (instancetype)initWithChoices:(NSArray<NSString *> *)choices
                     selections:(NSArray<NSNumber *> *)selections
                 secondaryTexts:(NSArray<NSString *> *)secondaryTexts
                   showApplyBtn:(BOOL)showApplyBtn
                     dialogType:(ALConfigDialogType)dialogType;

//- (NSNumber *)selectedIndex;

@property (nonatomic, assign) NSInteger selectedIndex;

- (void)setSelectionDialogFontSize:(CGFloat)dialogFontSize;

/// Creates an ALConfigurationDialogViewController suitable for scan mode switches, a common usage for this type
/// of dialog. A list of string is shown on an UIActionSheet-type dialog, with the first one by default selected.
/// - Parameters:
///   - choices: an array of NSString to be shown on the dialog
///   - selectedIndex: the index of the selected entry to be shown
///   - delegate: the delegate for the controller
+ (ALConfigurationDialogViewController *)singleSelectDialogWithChoices:(NSArray<NSString *> *)choices
                                                         selectedIndex:(NSUInteger)index
                                                              delegate:(id<ALConfigurationDialogViewControllerDelegate>)delegate;

@end

@protocol ALConfigurationDialogViewControllerDelegate <NSObject>
@required

- (void)configDialog:(ALConfigurationDialogViewController *)dialog selectedIndex:(NSUInteger)index;
- (void)configDialogCommitted:(BOOL)commited dialog:(ALConfigurationDialogViewController *)dialog;
- (void)configDialogCancelled:(ALConfigurationDialogViewController *)dialog;

@end

NS_ASSUME_NONNULL_END
