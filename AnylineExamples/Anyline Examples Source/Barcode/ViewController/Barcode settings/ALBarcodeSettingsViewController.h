//
//  ALBarcodeSettingsViewController.h
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 11.10.22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ALBarcodeSettingsDelegate;

@class ALBarcodeFormat;
@interface ALBarcodeSettingsViewController : UIViewController

@property (nonatomic, weak) id<ALBarcodeSettingsDelegate> delegate;
@property (nonatomic, strong) NSArray<NSString *> * barcodeFormatOptions;
@property () BOOL isSingleManualScanEnabled;
@property () BOOL isMultiManualScanEnabled;

- (NSArray<ALBarcodeFormat *> *)getDefaultFormatsForDefaultReadableNames;

@end

@protocol ALBarcodeSettingsDelegate <NSObject>

- (void)selectedSymbologies:(NSArray<NSString *> *)selectedItems;
- (void)isSingleScanTriggerEnabled:(BOOL)isEnabled;
- (void)isMultiScanTriggerEnabled:(BOOL)isEnabled;

@end

NS_ASSUME_NONNULL_END
