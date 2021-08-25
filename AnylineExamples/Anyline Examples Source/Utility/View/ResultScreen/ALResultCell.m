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
@property (strong, nonatomic) IBOutlet UIView *fillerView;
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
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont AL_proximaRegularWithSize:14];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.font = [UIFont AL_proximaRegularWithSize:16];
    self.valueLabel.textColor = [UIColor AL_LabelBlackWhite];
    if (@available(iOS 13.0, *)) {
        self.titleLabel.textColor = [UIColor secondaryLabelColor];
    } else {
        self.titleLabel.textColor = [UIColor lightGrayColor];
    }
    self.titleLabel.numberOfLines = 0;
    self.valueLabel.numberOfLines = 0;    
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.valueLabel];
    self.titleLabel.tag = 12;
    self.valueLabel.tag = 13;
    
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.valueLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self setupConstraints];
    
}

- (void)setupConstraints {
    NSMutableArray *constraints = @[[self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:5],
                                    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
                                    [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
                                    [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.valueLabel.topAnchor constant:0],
                                    [self.titleLabel.heightAnchor constraintEqualToConstant:24]].mutableCopy;
    
    [constraints addObjectsFromArray:@[[self.valueLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
                                       [self.valueLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
                                       [self.valueLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10]]];
    
    [self.contentView addConstraints:constraints];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setResultEntry:(ALResultEntry *)entry {
    _resultEntry = entry;
    self.titleLabel.text = self.resultEntry.title;
    self.valueLabel.text = self.resultEntry.value;
    
    if (self.resultEntry.shouldSpellOutValue && self.resultEntry.isAvailable) {
        if (@available(iOS 13.0, *)) {
        //make sure VoiceOver reads the result letter-by-letter for codes/license plates/etc. The user can use the rotor to do this manually (and the character setting in the rotor even uses the phonetic alphabet to make things clearer), but if we can save them from switching between rotor settings when we know something won't make sense read as a word, it's a bit smoother.
            //unfortunately, VoiceOver reads "comma space" before the value, for unknown reasons
            self.valueLabel.accessibilityAttributedLabel = [[NSAttributedString alloc] initWithString:self.resultEntry.value attributes:@{UIAccessibilitySpeechAttributeSpellOut:@YES}];
            //also use a monospaced font so it's easier to distinguish between O and 0, I and 1, etc.
            self.valueLabel.font = [UIFont monospacedSystemFontOfSize:UIFont.labelFontSize weight:UIFontWeightRegular];
        } else {
            //in earlier versions of iOS, we could try adding spaces between characters, but this is not ideal as some characters will be pronounced as single-letter words or Roman numerals.
        }
    }
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
