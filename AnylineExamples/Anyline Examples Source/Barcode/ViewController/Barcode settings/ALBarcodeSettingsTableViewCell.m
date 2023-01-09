//
//  ALBarcodeSettingsTableViewCell.m
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 12.10.22.
//

#import "ALBarcodeSettingsTableViewCell.h"
#import "UIFont+ALExamplesAdditions.h"

@implementation ALBarcodeSettingsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [[self textLabel] setFont:[UIFont AL_proximaRegularWithSize:17]];
        
        self.rightContentView = [[UIView alloc] init];
        [self.rightContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.rightContentView];
        
        [self setupConstraints];
    }
    
    return self;
}

- (void)setupConstraints {
    NSArray<NSLayoutConstraint *> *rightContentConstraints = @[
        [self.rightContentView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor],
        [self.rightContentView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        [self.rightContentView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.rightContentView.widthAnchor constraintEqualToConstant:80]
    ];
    
    [self.contentView addConstraints:rightContentConstraints];
    [NSLayoutConstraint activateConstraints:self.contentView.constraints];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];
}

@end
