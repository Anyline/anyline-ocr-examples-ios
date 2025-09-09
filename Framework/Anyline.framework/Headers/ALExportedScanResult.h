// To parse this JSON:
//
//   NSError *error;
//   ALExportedScanResult *exportedScanResult = [ALExportedScanResult fromJSON:json encoding:NSUTF8Encoding error:&error];

#import <Foundation/Foundation.h>

@class ALExportedScanResult;
@class ALExportedScanResultImageContainer;
@class ALExportedScanResultImageContainerEncoded;
@class ALExportedScanResultImageContainerSaved;
@class ALExportedScanResultImageFormat;
@class ALExportedScanResultImageParameters;
@class ALExportedScanResultImages;
@class ALPluginResult;

NS_ASSUME_NONNULL_BEGIN


#pragma mark - Boxed enums

/// Sets the format of exported images.
@interface ALExportedScanResultImageFormat : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALExportedScanResultImageFormat *)jpg;
+ (ALExportedScanResultImageFormat *)png;
@end

#pragma mark - Object interfaces

/// Schema for Exported ScanResult
@interface ALExportedScanResult : NSObject
@property (nonatomic, strong) ALExportedScanResultImageContainer *imageContainer;
@property (nonatomic, strong) ALExportedScanResultImageParameters *imageParameters;
/// See ALPluginResult.h
@property (nonatomic, copy) NSDictionary<NSString *, id> *pluginResult;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

/// Sets the container of exported images.
@interface ALExportedScanResultImageContainer : NSObject
@property (nonatomic, nullable, strong) ALExportedScanResultImageContainerEncoded *encoded;
@property (nonatomic, nullable, strong) ALExportedScanResultImageContainerSaved *saved;
@end

/// Sets the json as container of exported images.
@interface ALExportedScanResultImageContainerEncoded : NSObject
@property (nonatomic, strong) ALExportedScanResultImages *images;
@end

/// Configuration for Exported ScanResult Images
@interface ALExportedScanResultImages : NSObject
/// The source of cutout image as specified in the container.
@property (nonatomic, nullable, copy) NSString *cutoutImage;
/// The source of face image as specified in the container.
@property (nonatomic, nullable, copy) NSString *faceImage;
/// The source of full frame image as specified in the container.
@property (nonatomic, nullable, copy) NSString *image;
@end

/// Sets the storage as container of exported images.
@interface ALExportedScanResultImageContainerSaved : NSObject
@property (nonatomic, strong) ALExportedScanResultImages *images;
/// Sets the path the images are saved into.
@property (nonatomic, copy) NSString *path;
@end

/// Configuration for Exported ScanResult Image Parameters
@interface ALExportedScanResultImageParameters : NSObject
/// Sets the format of exported images.
@property (nonatomic, nullable, assign) ALExportedScanResultImageFormat *format;
/// Sets the quality value between 1 and 100 of exported images.
@property (nonatomic, nullable, strong) NSNumber *quality;
@end

NS_ASSUME_NONNULL_END
