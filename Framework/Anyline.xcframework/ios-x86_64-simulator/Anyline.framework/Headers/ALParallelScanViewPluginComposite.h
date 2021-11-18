//
//  ALParallelScanViewPluginComposite.h
//  Anyline
//
//  Created by Angela Brett on 13.11.19.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#import "ALAbstractScanViewPluginComposite.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALParallelScanViewPluginComposite : ALAbstractScanViewPluginComposite

@property (nonatomic, retain, null_unspecified) NSNumber *optionalTimeoutDelay;

@end

NS_ASSUME_NONNULL_END
