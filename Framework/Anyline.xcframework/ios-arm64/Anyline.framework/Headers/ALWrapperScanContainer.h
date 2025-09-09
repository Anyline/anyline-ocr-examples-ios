//
//  ALWrapperScanContainer.h
//  Anyline
//
//  Created by Igor on 29.07.25.
//

#import <Foundation/Foundation.h>
#import "../ALWrapperSessionParameters.h"
#import "ALWrapperScanContainerObservableModel.h"

@protocol ALWrapperSessionClientDelegate;
@class ALWrapperScanContainerState;
@class ALWrapperSessionScanStartRequest;

@class ALWrapperSessionScanResultConfig;
@class ALExportedScanResultImageContainer;
@class ALExportedScanResultImageParameters;
@class ALWrapperSessionScanResultCleanStrategyConfig;

NS_ASSUME_NONNULL_BEGIN

/**
 * Container class that manages the scanning session lifecycle and state.
 */
@interface ALWrapperScanContainer : NSObject

@property (nonatomic, weak) id<ALWrapperSessionClientDelegate> wrapperSessionClient;
@property (nonatomic, strong) ALWrapperSessionScanStartRequest *wrapperSessionScanStartRequest;
@property (nonatomic, strong) ALWrapperSessionScanResultConfig *wrapperSessionScanResultConfig;
@property (nonatomic, nonnull, strong) ALExportedScanResultImageContainer *imageContainer;
@property (nonatomic, nonnull, strong) ALExportedScanResultImageParameters *imageParameters;
@property (nonatomic, nonnull, strong) ALWrapperSessionScanResultCleanStrategyConfig *cleanStrategy;
@property (nonatomic, nonnull, strong) ALWrapperScanContainerState *state;

@property (nonatomic, strong) ALWrapperScanContainerObservableModel *observableRequest;

- (instancetype)initWithWrapperSessionScanStartRequest:(nonnull ALWrapperSessionScanStartRequest *)wrapperSessionScanStartRequest
           wrapperSessionClient:(nonnull id<ALWrapperSessionClientDelegate>)wrapperSessionClient;

- (void)requestStop:(ALWrapperSessionScanStopRequest * _Nullable)scanStopRequestParams;

- (void)requestReplaceScanStartRequestParams:(nonnull ALWrapperSessionScanStartRequest *)scanStartRequestParams;

- (void)requestReplaceScanViewConfigContentString:(nonnull NSString *)scanViewConfigContentString;

@end

NS_ASSUME_NONNULL_END 
