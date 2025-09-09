//
//  ALWrapperSessionClientDelegate.h
//  Anyline
//
//  Created by Igor on 29.07.25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Delegate protocol for handling wrapper session client callbacks.
 */
@protocol ALWrapperSessionClientDelegate <NSObject>


/**
 * Called when a new ViewController will be presented.
 * @returns the top UIViewController that should present the requested ViewController or null to use the default ViewController.
 */
- (nullable UIViewController *)getTopViewController;

/**
 * Called when SDK initialization response is received.
 * @param initializationResponse The SDK initialization response containing success/failure information.
 */
- (void)onSdkInitializationResponse:(nonnull ALWrapperSessionSDKInitializationResponse *)initializationResponse;

/**
 * Called when scan results are received.
 * @param scanResultsResponse The scan results response containing exported scan results and configuration.
 */
- (void)onScanResults:(nonnull ALWrapperSessionScanResultsResponse *)scanResultsResponse;

/**
 * Called when a UI element is clicked during scanning.
 * @param scanResultConfig The scan result configuration associated with the click.
 * @param uiFeedbackElementConfig The UI feedback element configuration that was clicked.
 */
- (void)onUIElementClicked:(nonnull ALWrapperSessionScanResultConfig *)scanResultConfig
      uiFeedbackElementConfig:(nonnull ALUIFeedbackElementConfig *)uiFeedbackElementConfig;

/**
 * Called when a scan response is received.
 * @param scanResponse The scan response containing status and result information.
 */
- (void)onScanResponse:(nonnull ALWrapperSessionScanResponse *)scanResponse;

/**
 * Called when a UCR (User Corrected Result) report response is received.
 * @param ucrReportResponse The UCR report response containing success/failure information.
 */
- (void)onUCRReportResponse:(nonnull ALWrapperSessionUCRReportResponse *)ucrReportResponse;

/**
 * Called when cached events export response is received.
 * @param exportCachedEventsResponse The cached events export response containing success/failure information.
 */
- (void)onExportCachedEventsResponse:(nonnull ALWrapperSessionExportCachedEventsResponse *)exportCachedEventsResponse;

@end

NS_ASSUME_NONNULL_END

