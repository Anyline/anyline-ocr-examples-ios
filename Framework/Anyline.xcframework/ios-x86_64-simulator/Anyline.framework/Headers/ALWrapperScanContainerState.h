//
//  ALWrapperScanContainerState.h
//  Anyline
//
//  Created by Igor on 29.07.25.
//

#import <Foundation/Foundation.h>
#import "../ALWrapperSessionParameters.h"

@class ALWrapperScanContainer;
@class ALWrapperSessionScanResponse;
@class ALWrapperSessionScanResultsResponse;
@class ALUIFeedbackElementConfig;
@class ALExportedScanResult;
@class ALWrapperSessionScanResponseStatus;
@class ALWrapperScanContainerStateLoading;
@class ALWrapperScanContainerStateScanning;
@class ALWrapperScanContainerStateFinished;

NS_ASSUME_NONNULL_BEGIN

/**
 * Base class for wrapper scan container states.
 */
@interface ALWrapperScanContainerState : NSObject

@property (nonatomic, strong, readonly) ALWrapperScanContainer *wrapperScanContainer;

- (instancetype)initWithWrapperScanContainer:(nonnull ALWrapperScanContainer *)wrapperScanContainer;

@end

/**
 * State when the scan container is not loaded.
 */
@interface ALWrapperScanContainerStateNotLoaded : ALWrapperScanContainerState

- (ALWrapperScanContainerStateLoading *)load;

@end

/**
 * State when the scan container is loading.
 */
@interface ALWrapperScanContainerStateLoading : ALWrapperScanContainerState

- (ALWrapperScanContainerStateScanning *)startWithScanViewConfig:(NSDictionary *)scanViewConfig;
- (ALWrapperScanContainerStateFinished *)cancelWithStatus:(ALWrapperSessionScanResponseStatus *)status
                                                   message:(NSString * _Nullable)message;

@end

/**
 * State when the scan container is actively scanning.
 */
@interface ALWrapperScanContainerStateScanning : ALWrapperScanContainerState

@property (nonatomic, strong, readonly) NSDictionary *scanViewConfig;
@property (nonatomic, strong, readonly) NSMutableArray<ALExportedScanResult *> *exportedScanResultList;

- (instancetype)initWithWrapperScanContainer:(ALWrapperScanContainer *)wrapperScanContainer
                              scanViewConfig:(NSDictionary *)scanViewConfig;

- (BOOL)isCompleted;

- (void)onResults:(nonnull NSArray *)scanResults error:(NSError **)error;

- (void)onUIElementClicked:(nonnull ALUIFeedbackElementConfig *)uiFeedbackElementConfig;

- (ALWrapperScanContainerStateFinished *)stopWithStatus:(nonnull ALWrapperSessionScanResponseStatus *)status
                                                 message:(NSString * _Nullable)message;

@end

/**
 * State when the scan container has finished.
 */
@interface ALWrapperScanContainerStateFinished : ALWrapperScanContainerState

@property (nonatomic, strong, readonly) NSArray<ALExportedScanResult *> *exportedScanResultList;

- (instancetype)initWithWrapperScanContainer:(nonnull ALWrapperScanContainer *)wrapperScanContainer
                       exportedScanResultList:(nonnull NSArray<ALExportedScanResult *> *)exportedScanResultList;

- (void)dispose;

@end

NS_ASSUME_NONNULL_END 
