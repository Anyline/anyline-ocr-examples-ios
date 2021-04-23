//
//  ALHeaderCollectionReusableView.m
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 17.03.21.
//

#import "ALHeaderCollectionReusableView.h"
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"

@implementation ALHeaderCollectionReusableView

-(instancetype)init {
    self = [super init];
    [self setupHeaderSubViews];
    [self setupSubviewsConstraints];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setupHeaderSubViews];
    [self setupSubviewsConstraints];
    return self;
}

-(void)setupHeaderSubViews {
    self.backgroundColor = [UIColor AL_SectionGridBG];
    
    UILabel *headerTitleLabel = [[UILabel alloc] init];
    [headerTitleLabel setBackgroundColor:[UIColor clearColor]];
    headerTitleLabel.textAlignment = NSTextAlignmentLeft;
    headerTitleLabel.textColor = [UIColor AL_SectionLabel];
    headerTitleLabel.font = [UIFont AL_proximaSemiboldWithSize:14];
    [self addSubview:headerTitleLabel];
    [headerTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.headerTitleLabel = headerTitleLabel;
    
    UIImageView *questionMarkImageView = [[UIImageView alloc] init];
    [questionMarkImageView setContentMode:UIViewContentModeScaleAspectFit];
    [questionMarkImageView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:questionMarkImageView];
    [questionMarkImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.questionMarkImageView = questionMarkImageView;
}

-(void)setupSubviewsConstraints{
    NSMutableArray *constraints = @[[self.headerTitleLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
                                    [self.headerTitleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15],
                                    [self.headerTitleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]].mutableCopy;
    
    
    
    [constraints addObjectsFromArray:@[[self.questionMarkImageView.centerYAnchor constraintEqualToAnchor:self.headerTitleLabel.centerYAnchor constant:0],
                                       [self.questionMarkImageView.leadingAnchor constraintEqualToAnchor:self.headerTitleLabel.trailingAnchor constant:5],
                                       [self.questionMarkImageView.widthAnchor constraintEqualToConstant:13],
                                       [self.questionMarkImageView.heightAnchor constraintEqualToConstant:13]]];
    
    [self addConstraints:constraints];
    [NSLayoutConstraint activateConstraints:constraints];
}

@end
