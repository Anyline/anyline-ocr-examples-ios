//
//  ALBaseScanViewController.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 24/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Anyline/Anyline.h>
#import "ScanHistory.h"
#import "ALWarningView.h"

@interface ALBaseScanViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) CFTimeInterval startTime;

@property (nonatomic) ALScanHistoryType controllerType;

- (void)updateScanWarnings:(ALWarningState)warningState;

- (void)updateWarningPosition:(CGFloat)newPosition;

- (void)updateBrightness:(CGFloat)brightness forModule:(id)anylineModule ignoreTooDark:(BOOL)ignoreTooDark;

- (void)updateBrightness:(CGFloat)brightness forModule:(id)anylineModule;

- (void)anylineDidFindResult:(NSString*)result
               barcodeResult:(NSString *)barcodeResult
                       image:(UIImage*)image
                  scanPlugin:(ALAbstractScanPlugin *)scanPlugin
                  viewPlugin:(ALAbstractScanViewPlugin *)viewPlugin
                  completion:(void (^)(void))completion;

- (void)startListeningForMotion;
- (void)startPlugin:(ALAbstractScanViewPlugin *)plugin;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

@end
