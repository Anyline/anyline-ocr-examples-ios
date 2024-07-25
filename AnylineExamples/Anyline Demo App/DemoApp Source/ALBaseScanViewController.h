#import <UIKit/UIKit.h>
#import <Anyline/Anyline.h>
#import "ScanHistory+CoreDataClass.h"
#import "ALWarningView.h"
#import "UIViewController+ALExamplesAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@class ALResultEntry;
@class ALModeSelectionButton;

@interface ALBaseScanViewController : UIViewController <ALScanViewDelegate>

@property (nonatomic, strong, nullable) ALScanView *scanView;

@property (nonatomic, readonly, nullable) NSObject<ALViewPluginBase> *scanViewPlugin;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) CFTimeInterval startTime;

@property (nonatomic) ALScanHistoryType controllerType;

@property (nonatomic, strong) NSString *titleString;

@property (nullable, nonatomic, strong) UIButton *flipOrientationButton;

/// Call -addModeSelectButtonWithTitle:buttonPressed: to add the button. You would
/// have to position the button yourself, and ensure that it is added on above the
/// scan view. You will also have to determine the on-tap implementation as well.
@property (nullable, nonatomic, strong) ALModeSelectionButton *modeSelectButton;

@property () BOOL isOrientationFlipped;

@property (nonatomic, readonly) BOOL isDarkMode;

- (void)setColors;

- (NSString * _Nullable)configJSONStrWithFilename:(NSString *_Nonnull)filename
                                            error:(NSError * _Nullable * _Nullable)error;

- (void)installScanView:(ALScanView * _Nonnull)scanView;

- (BOOL)startScanning:(NSError * _Nullable * _Nullable)error;

- (void)stopScanning;

/// Adds a toggle button on the main view (above where the scan view is). Do this after
/// installing the scan view.
/// - Parameters:
///   - title: the title initially shown on the button
///   - buttonPressed: block indicating what will be done after the button is pressed
- (void)addModeSelectButtonWithTitle:(NSString * _Nonnull)title
                                buttonPressed:(void (^ _Nullable)(void))buttonPressed;

- (void)updateScanWarnings:(ALWarningState)warningState;


// MARK: - AnylineDidFindResult methods

- (void)anylineDidFindResult:(NSString * _Nullable)result
               barcodeResult:(NSString * _Nullable)barcodeResult
                       image:(UIImage * _Nullable)image
                  scanPlugin:(ALScanPlugin *)scanPlugin
                  viewPlugin:(id<ALViewPluginBase>)viewPlugin
                  completion:(void (^)(void))completion;

- (void)anylineDidFindResult:(NSString * _Nullable)result
               barcodeResult:(NSString * _Nullable)barcodeResult
                      images:(NSArray * _Nullable)images
                  scanPlugin:(ALScanPlugin *)scanPlugin
                  viewPlugin:(id<ALViewPluginBase>)viewPlugin
                  completion:(void (^)(void))completion;

- (void)anylineDidFindResult:(NSString * _Nullable)result
               barcodeResult:(NSString * _Nullable)barcodeResult
                   faceImage:(UIImage * _Nullable)faceImage
                      images:(NSArray * _Nullable)images
                  scanPlugin:(ALScanPlugin *)scanPlugin
                  viewPlugin:(id<ALViewPluginBase>)viewPlugin
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

- (NSString * _Nullable)addon;

- (instancetype)initWithTitle:(NSString *)title;

// To add a flip orietation button to any scan mode that extends ALBasescanViewController
// you need to call this method on view did load.
- (void)setupFlipOrientationButton;

- (void)enableLandscapeOrientation:(BOOL)isLandscape;

@end

NS_ASSUME_NONNULL_END
