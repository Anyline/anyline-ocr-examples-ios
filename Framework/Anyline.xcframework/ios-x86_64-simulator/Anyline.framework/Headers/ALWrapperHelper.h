#import "../ALWrapperSessionParameters.h"
#import "ALWrapperScanContainer.h"
#import "ALWrapperRoundedView.h"

NS_ASSUME_NONNULL_BEGIN

@class ALPluginConfig;

@interface ALWrapperHelper : NSObject

+ (void)startScan:(ALWrapperScanContainer *)wrapperScanContainer
topViewController:(nullable UIViewController *)topViewController;

+ (UILabel *)createLabelForView:(UIView *)view;

+ (UIButton *)createButtonForViewController:(UIViewController *)viewController
                                     config:(nullable ALWrapperSessionScanViewConfigOptionDoneButton *)config
                                    refView:(UIView *)refView;

+ (UIToolbar *)createToolbarForViewController:(UIViewController *)viewController
                                     config:(nullable ALWrapperSessionScanViewConfigOptions *)config;

+ (ALWrapperRoundedView *)createRoundedViewForViewController:(UIViewController *)viewController;

+ (UISegmentedControl * _Nullable)createSegmentForViewController:(UIViewController *)viewController
                                                          config:(nullable ALWrapperSessionScanViewConfigOptionSegmentConfig *)config;


+ (void)updateButtonPosition:(UIButton *)button
                  xAlignment:(ALPositionXAlignment * _Nullable)buttonXAlignment
                  yAlignment:(ALPositionYAlignment * _Nullable)buttonYAlignment
             xPositionOffset:(CGFloat)buttonXPositionOffset
             yPositionOffset:(CGFloat)buttonYPositionOffset
               containerView:(UIView *) containerView
                     refView:(UIView *) refView;
    
+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (void)showErrorAlertWithTitle:(NSString *)title
                        message:(NSString *)message
       presentingViewController:(UIViewController *)presentingViewController;

+ (BOOL)showErrorAlertIfNeeded:(NSError *)error;

+ (NSDate * _Nullable)formattedStringToDate:(NSString *)formattedStr;

+ (NSString *)stringForDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END

