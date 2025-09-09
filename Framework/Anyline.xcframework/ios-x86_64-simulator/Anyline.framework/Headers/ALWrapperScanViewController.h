#import <UIKit/UIKit.h>
#import "ALWrapperScanContainer.h"
#import "ALWrapperScanContainerState.h"
#import "ALWrapperHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALWrapperScanViewController : UIViewController

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nullable, nonatomic, strong) UIButton *flipOrientationButton;

- (instancetype)initWithWrapperScanContainer:(ALWrapperScanContainer *)wrapperScanContainer;

- (void)dismissWithStatus:(ALWrapperSessionScanResponseStatus *)status
                 message:(NSString * _Nullable)message;

@end

NS_ASSUME_NONNULL_END
