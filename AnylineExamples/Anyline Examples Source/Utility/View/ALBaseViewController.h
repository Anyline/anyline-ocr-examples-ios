//
//  ALBaseViewController.h
//  AnylineExamples
//
//  Created by David Dengg on 15.02.16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALBaseViewController : UIViewController

- (void)stopLoading;

- (void)startLoading;

- (void)displayLabelWithString:(NSString *)sorryString;

- (void)startWebSearchWithURL:(NSString *)inUrl;

- (BOOL)checkConnectionAndWarnUser;

@end
