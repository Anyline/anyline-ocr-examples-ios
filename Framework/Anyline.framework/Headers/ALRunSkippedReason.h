//
//  ALRunSkippedReason.h
//  Anyline
//
//  Created by Daniel Albertini on 29/05/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The possible run error codes for this module.
 *  You can listen to the error codes for each run via the delegate method anylineOCRModuleView:reportsRunFailure:
 */
typedef NS_ENUM(NSInteger, ALRunFailure) {
    /**
     *  An unknown error occurred.
     */
    ALRunFailureUnknown                  = -1,
    /**
     *  @deprecated use ALRunFailureUnknown instead
     */
    ALRunFailureUnkown API_DEPRECATED_WITH_REPLACEMENT("ALRunFailureUnknown",ios(9.0, 10.0)) = ALRunFailureUnknown, 
    /**
     *  No text lines found in imag
     */
    ALRunFailureNoLinesFound            = -2,
    /**
     *  No text found in lines
     */
    ALRunFailureNoTextFound             = -3,
    /**
     *  The required min confidence is not reached for this run
     */
    ALRunFailureConfidenceNotReached    = -4,
    /**
     *  The result does not match the validation regular expression
     */
    ALRunFailureResultNotValid          = -5,
    /**
     *  The min sharpness for this run is not reached
     */
    ALRunFailureSharpnessNotReached     = -6,
    /**
     *  Backprojected points are outside of cutout
     */
    ALRunFailurePointsOutOfCutout       = -7,
    /**
     *  ID not recognised in universal ID
     */
    ALRunFailureIDTypeNotSupported       = -8
};

@interface ALRunSkippedReason : NSObject

/**
 The pluginID which created this RunSkippedReason
 */
@property (nonnull, nonatomic, strong, readonly) NSString *pluginID;

/**
 The reason of this RunFailure
 */
@property (nonatomic, assign) ALRunFailure reason;

- (instancetype _Nullable)initWithRunFailure:(ALRunFailure)reason
                                    pluginID:(NSString *_Nonnull)pluginID;

@end
