#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Request-body gzip compression for reporting/scan-event uploads (MSDK-1505).
///
/// Anyline Core signals intent by setting `Content-Encoding: gzip` on the upload
/// request; the actual compression happens on the platform because the body crosses
/// the language boundary as a UTF-8 string and cannot be compressed in Core. This is
/// the iOS counterpart of the Android `RequestCompression` util, factored out of
/// `ALNetworkImplementation` so the zlib round-trip can be unit-tested in isolation.
@interface ALRequestCompression : NSObject

/// gzip-compresses `input` (gzip framing: header + trailer, RFC 1952). Returns `nil`
/// on compression failure; returns `input` unchanged when it is empty.
+ (nullable NSData *)gzip:(NSData *)input;

@end

NS_ASSUME_NONNULL_END
