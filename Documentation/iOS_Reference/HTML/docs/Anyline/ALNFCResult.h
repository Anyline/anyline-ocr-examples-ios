//
//  ALNFCResult.h
//  Anyline
//
//  Created by Angela Brett on 07.10.19.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#ifndef ALNFCResult_h
#define ALNFCResult_h
#import "ALDataGroup1.h"
#import "ALDataGroup2.h"
#import "ALSOD.h"

/**
 * The result from reading a passport NFC chip, passed to the ALNFCDetectorDelegate method -nfcSucceededWithResult:
 *
 * - Note: NFC functionality requires iOS 13 or later.
 */
API_AVAILABLE(ios(13.0))
@interface ALNFCResult : NSObject

/**
 * The document security object. Currently this is always nil; this feature will be available in a future version of the SDK.
 */
@property ALSOD *sod;

/**
 * The first data group, containing textual and date information from the passport
 */
@property ALDataGroup1 *dataGroup1;

/**
* The second data group, containing the face image from the passport
*/
@property ALDataGroup2 *dataGroup2;

- (instancetype)initWithDataGroup1:(ALDataGroup1 *)dataGroup1 dataGroup2:(ALDataGroup2 *)dataGroup2 sod:(ALSOD *)sod;

@end

#endif /* ALNFCResult_h */
