//
//  ALBarcodeBatchCountView.h
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 17.10.22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALBarcodeBatchCountView : UIView

@property (nonatomic, strong) IBOutlet UILabel *batchCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *batchCountResultLabel;
@property (nonatomic, strong) IBOutlet UILabel *batchCountSymbologyLabel;

- (void)setBatchCountText:(NSString *)text;
- (void)setCountResultText:(NSString *)text;
- (void)setBatchCountSymbologyText:(NSString *)text;
- (void)resetLabels;

@end

NS_ASSUME_NONNULL_END
