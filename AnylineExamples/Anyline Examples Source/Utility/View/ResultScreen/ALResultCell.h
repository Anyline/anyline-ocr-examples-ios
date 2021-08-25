//
//  ALResultCell.h
//  AnylineExamples
//
//  Created by Philipp Müller on 07.05.18.
//

#import <UIKit/UIKit.h>
#import "ALResultEntry.h"

@interface ALResultCell : UITableViewCell

@property (assign, nonatomic) ALResultEntry *resultEntry;
@property (nonatomic, assign) NSInteger cellHeight;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (void)alignLabelsTextRight;
- (void)alignLabelsTextLeft;

@end
