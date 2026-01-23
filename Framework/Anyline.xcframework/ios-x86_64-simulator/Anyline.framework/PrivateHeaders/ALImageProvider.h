#import <Foundation/Foundation.h>
#import "ALImage.h"
#import "ALImageProviding.h"
#import "ALCaptureDeviceManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AnylineVideoDataSampleBufferDelegate;

// the base class for image providers. NSNotificationCenter injectable.
@interface ALImageProvider : NSObject<ALImageProviding, AnylineVideoDataSampleBufferDelegate>

@property (nonatomic, strong) dispatch_queue_t videoQueue;

@property (nonatomic, assign) BOOL shouldDropFrames;

/// Indicates whether frames should be processed synchronously. Defaults to YES.
@property (nonatomic, assign) BOOL shouldProcessFramesSynchronized;

@end

NS_ASSUME_NONNULL_END
