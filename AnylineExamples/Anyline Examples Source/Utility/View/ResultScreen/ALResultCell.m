//
//  ALResultCell.m
//  AnylineExamples
//
//  Created by Philipp Müller on 07.05.18.
//

#import "ALResultCell.h"
#import <Foundation/Foundation.h>

#import "UIFont+ALExamplesAdditions.h"
#import "UIColor+ALExamplesAdditions.h"

@interface ALResultCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UIImageView *checkmarkView;
@end


@implementation ALResultCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.titleLabel.font = [UIFont AL_proximaRegularWithSize:14];
    self.titleLabel.textColor = [UIColor lightGrayColor];
    
    self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    self.valueLabel.font = [UIFont AL_proximaRegularWithSize:16];
    self.valueLabel.textColor = [UIColor blackColor];
    self.valueLabel.numberOfLines = 0;
    self.valueLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.checkmarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.checkmarkView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_valueLabel];
    [self.contentView addSubview:_checkmarkView];
    
    CGFloat height = self.titleLabel.frame.size.height + self.valueLabel.frame.size.height+5;
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, height);
    self.cellHeight = self.contentView.frame.size.height;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 10;
    CGFloat checkmarkHeight = self.checkmarkView.frame.size.height;
    
    //Title setup
    self.titleLabel.frame = CGRectMake(padding, 0, self.contentView.frame.size.width - padding*2, 20);
    
    //Value setup
    self.valueLabel.frame = CGRectMake(padding,
                                       self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height,
                                       self.contentView.frame.size.width - padding*2 - checkmarkHeight-5,
                                       self.valueLabel.frame.size.height);
    
    //Check if single or multiple lines
    if ([self numberOfLinesForString:self.valueLabel.text] > 1){
        CGSize size = [self.valueLabel.text sizeWithFont:self.valueLabel.font
                                       constrainedToSize:CGSizeMake(self.valueLabel.frame.size.width, MAXFLOAT)
                                           lineBreakMode:NSLineBreakByWordWrapping];
        CGRect labelFrame = self.valueLabel.frame;
        labelFrame.size.height = size.height;
        self.valueLabel.frame = labelFrame;
    } else {
        self.valueLabel.adjustsFontSizeToFitWidth = YES;
        self.valueLabel.numberOfLines = 1;
    }
    
    

    //Checkmark setup
    self.checkmarkView.center = CGPointMake(self.contentView.frame.size.width - checkmarkHeight/2 - padding, self.valueLabel.center.y);
    
    
}

- (void)setResultEntry:(ALResultEntry *)entry {
    _resultEntry = entry;
    self.titleLabel.text = self.resultEntry.title;
    self.valueLabel.text = self.resultEntry.value;
    self.checkmarkView.image = (self.resultEntry.isAvailable) ? [UIImage imageNamed:@"blue round checkmark"] : nil;
}

#pragma mark - Private Methods
- (NSUInteger)numberOfLinesForString:(NSString *)string {
    NSUInteger numberOfLines, index, stringLength = [string length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
        index = NSMaxRange([string lineRangeForRange:NSMakeRange(index, 0)]);
    }
    return numberOfLines;
}



@end
