//
//  UIToolbar+ExamplesExtensions.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 19/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "UIToolbar+ExamplesExtensions.h"
#import "ALCustomBarButton.h"

@implementation UIToolbar (ExamplesExtensions)

+ (instancetype)AL_toolbarWithFrame:(CGRect)frame
                             images:(NSArray<UIImage *> *)images
                             titles:(NSArray<NSString *> *)titles
                             target:(id)target
                          selectors:(NSArray<NSValue *> *)selectors {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:frame];
    
    NSMutableArray<UIBarButtonItem *> *toolItems = [[NSMutableArray<UIBarButtonItem *> alloc] initWithCapacity:4];
    
    ALCustomBarButton *barButtonSDK = [ALCustomBarButton buttonWithType:UIButtonTypeCustom image:[UIImage imageNamed:@"BankcardScan"] title:@"Free SDK"];
    [barButtonSDK addTarget:self action:@selector(barSDKPressed:) forControlEvents:UIControlEventTouchUpInside];
    [toolItems addObject:[[UIBarButtonItem alloc] initWithCustomView:barButtonSDK]];
    
    ALCustomBarButton *barButtonSamples = [ALCustomBarButton buttonWithType:UIButtonTypeCustom image:[UIImage imageNamed:@"BankcardScan"] title:@"Samples"];
    [barButtonSamples addTarget:self action:@selector(barSDKPressed:) forControlEvents:UIControlEventTouchUpInside];
    [toolItems addObject:[[UIBarButtonItem alloc] initWithCustomView:barButtonSamples]];
    
    [toolbar setItems:toolItems];
    
    return toolbar;
}

- (void)barSDKPressed:(id)sender {
    
}

@end
