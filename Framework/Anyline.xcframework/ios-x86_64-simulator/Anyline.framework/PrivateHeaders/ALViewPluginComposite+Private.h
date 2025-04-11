#ifndef ALViewPluginComposite_Private_h
#define ALViewPluginComposite_Private_h

@protocol ALEventProviding;
@protocol ALImageProviding;

@interface ALViewPluginComposite ()

@property (nonatomic) id<ALEventProviding> allResultsReceived;

@property (nonatomic) id<ALEventProviding> errorFound;

/// The object providing the image to the composite
@property (nonatomic, strong) id<ALImageProviding> imageProvider;

// ACO - temporary
@property (nonatomic, strong) id<ALEventProviding> acoImageProcessed;

@property (nonatomic, readwrite) id<ALEventProviding> visualFeedbackReceived;

@property (nonatomic, readwrite) id<ALEventProviding> resultBeepTriggered;

@property (nonatomic, readwrite) id<ALEventProviding> resultBlinkTriggered;

@property (nonatomic, readwrite) id<ALEventProviding> brightnessUpdated;

@property (nonatomic, readwrite) id<ALEventProviding> cutoutVisibilityChanged;

@property (nonatomic, readwrite) id<ALEventProviding> resultVibrateTriggered; // not in Windows

@property (nonatomic, readwrite) id<ALEventProviding> scanInfoReceived;

@end

#endif /* ALViewPluginComposite_Private_h */
