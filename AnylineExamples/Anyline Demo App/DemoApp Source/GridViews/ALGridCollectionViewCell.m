//
//  ALGridCollectionViewCell.m
//  AnylineExamples
//
//  Created by Philipp Müller on 21/11/2017.
//  Copyright © 2017 Anyline GmbH. All rights reserved.
//

#import "ALGridCollectionViewCell.h"
#import "UIFont+ALExamplesAdditions.h"

@interface ALGridCollectionViewCell ()
@property CAGradientLayer *gradientLayer;

@end

@implementation ALGridCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _backgroundImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_backgroundImageView];
        
        _name = [[UILabel alloc] init];
        _name.font = [UIFont AL_proximaSemiboldWithSize:16];
        _name.textColor = [UIColor whiteColor];
        _name.numberOfLines = 0;
        self.frame = frame;
        [self.contentView addSubview:_name];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.name.frame = CGRectMake(20, self.contentView.bounds.size.height - 30, self.contentView.bounds.size.width - 40, 20);
    self.backgroundImageView.frame = self.contentView.bounds;
    if (self.gradientColor) {
        if (self.gradientLayer == nil) {
            self.gradientLayer = [[CAGradientLayer alloc] init];
            [_backgroundImageView.layer addSublayer:self.gradientLayer];
        }
        self.gradientLayer.colors = @[(id)self.gradientColor.CGColor,(id)[self.gradientColor colorWithAlphaComponent:0].CGColor];
        self.gradientLayer.frame = self.contentView.bounds;
    }
}


@end
