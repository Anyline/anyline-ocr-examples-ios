//
//  ALHeaderCollectionReusableView.h
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 17.03.21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALHeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic, nonnull) UILabel *headerTitleLabel;
@property (nonatomic, nonnull) UIImageView *questionMarkImageView;

@end

NS_ASSUME_NONNULL_END
