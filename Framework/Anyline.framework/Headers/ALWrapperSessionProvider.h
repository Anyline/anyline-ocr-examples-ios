//
//  ALWrapperSessionProvider.h
//  Anyline
//
//  Created by Igor on 29.07.25.
//

#import <Foundation/Foundation.h>
#import "ALWrapperConfig.h"

@class ALWrapperConfig;
@protocol ALWrapperSessionClientDelegate;
@class ALWrapperScanContainer;
@class ALWrapperSessionScanStartRequest;

@class ALWrapperSessionSDKInitializationRequest;
@class ALWrapperSessionSDKInitializationResponse;
@class ALWrapperSessionUCRReportRequest;
@class ALWrapperSessionScanResponse;
@class ALWrapperSessionScanResponseStatus;

NS_ASSUME_NONNULL_BEGIN

/**
 * Provider class that manages wrapper session operations including SDK initialization,
 * scan start/stop, and UCR reporting.
 */
@interface ALWrapperSessionProvider : NSObject

+ (ALWrapperConfig *)wrapperInfo;
+ (id<ALWrapperSessionClientDelegate>)wrapperSessionClient;
+ (ALWrapperSessionSDKInitializationRequest *)currentSdkInitializationRequestParams;
+ (ALWrapperScanContainer *)currentWrapperScanContainer;

/**
 * Setup the wrapper session with info and client delegate.
 */
+ (void)setupWrapperSessionWithWrapperInfo:(ALWrapperConfig *)wrapperInfo
                    wrapperSessionClient:(id<ALWrapperSessionClientDelegate>)wrapperSessionClient;

/**
 * Get the wrapper plugin version.
 */
+ (NSString *)getWrapperPluginVersion;

/**
 * Get the current SDK initialization response.
 */
+ (ALWrapperSessionSDKInitializationResponse *)getCurrentSdkInitializationResponse;

/**
 * Request SDK initialization with JSON string parameters.
 */
+ (void)requestSdkInitializationWithInitializationRequestParamsString:(NSString *)initializationRequestParamsString;

/**
 * Request SDK initialization with ALWrapperSessionSDKInitializationRequest.
 */
+ (void)requestSdkInitialization:(ALWrapperSessionSDKInitializationRequest *)initializationRequestParams;

/**
 * Request scan start with JSON string parameters.
 */
+ (void)requestScanStartWithScanStartRequestParamsString:(NSString *)scanStartRequestParamsString;

/**
 * Request scan start with ALWrapperSessionScanStartRequest.
 */
+ (void)requestScanStartWithWrapperSessionScanStartRequest:(ALWrapperSessionScanStartRequest *)wrapperSessionScanStartRequest;

/**
 * Request scan stop with optional JSON string parameters.
 */
+ (void)requestScanStopWithScanStopRequestParamsString:(NSString * _Nullable)scanStopRequestParamsString;

/**
 * Request scan stop with optional ALWrapperSessionScanStopRequest.
 */
+ (void)requestScanStop:(ALWrapperSessionScanStopRequest * _Nullable)scanStopRequestParams;

/**
 * Request scan switch with scan view config content string.
 */
+ (void)requestScanSwitchWithScanViewConfigContentString:(NSString *)scanViewConfigContentString;

/**
 * Request scan switch with new ALWrapperSessionScanStartRequest.
 */
+ (void)requestScanSwitchWithScanStartRequestParams:(ALWrapperSessionScanStartRequest *)newScanStartRequestParams;

/**
 * Request UCR report with JSON string parameters.
 */
+ (void)requestUCRReportWithWrapperSessionUCRReportRequestString:(NSString *)wrapperSessionUCRReportRequestString;

/**
 * Request UCR report with ALWrapperSessionUCRReportRequest.
 */
+ (void)requestUCRReport:(ALWrapperSessionUCRReportRequest *)wrapperSessionUCRReportRequest;

/**
 * Request export of cached events.
 */
+ (void)requestExportCachedEvents;

/**
 * Response scan with status and optional message.
 */
+ (void)responseScanWithStatus:(ALWrapperSessionScanResponseStatus *)status
                       message:(NSString * _Nullable)message;

@end

NS_ASSUME_NONNULL_END 
