//
//  ALHistoryCell.h
//  AnylineExamples
//
//  Created by David on 30/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALHistoryCell : UITableViewCell
@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * rightLabel;
@property (nonatomic, strong) UILabel * mainTextLabel;
@property (nonatomic, strong) UILabel * typeLabel;
@property (nonatomic, strong) UIColor * separatorColor;
@property (nonatomic, strong) UIImageView * scannedImageView;

@property (nonatomic, strong) UILabel * barcodeLabel;
@property (nonatomic, strong) UILabel * barcodeResultLabel;

@property (nonatomic, assign) NSInteger cellHeight;

- (void)setMainText:(NSString*)mainText;
- (void)setScannedImage:(UIImage*)image;
- (void)arrangeSubviews;

@end
