#ifndef ALScanViewPlugin_Private_h
#define ALScanViewPlugin_Private_h

@class ALScanPlugin;
@protocol ALDateProvider;
@protocol ALEventProviding;
@protocol ALImageProviding;

NS_ASSUME_NONNULL_BEGIN

@interface ALScanViewPlugin ()

// NOTE: if scanPlugin is provided (typically a mock), then a scan plugin won't be created
// using the config.
- (instancetype _Nullable)initWithConfig:(ALViewPluginConfig * _Nonnull)scanViewPluginConfig
                              scanPlugin:(ALScanPlugin * _Nullable)scanPlugin
                            dateProvider:(id<ALDateProvider> _Nullable)dateProvider
                                   error:(NSError * _Nullable * _Nullable)error;


- (instancetype _Nullable)initWithJSONDictionary:(NSDictionary * _Nonnull)JSONDictionary
                                      scanPlugin:(ALScanPlugin * _Nullable)scanPlugin
                                    dateProvider:(id<ALDateProvider> _Nullable)dateProvider
                                           error:(NSError * _Nullable * _Nullable)error;

// ACO: Windows uses Interlocked class to ensure atomic operations
// on these properties.
// making them accessible to private headers
@property (atomic, assign) NSInteger elapsedTime;

@property (atomic, assign) NSInteger lastTime;

/// The object delivering the image frames for the scanning process
@property (nonatomic, strong) id<ALImageProviding> imageProvider;

@property (nonatomic, readwrite) id<ALEventProviding> visualFeedbackReceived; // <ALGeometry>

@property (nonatomic, readwrite) id<ALEventProviding> resultBeepTriggered;

@property (nonatomic, readwrite) id<ALEventProviding> resultBlinkTriggered;

@property (nonatomic, readwrite) id<ALEventProviding> resultVibrateTriggered;

@property (nonatomic, readwrite) id<ALEventProviding> brightnessUpdated; // <int>

@property (nonatomic, readwrite) id<ALEventProviding> cutoutVisibilityChanged; // List<string>

@property (nonatomic, readwrite) id<ALEventProviding> scanInfoReceived;

@end


@protocol ALDateProvider

@property (nonatomic, readonly) NSTimeInterval theTimeIntervalNow;

- (void)resetTimes;

@end

NS_ASSUME_NONNULL_END

#endif /* ALScanViewPlugin_Private_h */
