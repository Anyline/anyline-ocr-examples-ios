#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Methods to convert an object to a JSON string
@protocol ALJSONStringRepresentable <NSObject>

/// Converts the object to a JSON string.
/// @param isPretty set to true if the output string should be optimized for human-readability
/// @param error would be set if conversion to a JSON string fails
/// @return the JSON string
- (NSString * _Nullable)toJSONStringPretty:(BOOL)isPretty error:(NSError **)error;

/// Converts the object to a JSON string.
/// @param error would be set if conversion to a JSON string fails
/// @return the JSON string
- (NSString * _Nullable)toJSONString:(NSError **)error;

/// Converts the object to a JSON string.
/// @param isPretty set to true if the output string should be optimized for human-readability
/// @return the JSON string
- (NSString *)asJSONStringPretty:(BOOL)isPretty;

/// Converts the object to a JSON string. This could fail and return a null; the result is not prettified
/// @return the JSON string
- (NSString *)asJSONString;

@end

/// Methods to convert an NSData to a valid JSON object (dictionary or array)
@interface NSData (ALJSONExtras)

/// Returns a JSON object (could be an `NSDictionary` or an `NSArray`) converted from the `NSData`
/// object, or null, if conversion is not possible. In this case the `error` param passed will be
/// populated.
///
/// @param error `NSError` object that is set when the JSON conversion encountered errors
/// @return the JSON object, or null
- (id _Nullable)toJSONObject:(NSError * _Nullable * _Nullable)error;

/// Returns a JSON object (could be an `NSDictionary` or an `NSArray`) converted from the `NSData`
/// object, or null, if conversion is not possible. No error value is set in this version.
/// @return the JSON object
- (id _Nullable)asJSONObject;

@end

/// Methods to convert an NSString to a valid JSON object (dictionary or array)
@interface NSString (ALJSONExtras)

/// Returns a JSON object (could be an `NSDictionary` or an `NSArray`) converted from the `NSData`
/// object, or null, if conversion is not possible. In this case the `error` param passed will be
/// populated.
///
/// @param error `NSError` object that is set when the JSON conversion encountered errors
/// @return the JSON object, or null
- (id _Nullable)toJSONObject:(NSError * _Nullable * _Nullable)error;

/// Returns a JSON object (could be an `NSDictionary` or an `NSArray`) converted from the `NSData`
/// object, or null, if conversion is not possible. No error value is set in this version.
/// @return the JSON object
- (id _Nullable)asJSONObject;

@end


/// This extends `NSDictionary` to the type `ALJSONStringRepresentable`, making it possible
/// to obtain a JSON string as output
@interface NSDictionary (ALJSONExtras) <ALJSONStringRepresentable>

@end

/// This extends `NSArray` to the type `ALJSONStringRepresentable`, making it possible
/// to obtain a JSON string as output
@interface NSArray (ALJSONExtras) <ALJSONStringRepresentable>

@end

NS_ASSUME_NONNULL_END
