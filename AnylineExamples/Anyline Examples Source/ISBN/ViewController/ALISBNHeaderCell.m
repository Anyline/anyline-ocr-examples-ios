//
//  ALISBNHeaderCell.m
//  ExampleApi
//
//  Created by David Dengg on 15.02.16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "ALISBNHeaderCell.h"

@interface ALISBNHeaderCell ()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *author;
@property (nonatomic, strong) UILabel *publisher;
@property (nonatomic, strong) UILabel *year;
@end

@implementation ALISBNHeaderCell {
    BOOL _setUp;
}


- (void)placeViews {
    // Return if the cell already is set up
    if (_setUp) return;
    _setUp = YES;
    
    NSInteger iTopOffset    = 30;
    NSInteger iHeight       = 35;
    NSInteger iLeftDistance = 30;
    NSInteger headerHeight  = 130;
    
    CGFloat coverSplit = self.bounds.size.width/3;
    CGFloat labelLenght = self.bounds.size.width - iLeftDistance - 20 - coverSplit;
    
    { // Cover
        __block UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftDistance, iTopOffset, 90, headerHeight)];
        imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:imageView];
        imageView.backgroundColor = [UIColor clearColor];
        self.cover = imageView;
    }
    
    { // Title
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iLeftDistance + coverSplit + 10, iTopOffset, labelLenght, 40)];
        label.backgroundColor = [UIColor clearColor];
        [label setFont:[UIFont boldSystemFontOfSize:14]];
        [label setLineBreakMode:NSLineBreakByTruncatingTail];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label setNumberOfLines:2];
        
        [self addSubview:label];
        self.title = label;
    }
    
    iTopOffset += 30;
    { // Author
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iLeftDistance + coverSplit + 10, iTopOffset, labelLenght, iHeight)];
        label.backgroundColor= [UIColor clearColor];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setLineBreakMode:NSLineBreakByTruncatingTail];
        [label setNumberOfLines:2];
        [self addSubview:label];
        self.author = label;
    }
    
    iTopOffset += 30;
    { // Publisher
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iLeftDistance + coverSplit + 10, iTopOffset, labelLenght, iHeight)];
        [label setFont:[UIFont systemFontOfSize:10]];
        [label setLineBreakMode:NSLineBreakByTruncatingTail];
        [label setNumberOfLines:1];
        [self addSubview:label];
        self.publisher = label;
    }
    
    iTopOffset += 15;
    { // Year
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iLeftDistance + coverSplit + 10, iTopOffset, labelLenght, iHeight)];
        [label setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:label];
        self.year = label;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)updateCellWithTitle:(NSString *)title
                     author:(NSString *)author
                  publisher:(NSString *)publisher
                       year:(NSString *)year
              thumbnailLink:(NSString *)thumbnailLink {
    
    [self placeViews];
    
    
    // Download the image in the background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (thumbnailLink.length == 0){
            return;
        }
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbnailLink]];
        UIImage *image;
        
        if (imgData != nil) {
            image = [UIImage imageWithData:imgData];
        }
        
        if(!image) {
            // The image ist still nil. Load a default cover
            image = [UIImage imageNamed:@"default_cover"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Set the image on the main thread
            self.cover.image = image;
        });
    });
    
    self.author.text    = author;
    self.title.text     = title;
    self.publisher.text = publisher;
    self.year.text      = year;
}

- (CGFloat)cellHeight {
    return [ALISBNHeaderCell cellHeight];;
}

+ (CGFloat)cellHeight {
    return 180;
}



@end
