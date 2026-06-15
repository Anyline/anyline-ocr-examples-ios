#ifndef ALImageProviding_h
#define ALImageProviding_h

NS_ASSUME_NONNULL_BEGIN

@class ALImage;

typedef void (^NewImageBlock)(ALImage * _Nullable image, UIInterfaceOrientation orientation, BOOL isLeftRightFlipped, BOOL isTopBottomFlipped);

@protocol ALImageProviding

- (id<NSObject> _Nonnull)subscribeToNewImages:(NewImageBlock _Nonnull)block;

- (void)unsubscribeFromNewImages:(id _Nonnull)subscriber;

@property (nonatomic, assign) BOOL shouldDropFrames;

/// Indicates whether frames should be processed synchronously. Defaults to YES.
@property (nonatomic, assign) BOOL shouldProcessFramesSynchronized;

@end

#endif /* ALImageProviding_h */

NS_ASSUME_NONNULL_END
