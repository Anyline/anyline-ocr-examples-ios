//
//  ALBundleInfoViewController.h
//  AnylineExamples
//
//  Created by David Dengg on 01.06.16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALBundleInfoViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext * managedObjectContext;

- (UIColor *)rgbaToUIColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end
