#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALCacheUtils : NSObject

/// Exports the scan report files in the application sandbox as a zip archive.
/// - Parameter directory: source directory to include in the archive
/// - Parameter zipFileURL: the url to the zip file that is to be exported
/// - Parameter error: if provided, can supply the reason for any errors that occurred.
+ (NSString * _Nullable)exportCachedEventsInDirectory:(NSString * _Nullable)directory
                                           zipFileURL:(NSURL * _Nullable)zipFileURL
                                                error:(NSError * _Nullable * _Nullable)error;

/// Exports the scan report files in the application sandbox as a zip archive.
/// - Parameter error: if provided, can supply the reason for any errors that occurred.
+ (NSString * _Nullable)exportCachedEvents:(NSError * _Nullable * _Nullable)error;

+ (void)deleteReportArchives;

+ (NSURL * _Nullable)getRandomZipFileURL;

+ (NSString *)eventsLogFolder;

+ (NSString * _Nullable)checkStringOfHashmap:(NSDictionary<NSString *, NSString *> *)hashmap;

+ (BOOL)deleteAllEvents;

@end

NS_ASSUME_NONNULL_END
