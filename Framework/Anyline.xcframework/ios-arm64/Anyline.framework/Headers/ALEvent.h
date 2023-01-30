#import <Foundation/Foundation.h>
#import "ALScanResult.h"

NS_ASSUME_NONNULL_BEGIN

@class ALImage;

/// An object representing an event inside Anyline SDK, with information inside
@interface ALEvent: NSObject

/// Image associated with the event (usually from a scan)
@property (nonatomic, readonly, nullable) ALImage *image;

/// JSON representation of the event
@property (nonatomic, readonly, nullable) id JSONObject;

/// Event channel
@property (nonatomic, copy, nullable) NSString *channel;

/// Timestamp of an event
@property (nonatomic, readonly) NSDate *timestamp;

/// JSON string representation of the event
@property (nonatomic, readonly, nullable) NSString *JSONStr;

/// Create an ALEvent object
/// @param JSONObj JSON representation of an event
/// @param image image associated with an event
/// @param error an NSError object providing error details with an event
+ (ALEvent * _Nullable)withJSONObject:(id)JSONObj
                                image:(ALImage * _Nullable)image
                                error:(NSError * _Nullable * _Nullable)error;

/// Create an ALEvent object
/// @param JSONObj JSON representation of an event
/// @param image image associated with an event
+ (ALEvent * _Nullable)withJSONObject:(id)JSONObj image:(ALImage * _Nullable)image;

/// Create an ALEvent object
/// @param JSONObj JSON representation of an event
/// @param error an NSError object providing error details with an event
+ (ALEvent * _Nullable)withJSONObject:(id)JSONObj error:(NSError * _Nullable * _Nullable)error;

/// Create an ALEvent object
/// @param JSONObj JSON representation of an event
+ (ALEvent * _Nullable)withJSONObject:(id)JSONObj;

/// Create an ALEvent object
/// @param JSONString JSON string representation of an event
/// @param image image associated with an event
/// @param error an NSError object providing error details with an event
+ (ALEvent *_Nullable)withJSONString:(NSString *)JSONString
                               image:(ALImage * _Nullable)image
                               error:(NSError * _Nullable * _Nullable)error;

/// Create an ALEvent object
/// @param JSONString JSON string representation of an event
/// @param error an NSError object providing error details with an event
+ (ALEvent * _Nullable)withJSONString:(NSString *)JSONString
                                error:(NSError * _Nullable * _Nullable)error;

/// Create an ALEvent object
/// @param JSONString JSON string representation of an event
/// @param image image associated with an event
+ (ALEvent * _Nullable)withJSONString:(NSString *)JSONString
                                image:(ALImage * _Nullable)image;

/// Create an ALEvent object
/// @param JSONString JSON string representation of an event
+ (ALEvent * _Nullable)withJSONString:(NSString *)JSONString;

@end


/// Type of event that allows inclusion of multiple images
@interface ALMultiImageEvent: ALEvent

/// Images associated with an event
@property (nonatomic, strong) NSArray<ALImage *> *images;

/// Create an `ALMultiImageEvent`
/// @param JSONObj JSON object representation of an event
/// @param images an array of images associated with an event
/// @param error error information concerning an event
+ (ALMultiImageEvent * _Nullable)withJSONObject:(id)JSONObj
                                         images:(NSArray<ALImage *> *)images
                                          error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
