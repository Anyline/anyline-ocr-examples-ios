//
//  ALHistoryCell.m
//  AnylineExamples
//
//  Created by David on 30/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALHistoryCell.h"
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"

@interface ALHistoryCell ()
@property (nonatomic, strong) UIView * separator;
@end

@implementation ALHistoryCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 20)];
            label.textColor = [UIColor AL_examplesBlue];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont AL_proximaRegularWithSize:12];
            [label setText:@""];
            self.leftLabel = label;
        }
        
        {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 20)];
            label.textColor = [UIColor AL_examplesBlue];
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont AL_proximaRegularWithSize:12];
            [label setText:@""];
            self.rightLabel = label;
        }
        
        {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
            if (@available(iOS 13.0, *)) {
                label.textColor = [UIColor labelColor];
            } else {
                label.textColor = [UIColor blackColor];
            }
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont AL_proximaBoldWithSize:16];
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 0;
            self.mainTextLabel = label;
        }
        
        {
            UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            
            self.scannedImageView = iv;
        }
        
        {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 20)];
            if (@available(iOS 13.0, *)) {
                label.textColor = [UIColor labelColor];
            } else {
                label.textColor = [UIColor blackColor];
            }
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont AL_proximaRegularWithSize:13];
            [label setText:@"Barcode:"];
            self.barcodeLabel = label;
            self.barcodeLabel.hidden = true;
        }
        
        {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 20)];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont AL_proximaRegularWithSize:13];
            [label setText:@""];
            self.barcodeResultLabel = label;
            self.barcodeResultLabel.hidden = true;
        }

        {
            UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            separator.backgroundColor = [UIColor lightGrayColor];
            self.separator = separator;
        }

        [self.contentView addSubview:self.mainTextLabel];
        [self.contentView addSubview:self.rightLabel];
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.scannedImageView];
        [self.contentView addSubview:self.separator];
        [self.contentView addSubview:self.barcodeLabel];
        [self.contentView addSubview:self.barcodeResultLabel];
        
        NSAssert(self.mainTextLabel.superview, @"no superview");
        NSAssert(self.rightLabel.superview, @"no superview");
        NSAssert(self.leftLabel.superview, @"no superview");
        NSAssert(self.scannedImageView.superview, @"no superview");
        NSAssert(self.separator.superview, @"no superview");
        NSAssert(self.barcodeLabel.superview, @"no superview");
        NSAssert(self.barcodeResultLabel.superview, @"no superview");
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self arrangeSubviews];
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    self.separator.backgroundColor = separatorColor;
}

- (void)arrangeSubviews {
    CGFloat borderPadding = 5;
    CGFloat offset = borderPadding;
    
    {
        self.leftLabel.frame  = CGRectMake(borderPadding, offset, 200, 20);
        self.rightLabel.frame = CGRectMake(self.contentView.frame.size.width-200-borderPadding, offset, 150, 20);
        offset += lround(self.rightLabel.frame.size.height + borderPadding);
    }
    
    {
        CGFloat height = [self heigtForString:self.mainTextLabel.text];
        self.mainTextLabel.frame = CGRectMake(self.mainTextLabel.frame.origin.x,
                                              offset,
                                              280,
                                              height);
        
        self.mainTextLabel.center = CGPointMake(self.contentView.center.x, self.mainTextLabel.center.y);
        offset += lround(self.mainTextLabel.frame.size.height + borderPadding);
    }
    
    {
        self.scannedImageView.frame  = CGRectMake(0, offset, self.scannedImageView.frame.size.width, self.scannedImageView.frame.size.height);
//
//        CGSize imgSize  = self.scannedImageView.image.size;
//
//        CGFloat ratio   = imgSize.height / imgSize.width;
//        NSLog(@"imgSize: %@", NSStringFromCGSize(self.scannedImageView.image.size));
//
//        CGRect imgFrame = self.scannedImageView.frame;
//
//        NSInteger newHeight = lround(imgFrame.size.width*ratio);
//        NSLog(@"newHeihgt: %ld", newHeight);
        
//        self.scannedImageView.frame = CGRectMake(imgFrame.origin.x,
//                                                 imgFrame.origin.y,
//                                                 imgFrame.size.width,
//                                                 newHeight);
        
        self.scannedImageView.center = CGPointMake(self.contentView.center.x, self.scannedImageView.center.y);
        offset = offset + self.scannedImageView.frame.size.height + borderPadding;
    }
    
    {
        self.barcodeLabel.frame  = CGRectMake(0, offset, self.contentView.frame.size.width/2 - borderPadding, 20);
        self.barcodeResultLabel.frame = CGRectMake(self.contentView.frame.size.width/2 + borderPadding, offset,
                                                   self.contentView.frame.size.width/2 - borderPadding, 20);
        offset += lround(self.barcodeLabel.frame.size.height + borderPadding);
    }
    
    offset += borderPadding + 5;
    
    self.separator.frame = CGRectMake(0, offset-1, self.frame.size.width, 1);
    self.cellHeight = offset;
}

- (void)setMainText:(NSString*)mainText; {
    self.mainTextLabel.text = mainText;
}

- (void)setScannedImage:(UIImage*)image {
    self.scannedImageView.image = image;
}

- (CGFloat)heigtForString:(NSString *)stringValue  {
    CGSize constraint = CGSizeMake(280, 9999);
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont AL_proximaBoldWithSize:16]};
    
    CGRect rect = [stringValue boundingRectWithSize:constraint
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil];
    return rect.size.height;
}

@end
