//
//  NYReporting.h
//  Anyline
//
//  Created by Matthias Gasser on 22/07/14.
//  Copyright (c) 2014 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALScanResultState.h"

@class UIImage;

/**
 * The Anyline Reporting takes care of building the current scan rounds ALReportingModel, which
 * is then further processed / uploaded by the ALAzureService
 */
@interface ALReporting : NSObject

/**
 * Singleton accessor
 *
 * @return instance of ALReporting
 */
+ (instancetype) sharedInstance;

/** 
 * Reporting ON / OFF Switch
 * 
 * @param enable YES if reporting shall be enabled, NO otherwise
 */
+ (void) enableReporting:(BOOL)enable;

/**
 * Call when the next Image is being processed by anyline
 */
-(void) nextRound;

/**
 * Call when the User did focus on target event, with current image
 *
 * @param image the image the user did focus too
 */
-(void) userDidFocusOnTarget:(UIImage*) image;

/**
 * Call when the found result did or did not validate by the delegate
 *
 * @param didValidate Set YES if the result validates, NO otherwise
 # @param result the scan result object from anyline which did or did not validate
 */
-(void) resultDidValidate:(BOOL)didValidate withResult:(id)result;

/**
 * Call when the user did finish the scan either successfully or not.
 * The result will be reported.
 * 
 * @param the @ALScanResultState of the scan result state
 */
-(void) reportScanResultState:(ALScanResultState)scanResultState;

@end
