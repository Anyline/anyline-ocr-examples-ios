//
//  ALPrivacyForwardingViewController.m
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 19.01.21.
//

#import "ALPrivacyForwardingViewController.h"
#import "ALPrivacyViewController.h"
#import "UIColor+ALExamplesAdditions.h"

@interface ALPrivacyForwardingViewController () <UITextViewDelegate>

@end

@implementation ALPrivacyForwardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    if ([URL.scheme localizedCaseInsensitiveContainsString:@"privacy-policy"]) {
        ALPrivacyViewController *privacyViewController = [[ALPrivacyViewController alloc] init];
        
        [self.navigationController pushViewController:privacyViewController animated:NO];
        return false;
    } else {
        return true;
    }
}

@end
