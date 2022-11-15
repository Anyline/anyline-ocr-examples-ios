//
//  ALMeterResult.h
//  Anyline
//
//  Created by Daniel Albertini on 21/03/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALScanResult.h"

/**
 Supported scan modes for the ALMeterScanPlugin.
 */
typedef NS_ENUM(NSInteger, ALScanMode) {
    ALAutoAnalogDigitalMeter,
    ALSerialNumber,
    ALHeatMeter4,
    ALHeatMeter5,
    ALHeatMeter6,
    ALDialMeter,
    ALDigitalMeter2Experimental, // Uses meter models optimized for a certain use case. This is not intended for public use.
    ALAnalogMeter, // deprecated as of 41, will be removed soon. Use ALAutoAnalogDigitalMeter instead.
    ALDigitalMeter, // deprecated as of 41, will be removed soon. Use ALAutoAnalogDigitalMeter instead.
    ALDotMatrixMeter, // deprecated as of 41, will be removed soon. Use ALAutoAnalogDigitalMeter instead.
    ALMeterBarcode, // This scanMode has since been removed and will lead to an error if set as the scan mode.
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
                                pluginID:(NSString *_Nonnull)pluginID
                                scanMode:(ALScanMode)scanMode;

@end

@interface ALEnergyResult : ALMeterResult

@end
