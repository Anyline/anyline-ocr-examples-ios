#import <Foundation/Foundation.h>
#import "ALWrapperSessionParameters.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALWrapperSessionScanResultCleanStrategyConfig (Extras)
+ (ALWrapperSessionScanResultCleanStrategyConfig *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALFillType (Extras)
+ (ALFillType *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALPositionXAlignment (Extras)
+ (ALPositionXAlignment *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALPositionYAlignment (Extras)
+ (ALPositionYAlignment *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionExportCachedEventsResponse (Extras)
+ (ALWrapperSessionExportCachedEventsResponse *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionExportCachedEventsResponseFail (Extras)
+ (ALWrapperSessionExportCachedEventsResponseFail *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionExportCachedEventsResponseStatus (Extras)
+ (ALWrapperSessionExportCachedEventsResponseStatus *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionExportCachedEventsResponseSucceed (Extras)
+ (ALWrapperSessionExportCachedEventsResponseSucceed *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanResponse (Extras)
+ (ALWrapperSessionScanResponse *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanResponseAbort (Extras)
+ (ALWrapperSessionScanResponseAbort *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanResponseFail (Extras)
+ (ALWrapperSessionScanResponseFail *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanResponseSucceed (Extras)
+ (ALWrapperSessionScanResponseSucceed *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanResponseStatus (Extras)
+ (ALWrapperSessionScanResponseStatus *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanResultCallbackConfig (Extras)
+ (ALWrapperSessionScanResultCallbackConfig *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanResultConfig (Extras)
+ (ALWrapperSessionScanResultConfig *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanResultsResponse (Extras)
+ (ALWrapperSessionScanResultsResponse *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanStartRequest (Extras)
+ (ALWrapperSessionScanStartRequest *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanStopRequest (Extras)
+ (ALWrapperSessionScanStopRequest *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanViewConfigOptionDefaultOrientation (Extras)
+ (ALWrapperSessionScanViewConfigOptionDefaultOrientation *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanViewConfigOptionDoneButton (Extras)
+ (ALWrapperSessionScanViewConfigOptionDoneButton *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanViewConfigOptionElementAlignment (Extras)
+ (ALWrapperSessionScanViewConfigOptionElementAlignment *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanViewConfigOptionElementOffset (Extras)
+ (ALWrapperSessionScanViewConfigOptionElementOffset *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanViewConfigOptionLabel (Extras)
+ (ALWrapperSessionScanViewConfigOptionLabel *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanViewConfigOptionRotateButton (Extras)
+ (ALWrapperSessionScanViewConfigOptionRotateButton *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanViewConfigOptions (Extras)
+ (ALWrapperSessionScanViewConfigOptions *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionScanViewConfigOptionSegmentConfig (Extras)
+ (ALWrapperSessionScanViewConfigOptionSegmentConfig *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionSDKInitializationCacheConfig (Extras)
+ (ALWrapperSessionSDKInitializationCacheConfig *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionSDKInitializationRequest (Extras)
+ (ALWrapperSessionSDKInitializationRequest *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionSDKInitializationResponse (Extras)
+ (ALWrapperSessionSDKInitializationResponse *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionSDKInitializationResponseInitialized (Extras)
+ (ALWrapperSessionSDKInitializationResponseInitialized *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionSDKInitializationResponseNotInitialized (Extras)
+ (ALWrapperSessionSDKInitializationResponseNotInitialized *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionUCRReportRequest (Extras)
+ (ALWrapperSessionUCRReportRequest *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionUCRReportResponse (Extras)
+ (ALWrapperSessionUCRReportResponse *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionUCRReportResponseFail (Extras)
+ (ALWrapperSessionUCRReportResponseFail *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionUCRReportResponseStatus (Extras)
+ (ALWrapperSessionUCRReportResponseStatus *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

@interface ALWrapperSessionUCRReportResponseSucceed (Extras)
+ (ALWrapperSessionUCRReportResponseSucceed *)fromJSONDictionary:(NSDictionary *)jsonConfig;
- (NSDictionary *)toJSONDictionary;
@end

NS_ASSUME_NONNULL_END
