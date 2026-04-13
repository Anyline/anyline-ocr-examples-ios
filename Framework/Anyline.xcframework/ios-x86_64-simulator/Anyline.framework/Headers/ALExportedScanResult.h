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

/// Image format used when exporting scan result images.
@interface ALExportedScanResultImageFormat : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (ALExportedScanResultImageFormat *)jpg;
+ (ALExportedScanResultImageFormat *)png;
@end

#pragma mark - Object interfaces

/// A single scan result exported from the Anyline SDK, containing the plugin-specific result
/// data together with the associated scan images.
@interface ALExportedScanResult : NSObject
/// Specifies how and where the scan result images are delivered.
@property (nonatomic, strong) ALExportedScanResultImageContainer *imageContainer;
/// Output format and quality settings applied to all images exported with this scan result.
@property (nonatomic, strong) ALExportedScanResultImageParameters *imageParameters;
/// See ALPluginResult.h
@property (nonatomic, copy) NSDictionary<NSString *, id> *pluginResult;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

/// Specifies how and where the scan result images are delivered.
///
/// Specifies how and where scan result images are delivered. Use saved to store images to
/// disk, or encoded to receive them as base64 strings in the result.
@interface ALExportedScanResultImageContainer : NSObject
/// Deliver images as base64-encoded strings embedded in the result JSON.
@property (nonatomic, nullable, strong) ALExportedScanResultImageContainerEncoded *encoded;
/// Deliver images as files saved to the specified directory path.
@property (nonatomic, nullable, strong) ALExportedScanResultImageContainerSaved *saved;
@end

/// Deliver images as base64-encoded strings embedded in the result JSON.
///
/// Image container that encodes scan result images as base64 strings in the result JSON.
@interface ALExportedScanResultImageContainerEncoded : NSObject
/// The base64-encoded image data for each image type.
@property (nonatomic, strong) ALExportedScanResultImages *images;
@end

/// The base64-encoded image data for each image type.
///
/// References to the images captured during scanning. Each field is a file path (saved
/// container) or base64 string (encoded container). Fields are only populated for image
/// types the active plugin produces.
///
/// The image filenames saved in the specified path.
@interface ALExportedScanResultImages : NSObject
/// The cropped cutout image corresponding to the scanned region.
@property (nonatomic, nullable, copy) NSString *cutoutImage;
/// The face image extracted from the scanned document, if available.
@property (nonatomic, nullable, copy) NSString *faceImage;
/// The full frame image captured at the moment of the scan result.
@property (nonatomic, nullable, copy) NSString *image;
@end

/// Deliver images as files saved to the specified directory path.
///
/// Image container that saves scan result images to a local file path.
@interface ALExportedScanResultImageContainerSaved : NSObject
/// The image filenames saved in the specified path.
@property (nonatomic, strong) ALExportedScanResultImages *images;
/// Directory path where scan result images are saved.
@property (nonatomic, copy) NSString *path;
@end

/// Output format and quality settings applied to all images exported with this scan result.
@interface ALExportedScanResultImageParameters : NSObject
/// Image format used when exporting scan result images.
@property (nonatomic, nullable, assign) ALExportedScanResultImageFormat *format;
/// Compression quality for exported images, from 1 (lowest) to 100 (highest).
@property (nonatomic, nullable, strong) NSNumber *quality;
@end

NS_ASSUME_NONNULL_END
