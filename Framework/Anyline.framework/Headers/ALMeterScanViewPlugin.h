//
//  ALMeterScanViewPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 19/09/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALAbstractScanViewPlugin.h"
#import "ALMeterResult.h"
#import "ALMeterScanPlugin.h"
#import "ALBarcodeScanPlugin.h"

@interface ALMeterScanViewPlugin : ALAbstractScanViewPlugin

@property (nullable, nonatomic, strong) ALMeterScanPlugin *meterScanPlugin;

- (_Nullable instancetype)initWithFrame:(CGRect)frame scanPlugin:(ALMeterScanPlugin *_Nonnull)meterScanPlugin;

/**
 *  Sets the scan mode.
 *  It has to be ALElectricMeter, ALGasMeter, ALBarcode or ALSerialNumber
 *
 */
@property (nonatomic, assign, readonly) ALScanMode scanMode;

/**
 *  Sets the scan mode and returns an NSError if something failed.
 *
 *  @param scanMode The scan mode to set.
 *  @param error The error if something goes wrong. Can be nil.
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setScanMode:(ALScanMode)scanMode error:(NSError * _Nullable * _Nullable)error;

@end
