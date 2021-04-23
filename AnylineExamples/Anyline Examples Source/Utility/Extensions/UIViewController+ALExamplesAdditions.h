//
//  UIViewController+ALExamplesAdditions.h
//  AnylineExamples
//
//  Created by Angela Brett on 14.11.19.
//

#import "UIViewController+ALExamplesAdditions.h"


#import <UIKit/UIKit.h>

@interface UIViewController (ALExamplesAdditions)

- (void)showAlertWithTitle:(NSString *_Nonnull)title message:(NSString *_Nonnull)message;
- (void)showAlertWithTitle:(NSString *_Nonnull)title message:(NSString *_Nonnull)message dismissHandler:(nullable void (^)(UIAlertAction * _Nonnull action)) handler;
- (void)showAlertWithTitle:(NSString *_Nonnull)title message:(NSString *_Nonnull)message  buttonTitle:(NSString *_Nonnull)buttonTitle dismissHandler:(nullable void (^)(UIAlertAction * _Nonnull action))handler;

- (UIViewController *)topViewController:(UIViewController *)rootViewController;

@end
