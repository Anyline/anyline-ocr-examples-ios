//
//  ALDialogSelectionTableViewCell.m
//  AnylineExamples
//
//  Created by Aldrich Co on 7/23/21.
//

#import "ALDialogSelectionTableViewCell.h"
#import "UIFont+ALExamplesAdditions.h"

@interface ALDialogSelectionTableViewCell ()

@property (nonatomic, retain) UIView *line;

@property (nonatomic, retain) UIImageView *checkmark;

@property (nonatomic, retain) UILabel *mainLabel;
@property (nonatomic, retain) UILabel *selectionStatusLabel;

@end

@implementation ALDialogSelectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 13.0, *)) {
            [self.contentView setBackgroundColor:[UIColor secondarySystemGroupedBackgroundColor]];
        }
        
        _line = [[UIView alloc] init];
        [self.contentView addSubview:_line];
        [_line setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_line setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1f]];
        [_line setHidden:YES];
        
        _checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark_script_selection"]];
        [self.contentView addSubview:_checkmark];
        [_checkmark setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_checkmark setHidden:YES];
        
        _mainLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_mainLabel];
        [_mainLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_mainLabel setTextColor:[UIColor blackColor]];
        if (@available(iOS 13.0, *)) {
            [_mainLabel setTextColor:[UIColor labelColor]];
        }
        
        [_mainLabel setFont:[UIFont AL_proximaRegularWithSize:18]];
        [_mainLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        _selectionStatusLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_selectionStatusLabel];
        [_selectionStatusLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_selectionStatusLabel setTextColor:[UIColor systemBlueColor]];
        [_selectionStatusLabel setFont:[UIFont AL_proximaSemiboldWithSize:14]];
        [_selectionStatusLabel setNumberOfLines:1];
        [_selectionStatusLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [_selectionStatusLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        
        [self setupContraints];
    }
    return self;
}

- (void)setupContraints {

    NSArray<NSLayoutConstraint *> *lineConstraints = @[
        [_line.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [_line.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor],
        [_line.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        [_line.heightAnchor constraintEqualToConstant:1],
    ];

    [self.contentView addConstraints:lineConstraints];
    [NSLayoutConstraint activateConstraints:lineConstraints];
    
    NSArray<NSLayoutConstraint *> *checkmarkConstraints = @[
        [_checkmark.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [_checkmark.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
    ];

    [self.contentView addConstraints:checkmarkConstraints];
    [NSLayoutConstraint activateConstraints:checkmarkConstraints];
    
    NSArray<NSLayoutConstraint *> *mainLabelConstraints = @[
        [_mainLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [_mainLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [_mainLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.contentView.trailingAnchor constant:-20],
    ];

    [self.contentView addConstraints:mainLabelConstraints];
    [NSLayoutConstraint activateConstraints:mainLabelConstraints];
    
    NSArray<NSLayoutConstraint *> *statusLabelConstraints = @[
        [_selectionStatusLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [_selectionStatusLabel.leadingAnchor constraintEqualToAnchor:_mainLabel.trailingAnchor constant:10],
        [_selectionStatusLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
    ];

    [self.contentView addConstraints:statusLabelConstraints];
    [NSLayoutConstraint activateConstraints:statusLabelConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)showSeparator:(BOOL)show {
    _line.hidden = !show;
}

- (void)showCheckmark:(BOOL)show {
    _checkmark.hidden = !show;
}

- (void)setMainText:(NSString *)mainText {
    self.mainLabel.text = mainText;
}

- (void)setMainTextFontSize:(CGFloat)fontSize {
    self.mainLabel.font = [self.mainLabel.font fontWithSize:fontSize];
}

- (void)setSelectionStatusText:(NSString *)statusMsg {
    self.selectionStatusLabel.text = statusMsg;
}

@end
