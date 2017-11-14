//
//  ALMRZScanViewPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 29/05/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALMRZScanPlugin.h"
#import "ALAbstractScanViewPlugin.h"

@interface ALMRZScanViewPlugin : ALAbstractScanViewPlugin

@property (nullable, nonatomic, strong) ALMRZScanPlugin *mrzScanPlugin;

- (_Nullable instancetype)initWithFrame:(CGRect)frame scanPlugin:(ALMRZScanPlugin *_Nonnull)mrzScanPlugin;

@end
