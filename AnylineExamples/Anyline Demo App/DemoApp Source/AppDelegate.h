//
//  AppDelegate.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 05/02/15.
//  Copyright (c) 2015 9yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) BOOL enableLandscapeRight;

- (NSManagedObjectContext *)managedObjectContext;

@end

