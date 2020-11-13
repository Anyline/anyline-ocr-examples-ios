//
//  UIViewController+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Angela Brett on 14.11.19.
//

#import "UIViewController+ALExamplesAdditions.h"

@implementation UIViewController (ALExamplesAdditions)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [self showAlertWithTitle:title message:message dismissHandler:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissHandler:(void (^)(UIAlertAction *action))handler {
    [self showAlertWithTitle:title message:message  buttonTitle:@"OK" dismissHandler:handler];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle dismissHandler:(void (^)(UIAlertAction *action))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleCancel handler:handler];
    [alertController addAction:dismissAction];
    [self.navigationController ? self.navigationController : self presentViewController:alertController animated:YES completion:nil];
}

@end
