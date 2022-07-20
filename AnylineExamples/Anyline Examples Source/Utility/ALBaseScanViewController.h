//
//  ALBaseScanViewController.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 24/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Anyline/Anyline.h>
#import "ScanHistory+CoreDataClass.h"
#import "ALWarningView.h"

@interface ALBaseScanViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) CFTimeInterval startTime;

@property (nonatomic) ALScanHistoryType controllerType;

@property (nullable, nonatomic, strong) UIButton *flipOrientationButton;
@property () BOOL isOrientationFlipped;

- (void)updateScanWarnings:(ALWarningState)warningState;

- (void)updateWarningPosition:(CGFloat)newPosition;

- (void)updateBrightness:(CGFloat)brightness forModule:(id)anylineModule ignoreTooDark:(BOOL)ignoreTooDark;

- (void)updateBrightness:(CGFloat)brightness forModule:(id)anylineModule;

- (NSString *)jsonStringFromResultData:(NSArray*)resultData;

- (void)anylineDidFindResult:(NSString*)result
               barcodeResult:(NSString *)barcodeResult
                       image:(UIImage*)image
                  scanPlugin:(ALAbstractScanPlugin *)scanPlugin
                  viewPlugin:(ALAbstractScanViewPlugin *)viewPlugin
                  completion:(void (^)(void))completion;

- (void)anylineDidFindResult:(NSString*)result
               barcodeResult:(NSString *)barcodeResult
                      images:(NSArray*)images
                  scanPlugin:(ALAbstractScanPlugin *)scanPlugin
                  viewPlugin:(ALAbstractScanViewPlugin *)viewPlugin
                  completion:(void (^)(void))completion;

- (void)anylineDidFindResult:(NSString*)result
               barcodeResult:(NSString *)barcodeResult
                   faceImage:(UIImage*)faceImage
                      images:(NSArray*)images
                  scanPlugin:(ALAbstractScanPlugin *)scanPlugin
                  viewPlugin:(ALAbstractScanViewPlugin *)viewPlugin
                  completion:(void (^)(void))completion;

- (void)anylineDidFindResult:(NSString*)result
               barcodeResult:(NSString *)barcodeResult
                       image:(UIImage*)image
                  scanPlugin:(ALAbstractScanPlugin *)scanPlugin
                  viewPlugin:(ALAbstractScanViewPlugin *)viewPlugin
                  completion:(void (^)(void))completion;

- (void)startListeningForMotion;
- (void)startPlugin:(ALAbstractScanViewPlugin *)plugin;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message completion:(void (^ _Nullable)(void))completion;
- (void)showAlertForScanningError:(NSError * _Nonnull)error completion:(void (^ _Nullable)(void))completion dismissHandler:(void (^ _Nullable)(void))dismissHandler;
- (CGRect)scanViewFrame;

- (instancetype)initWithTitle:(NSString *)title;

// To add a flip orietation button to any scan mode that extends ALBasescanViewController
// you need to call this method on view did load.
- (void)setupFlipOrientationButton;
- (void)enableLandscapeOrientation:(BOOL)isLandscape;

@end
