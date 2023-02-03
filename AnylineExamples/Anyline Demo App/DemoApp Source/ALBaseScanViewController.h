#import <UIKit/UIKit.h>
#import <Anyline/Anyline.h>
#import "ScanHistory+CoreDataClass.h"
#import "ALWarningView.h"
#import "UIViewController+ALExamplesAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@class ALResultEntry;

@interface ALBaseScanViewController : UIViewController <ALScanViewDelegate>

@property (nonatomic, strong, nullable) ALScanView *scanView;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) CFTimeInterval startTime;

@property (nonatomic) ALScanHistoryType controllerType;

@property (nonatomic, strong) NSString *titleString;

@property (nullable, nonatomic, strong) UIButton *flipOrientationButton;

@property () BOOL isOrientationFlipped;

@property (nonatomic, readonly) BOOL isDarkMode;

- (void)setColors;

- (NSString * _Nullable)configJSONStrWithFilename:(NSString *_Nonnull)filename;

- (void)installScanView:(ALScanView *_Nonnull)scanView;

- (void)updateScanWarnings:(ALWarningState)warningState;

- (void)updateBrightness:(CGFloat)brightness forModule:(id)anylineModule ignoreTooDark:(BOOL)ignoreTooDark;

- (void)updateBrightness:(CGFloat)brightness forModule:(id)anylineModule;


// MARK: - AnylineDidFindResult methods

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

- (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray <UIAlertAction *>*)actions;

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message completion:(void (^ _Nullable)(void))completion;

- (void)showAlertForError:(NSError * _Nonnull)error
               completion:(void (^ _Nullable)(void))completion
           dismissHandler:(void (^ _Nullable)(void))dismissHandler;

- (void)showAlertForError:(NSError * _Nonnull)error
           dismissHandler:(void (^ _Nullable)(void))dismissHandler;

/// If an error is found when creating a scan view or scan view plugin, this can be called to return
/// to the previous screen. Pass the error parameter obtained from the previous call. If non-null,
/// an alert is shown containing the error string from the object, otherwise execution continues to the
/// next statement. Dismissing the alert takes you back to the previous screen.
///
/// It should be used like this:
///
///     NSError *error;
///     self.scanView = [self initializeScanView:&error];
///     if ([self popWithAlertOnError:error]) { return; }
///     
/// - Parameter error: an NSError object
- (BOOL)popWithAlertOnError:(NSError * _Nullable)error;

- (CGRect)scanViewFrame;

- (NSString *)addon;

- (instancetype)initWithTitle:(NSString *)title;

// To add a flip orietation button to any scan mode that extends ALBasescanViewController
// you need to call this method on view did load.
- (void)setupFlipOrientationButton;

- (void)enableLandscapeOrientation:(BOOL)isLandscape;

@end

NS_ASSUME_NONNULL_END
