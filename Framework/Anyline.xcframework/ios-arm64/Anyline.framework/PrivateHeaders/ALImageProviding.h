#ifndef ALImageProviding_h
#define ALImageProviding_h

NS_ASSUME_NONNULL_BEGIN

@class ALImage;

typedef void (^NewImageBlock)(ALImage * _Nullable image, UIInterfaceOrientation orientation, BOOL isFrontCamera);

@protocol ALImageProviding

- (id<NSObject> _Nonnull)subscribeToNewImages:(NewImageBlock _Nonnull)block;

- (void)unsubscribeFromNewImages:(id _Nonnull)subscriber;

/// Control whether the next captured frame is passed to AnylineCore's image processor in a new run loop.
/// When processing needs to stop this needs to be called with the parameter set to NO.
/// - Parameter allow: boolean indicating whether the frame is passed to AnylineCore.
- (void)allowNextFrameProcessing:(BOOL)allow;

@end

#endif /* ALImageProviding_h */

NS_ASSUME_NONNULL_END
