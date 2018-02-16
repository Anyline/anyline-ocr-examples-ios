//
//  ALOnboardingMailViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 19/08/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALOnboardingMailViewController.h"


#import "ALReportingController.h"

#import "UIFont+ALExamplesAdditions.h"
#import "UIColor+ALExamplesAdditions.h"

#import "NSUserDefaults+ALExamplesAdditions.h"

@interface ALOnboardingMailViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *mailField;

@end

@implementation ALOnboardingMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *welcome = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat"]];
    welcome.center = CGPointMake(self.view.center.x, 200);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] nativeBounds].size.height == 960) {
        welcome.frame = CGRectMake(0, 0, 140, 140);
        welcome.center = CGPointMake(self.view.center.x, 100);
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] nativeBounds].size.height == 1136) {
        welcome.frame = CGRectMake(0, 0, 220, 220);
        welcome.center = CGPointMake(self.view.center.x, 150);
    }
    
    
    
    [self.view addSubview:welcome];
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, welcome.frame.origin.y + welcome.frame.size.height + 30, 300, 40)];
        label.text = @"QUESTIONS WHILE SCANNING?";
        label.font = [UIFont AL_proximaBoldWithSize:21];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        label.center = CGPointMake(self.view.center.x, label.center.y);
        [self.view addSubview:label];
    }
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, welcome.frame.origin.y + welcome.frame.size.height + 70, 300, 80)];
        label.text = @"Don't hesitate to simply reach out via the live chat while scanning or - if you need any additional support - simply share your email address with us, and we'll have a team member get back to you right away.";
        label.numberOfLines = 0;
        label.font = [UIFont AL_proximaRegularWithSize:17];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        label.center = CGPointMake(self.view.center.x, label.center.y);
        [self.view addSubview:label];
    }
    
    self.mailField = [[UITextField alloc] initWithFrame:CGRectMake(0, welcome.frame.origin.y + welcome.frame.size.height + 210, 280, 40)];
    self.mailField.text = [NSUserDefaults AL_getMail];
    self.mailField.placeholder = @"helpmescan@example.com";
    self.mailField.center = CGPointMake(self.view.center.x, self.mailField.center.y);
    self.mailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.mailField.returnKeyType = UIReturnKeyDone;
    self.mailField.delegate = self;
    self.mailField.textAlignment = NSTextAlignmentCenter;
    self.mailField.font = [UIFont AL_proximaRegularWithSize:19];
    self.mailField.textColor = [UIColor AL_examplesBlue];
    self.mailField.backgroundColor = [UIColor whiteColor];
    self.mailField.rightViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:self.mailField];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -200., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +200., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * address = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (address.length == 0) {
        textField.rightView = nil;
        
        return YES;
    }
    
    BOOL isValid = [self validateEmailWithString:address];
    
    
    if (isValid) {
        textField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_done_white_48pt"]];
    } else {
        textField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_error_outline_white_48pt"]];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self saveMail]) {
        if (textField.text.length != 0) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    } else {
        return NO;
    }
    return YES;
}

- (BOOL)saveMail {
    NSString * address = self.mailField.text;
    
    if (address.length == 0) {
        [self.mailField  resignFirstResponder];
        return YES;
    }
    
    BOOL isValid = [self validateEmailWithString:address];
    
    if (!isValid) {
        [[[UIAlertView alloc] initWithTitle:@"Address Error"
                                    message:@"Something seems wrong with the address you entered."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return NO;
    }
    
    NSString *mail = [NSUserDefaults AL_getMail];
    if (mail)
        [ALReportingController resetUser];
    
    [ALReportingController registerUser:address source:@"AppOnBoarding"];
    
    [NSUserDefaults AL_setMail:address];
    
    [self.mailField  resignFirstResponder];
    
    return YES;
}

- (BOOL)validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [self.mailField resignFirstResponder];
}

@end
