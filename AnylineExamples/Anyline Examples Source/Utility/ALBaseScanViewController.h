#import <UIKit/UIKit.h>
#import "ScanHistory+CoreDataClass.h"
#import "ALWarningView.h"
#import <Anyline/Anyline.h>

NS_ASSUME_NONNULL_BEGIN

@class ALScanView;
@class ALScanPlugin;
@class ALResultEntry;

@protocol ALScanViewPluginBase;

@interface ALBaseScanViewController : UIViewController <ALScanViewDelegate>

@property (nonatomic, strong, nullable) ALScanView *scanView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) CFTimeInterval startTime;

@property (nonatomic) ALScanHistoryType controllerType;

@property (nullable, nonatomic, strong) UIButton *flipOrientationButton;

@property () BOOL isOrientationFlipped;

@property (nonatomic, readonly) BOOL isDarkMode;

- (void)setColors;

- (void)updateScanWarnings:(ALWarningState)warningState;

- (void)updateWarningPosition:(CGFloat)newPosition;

- (void)updateBrightness:(CGFloat)brightness forModule:(id)anylineModule ignoreTooDark:(BOOL)ignoreTooDark;

- (void)updateBrightness:(CGFloat)brightness forModule:(id)anylineModule;

- (NSString *)jsonStringFromResultData:(NSArray*)resultData;

- (void)anylineDidFindResult:(NSString * _Nullable)result
               barcodeResult:(NSString * _Nullable)barcodeResult
                       image:(UIImage * _Nullable)image
                  scanPlugin:(ALScanPlugin *)scanPlugin
                  viewPlugin:(id<ALScanViewPluginBase>)viewPlugin
                  completion:(void (^)(void))completion;

- (void)anylineDidFindResult:(NSString * _Nullable)result
               barcodeResult:(NSString * _Nullable)barcodeResult
                      images:(NSArray * _Nullable)images
                  scanPlugin:(ALScanPlugin *)scanPlugin
                  viewPlugin:(id<ALScanViewPluginBase>)viewPlugin
                  completion:(void (^)(void))completion;

- (void)anylineDidFindResult:(NSString * _Nullable)result
               barcodeResult:(NSString * _Nullable)barcodeResult
                   faceImage:(UIImage * _Nullable)faceImage
                      images:(NSArray * _Nullable)images
                  scanPlugin:(ALScanPlugin *)scanPlugin
                  viewPlugin:(id<ALScanViewPluginBase>)viewPlugin
                  completion:(void (^)(void))completion;

// - (void)startListeningForMotion;
// - (void)startPlugin:(ALAbstractScanViewPlugin *)plugin;

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message completion:(void (^ _Nullable)(void))completion;
- (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray <UIAlertAction *>*)actions;
- (void)showAlertForScanningError:(NSError * _Nonnull)error completion:(void (^ _Nullable)(void))completion dismissHandler:(void (^ _Nullable)(void))dismissHandler;
- (CGRect)scanViewFrame;

- (instancetype)initWithTitle:(NSString *)title;

// To add a flip orietation button to any scan mode that extends ALBasescanViewController
// you need to call this method on view did load.
- (void)setupFlipOrientationButton;

- (void)enableLandscapeOrientation:(BOOL)isLandscape;

- (void)installScanView:(ALScanView * _Nonnull)scanView;

- (NSString * _Nullable)configJSONStrWithFilename:(NSString *)filename;

@end

NS_ASSUME_NONNULL_END
