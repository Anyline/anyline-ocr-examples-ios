#ifndef ALNFCResult_h
#define ALNFCResult_h

NS_ASSUME_NONNULL_BEGIN

@class ALSOD;
@class ALDataGroup1;
@class ALDataGroup2;

/**
 * The result from reading a passport NFC chip, passed to the ALNFCDetectorDelegate method `-nfcSucceededWithResult:`
 *
 * - Note: NFC functionality requires iOS 13 or later.
 */
API_AVAILABLE(ios(13.0))
@interface ALNFCResult : NSObject

/**
 * The document security object. Currently this is always nil; this feature will be
 * available in a future version of the SDK.
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

/// Initializes an ALNFCResult with dataGroup1, dataGroup2, and SOD
/// @param dataGroup1 dataGroup1
/// @param dataGroup2 dataGroup2
/// @param sod sod
- (instancetype)initWithDataGroup1:(ALDataGroup1 *)dataGroup1
                        dataGroup2:(ALDataGroup2 *)dataGroup2
                               sod:(ALSOD * _Nullable)sod;

@end


/// Data group from an NFC scan result, containing textual and date information from the passport
@interface ALDataGroup1 : NSObject

/// Document type
@property (nonatomic, copy, nullable) NSString *documentType;

/// Issuing state code
@property (nonatomic, copy, nullable) NSString *issuingStateCode;

/// Document number
@property (nonatomic, copy, nullable) NSString *documentNumber;

/// Date of expiry
@property (nonatomic, strong, nullable) NSDate *dateOfExpiry;

/// Gender
@property (nonatomic, copy, nullable) NSString *gender;

/// Nationality
@property (nonatomic, copy, nullable) NSString *nationality;

/// Last name
@property (nonatomic, copy, nullable) NSString *lastName;

/// First name
@property (nonatomic, copy, nullable) NSString *firstName;

/// Date of birth
@property (nonatomic, strong, nullable) NSDate *dateOfBirth;

/// Initializes a data group with string / date information from a passport
///   @param documentType documentType
///   @param issuingStateCode issuingStateCode
///   @param documentNumber documentNumber
///   @param dateOfExpiry dateOfExpiry
///   @param gender gender
///   @param nationality nationality
///   @param lastName lastName
///   @param firstName firstName
///   @param dateOfBirth dateOfBirth
///   @return the ALDataGroup1 object
- (instancetype)initWithDocumentType:(NSString * _Nullable)documentType
                    issuingStateCode:(NSString * _Nullable)issuingStateCode
                      documentNumber:(NSString * _Nullable)documentNumber
                        dateOfExpiry:(NSDate * _Nullable)dateOfExpiry
                              gender:(NSString * _Nullable)gender
                         nationality:(NSString * _Nullable)nationality
                            lastName:(NSString * _Nullable)lastName
                           firstName:(NSString * _Nullable)firstName
                         dateOfBirth:(NSDate * _Nullable)dateOfBirth;

/// Initializes a data group with a dictionary of passport details
/// @param passportDataElements NSDictionary mapping fields to their values
/// @return the ALDataGroup1 object
- (instancetype)initWithPassportDataElements:(NSDictionary<NSString *,NSString *> *)passportDataElements;

@end


/// Data Group 2 of the data read from a passport NFC chip, containing the face image
@interface ALDataGroup2 : NSObject

/// The face image read from the passport's NFC chip
@property (nonatomic, strong, nullable) UIImage *faceImage;

/// Initializes a data group with string / date information from a passport
/// @param faceImage faceImage
/// @return the ALDataGroup2 object
- (instancetype)initWithFaceImage:(UIImage * _Nullable)faceImage;

@end


/// Object containing additional metadata read from a passport NFC chip
@interface ALSOD : NSObject

/// Issuer country
@property NSString *issuerCountry;

/// Issuer certification authority
@property NSString *issuerCertificationAuthority;

/// Issuer organization
@property NSString *issuerOrganization;

/// Issuer organizational unit
@property NSString *issuerOrganizationalUnit;

/// Signature algorithm
@property NSString *signatureAlgorithm;

/// LDS hash algorithm
@property NSString *ldsHashAlgorithm;

/// Valid from
@property NSString *validFromString;

/// Valid until
@property NSString *validUntilString;

@end

NS_ASSUME_NONNULL_END

#endif /* ALNFCResult_h */

