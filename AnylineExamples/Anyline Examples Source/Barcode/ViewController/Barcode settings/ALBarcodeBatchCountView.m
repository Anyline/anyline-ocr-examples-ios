//
//  ALBarcodeBatchCountView.m
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 17.10.22.
//

#import "ALBarcodeBatchCountView.h"

@interface ALBarcodeBatchCountView()

@end

@implementation ALBarcodeBatchCountView

- (void)setBatchCountText:(NSString *)text {
    [self.batchCountLabel setText:text];
}

- (void)setCountResultText:(NSString *)text {
    [self.batchCountResultLabel setText:text];
}

- (void)setBatchCountSymbologyText:(NSString *)text {
    [self.batchCountSymbologyLabel setText:text];
}

- (void)resetLabels {
    [self.batchCountLabel setText:@"0"];
    [self.batchCountResultLabel setText:@""];
    [self.batchCountSymbologyLabel setText:@""];
}

@end
