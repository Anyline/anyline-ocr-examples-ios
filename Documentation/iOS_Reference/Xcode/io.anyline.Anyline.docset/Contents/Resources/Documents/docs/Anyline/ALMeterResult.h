//
//  ALMeterResult.h
//  Anyline
//
//  Created by Daniel Albertini on 21/03/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALScanResult.h"

typedef NS_ENUM(NSInteger, ALScanMode) {
    ALAnalogMeter,
    ALSerialNumber,
    ALDigitalMeter,
    ALHeatMeter4, ALHeatMeter5, ALHeatMeter6,
    ALAutoAnalogDigitalMeter,
    ALDialMeter,
    ALBarcode // This scanMode is ignored in the plugin and only used in the AnylineEnergyModuleView
};

/**
 *  The result object for the ALMeterScanPlugin
 */
@interface ALMeterResult : ALScanResult<NSString *>
/**
 * The used scanMode
 */
@property (nonatomic, assign, readonly) ALScanMode scanMode;

- (instancetype _Nullable)initWithResult:(NSString * _Nonnull)result
                                   image:(UIImage * _Nonnull)image
                               fullImage:(UIImage * _Nonnull)fullImage
                              confidence:(NSInteger)confidence
                                 outline:(ALSquare * _Nullable)outline
                                pluginID:(NSString *_Nonnull)pluginID
                                scanMode:(ALScanMode)scanMode;

@end

@interface ALEnergyResult : ALMeterResult

@end
