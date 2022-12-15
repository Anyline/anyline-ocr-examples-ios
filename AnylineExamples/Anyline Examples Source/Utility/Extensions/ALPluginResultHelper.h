#import <Foundation/Foundation.h>
#import <Anyline/Anyline.h> // needed?

NS_ASSUME_NONNULL_BEGIN

@class ALPluginResult;
@class ALResultEntry;

@interface ALBarcode (ALExtras)

- (NSString *)decoded;

@end


@protocol ALResultListEnumerable

@property (nonatomic, readonly) NSArray<ALResultEntry *> *resultEntryList;

@end


@interface ALMrzResult (ALExtras) <ALResultListEnumerable>
@end

@interface ALUniversalIDResult (ALExtras) <ALResultListEnumerable>
@end

@interface ALTinResult (ALExtras) <ALResultListEnumerable>
@end

@interface ALVehicleRegistrationCertificateResult (ALExtras) <ALResultListEnumerable>
@end

@interface ALCommercialTireIDResult (ALExtras) <ALResultListEnumerable>
@end

@interface ALTireSizeResult (ALExtras) <ALResultListEnumerable>
@end

@interface ALVinResult (ALExtras) <ALResultListEnumerable>
@end

@interface ALLicensePlateResult (ALExtras) <ALResultListEnumerable>
@end

@interface ALMeterResult (ALExtras) <ALResultListEnumerable>
@end

@interface ALBarcodeResult (ALExtras) <ALResultListEnumerable>
@end

@interface ALContainerResult (ALExtras) <ALResultListEnumerable>
@end

@interface ALOcrResult (ALExtras) <ALResultListEnumerable>
@end

// TODO: need to support these

//@interface ALJapaneseLandingPermissionResult (ALExtras) <ALResultListEnumerable>
//@end

NS_ASSUME_NONNULL_END
