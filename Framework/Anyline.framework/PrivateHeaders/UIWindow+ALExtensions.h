#import <UIKit/UIKit.h>

@interface UIWindow (ALExtensions)

- (UIViewController * _Nullable)AL_visibleViewController;

+ (UIWindow * _Nullable)AL_keyWindow;

@end
