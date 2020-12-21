//
//  ALBaseGridCollectionViewController.h
//  AnylineExamples
//
//  Created by Philipp Müller on 22/11/2017.
//  Copyright © 2017 Anyline GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALExampleManager.h"

@protocol ALExampleManagerController <NSObject>

@required
@property (nonatomic, strong) ALExampleManager *exampleManager;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@interface ALBaseGridCollectionViewController : UICollectionViewController <ALExampleManagerController> 

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) ALExampleManager *exampleManager;
@property (nonatomic, strong) UIView *header;
@property (nonatomic) BOOL showLogo;

- (CGSize)headerSize;
- (void)openExample:(ALExample *)example;
- (UIViewController *)createViewControllerFrom:(ALExample *)example;
- (UIView *)createHeaderViewWithTag:(NSInteger)tag forSize:(CGSize)size title:(NSString *)title;

@end
