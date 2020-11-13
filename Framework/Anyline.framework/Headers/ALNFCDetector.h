//
//  NFCDetector.h
//  Anyline
//
//  Created by Angela Brett on 12.09.19.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#ifndef NFCDetector_h
#define NFCDetector_h
#import "ALNFCResult.h"

API_AVAILABLE(ios(13.0))
@protocol ALNFCDetectorDelegate <NSObject>
@required
/**
*  Called when all data groups have been read from the NFC chip.
*
*  @param nfcResult The data read from the chip
*
*/
- (void)nfcSucceededWithResult:(ALNFCResult *_Nonnull)nfcResult;


/**
*  Called when there is an error reading the NFC chip
*
*  @param error The error encountered
*
*/
- (void)nfcFailedWithError:(NSError *_Nonnull)error;

@optional
/**
*  Called when the first data group, containing textual and date information, has been read from the NFC chip. Implement this if you want to show this data as soon as it is loaded instead of waiting for all data to be read.
*
*  @param dataGroup1 The dataGroup object
*
*/
- (void)nfcSucceededWithDataGroup1:(ALDataGroup1 *_Nonnull)dataGroup1 API_AVAILABLE(ios(13.0));

/**
*  Called when the second data group, containing the face image, has been read from the NFC chip. Implement this if you want to show this data as soon as it is loaded instead of waiting for all data to be read.
*
*  @param dataGroup2 The dataGroup object
*
*/
- (void)nfcSucceededWithDataGroup2:(ALDataGroup2 *_Nonnull)dataGroup2 API_AVAILABLE(ios(13.0));

/**
*  Called when the SOD (Document Security Object), has been read from the NFC chip. This feature will be available in a future version of the SDK.
*
*  @param sod The SOD object
*
*/
- (void)nfcSucceededWithSOD:(ALSOD *_Nonnull)sod API_AVAILABLE(ios(13.0));

@end

/**
 * The main class for reading NFC chips in passports.
 * - Note: NFC functionality requires iOS 13 or later.
 */
API_AVAILABLE(ios(13.0))
@interface ALNFCDetector : NSObject

/**
 @return whether this device is capable of reading passport NFC
 */
+ (BOOL)readingAvailable;

/**
 * Initialise the NFC Detector.
 *
 * @param licenseKey The Anyline license key for this application bundle
 * @param delegate The delegate to receive results from the NFC once -startNfcDetectionWithPassportNumber:dateOfBirth:expirationDate has been called. This must conform to the ALNFCDetectorDelegate protocol.
 */

- (instancetype _Nullable)initWithDelegate:(id <ALNFCDetectorDelegate> _Nonnull)delegate;

/**
 * Call this to start reading a passport NFC. This will automatically show UI telling the user to bring the phone near a passport, and informing them of the progress. Results will be given to the delegate via the ALNFCDetectorDelegate protocol methods. The parameters are needed to authenticate with the NFC chip; for security, the chip can not be read without some visible information from the passport.
 *
 * @param passportNumber the passport number of the passport, including a trailing < if there is one in the MRZ string
 * @param dateOfBirth the date of birth on the passport
 * @param expirationDate the expiration date of the passport
 */
- (void)startNfcDetectionWithPassportNumber:(NSString *_Nonnull)passportNumber dateOfBirth:(NSDate *_Nonnull)dateOfBirth expirationDate:(NSDate *_Nonnull)expirationDate;

@end

#endif /* NFCDetector_h */
