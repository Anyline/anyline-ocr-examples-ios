//
//  ALDialogSelectionTableViewCell.h
//  AnylineExamples
//
//  Created by Aldrich Co on 7/23/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALDialogSelectionTableViewCell : UITableViewCell

- (void)showSeparator:(BOOL)show;

- (void)showCheckmark:(BOOL)show;

- (void)setMainText:(NSString *)mainText;

- (void)setMainTextFontSize:(CGFloat)fontSize;

- (void)setSelectionStatusText:(NSString *)statusMsg;

@end

NS_ASSUME_NONNULL_END
