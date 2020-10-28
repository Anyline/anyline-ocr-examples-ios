//
//  ALGridCollectionViewCell.h
//  AnylineExamples
//
//  Created by Philipp Müller on 21/11/2017.
//  Copyright © 2017 Anyline GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALGridCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
//the color to add at the top of the tile, which will fade to clear at the bottom
//set to nil for no gradient
@property (strong, nonatomic) UIColor *gradientColor;

@end
