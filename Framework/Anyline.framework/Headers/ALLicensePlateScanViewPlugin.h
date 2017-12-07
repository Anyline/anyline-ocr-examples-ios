//
//  ALLicensePlateScanViewPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 19/10/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALAbstractScanViewPlugin.h"
#import "ALLicensePlateScanPlugin.h"

@interface ALLicensePlateScanViewPlugin : ALAbstractScanViewPlugin

@property (nullable, nonatomic, strong) ALLicensePlateScanPlugin *licensePlateScanPlugin;

- (_Nullable instancetype)initWithFrame:(CGRect)frame scanPlugin:(ALLicensePlateScanPlugin *_Nonnull)licensePlateScanPlugin;

@end
