//
//  ALSerialScanViewPluginComposite.h
//  Anyline
//
//  Created by Angela Brett on 13.11.19.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#import "ALAbstractScanViewPluginComposite.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALSerialScanViewPluginComposite : ALAbstractScanViewPluginComposite

@property (nonatomic, retain, null_unspecified) NSNumber *timeout;

- (BOOL)startFromID:(NSString * _Nonnull)pluginID andReturnError:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
