//
//  UIViewController+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Angela Brett on 14.11.19.
//

#import "UIViewController+ALExamplesAdditions.h"

@implementation UIViewController (ALExamplesAdditions)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:dismissAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

@end
