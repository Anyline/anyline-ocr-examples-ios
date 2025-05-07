#ifndef ALImageProviding_h
#define ALImageProviding_h

NS_ASSUME_NONNULL_BEGIN

@class ALImage;

typedef void (^NewImageBlock)(ALImage * _Nullable image, UIInterfaceOrientation orientation, BOOL isFrontCamera);

@protocol ALImageProviding

- (id<NSObject> _Nonnull)subscribeToNewImages:(NewImageBlock _Nonnull)block;

- (void)unsubscribeFromNewImages:(id _Nonnull)subscriber;

@property (nonatomic, assign) BOOL shouldDropFrames;

@end

#endif /* ALImageProviding_h */

NS_ASSUME_NONNULL_END
