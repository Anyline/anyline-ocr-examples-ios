#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ALIDCountryHelper.h"
#import "ALConfigurationDialogViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ALUniversalIDScanConfigControllerDelegate;

@interface ALUniversalIDScanConfig : NSObject <NSCopying>

@property (nonatomic, strong) NSArray<NSString *> *regions;

@property (nonatomic, assign) ALScriptType scriptType;

- (instancetype)initWithRegions:(NSArray<NSString *> *)regions scriptType:(ALScriptType)scriptType;

@end


@interface ALUniversalIDScanConfigController : NSObject

@property (nonatomic, strong) ALUniversalIDScanConfig *config;

// used to stand in place of the usual caller ALUniversal...FrontAndBack
// to abstract away the dialog management from it
@property (nonatomic, weak) UIViewController *presentingViewController;

@property (nonatomic, weak) id<ALUniversalIDScanConfigControllerDelegate> delegate;

- (instancetype)initWithPresentingVC:(UIViewController *)presentingVC
                       countryHelper:(ALIDCountryHelper *)idCountryHelper
                          selectMode:(ALConfigDialogType)selectMode
                            delegate:(nonnull id<ALUniversalIDScanConfigControllerDelegate>)delegate;

- (void)start;

@end


@protocol ALUniversalIDScanConfigControllerDelegate

// report when a change is registered, so that the scan view would get its configs reloaded.
// if nil, then no change was detected.
- (void)idScanConfigController:(ALUniversalIDScanConfigController *)controller
     finishedWithUpdatedConfig:(BOOL)hasUpdates;

- (void)idScanConfigController:(ALUniversalIDScanConfigController *)controller
              isChangingScript:(ALScriptType)newScript;

- (void)dialogStarted;

- (void)dialogCancelled;

@end

NS_ASSUME_NONNULL_END
