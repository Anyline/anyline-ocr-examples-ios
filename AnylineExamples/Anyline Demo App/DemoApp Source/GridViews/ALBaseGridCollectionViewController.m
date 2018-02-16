//
//  ALBaseGridCollectionViewController.m
//  AnylineExamples
//
//  Created by Philipp Müller on 21/11/2017.
//  Copyright © 2017 Anyline GmbH. All rights reserved.
//

#import "ALBaseGridCollectionViewController.h"
#import "ALGridCollectionViewCell.h"
#import "ALMeterCollectionViewController.h"
#import "ALGridCollectionViewController.h"
#import "ALExample.h"

#import "ALBaseScanViewController.h"

#import "UIFont+ALExamplesAdditions.h"
#import "UIColor+ALExamplesAdditions.h"

#import "ALEnergyBaseViewController.h"

NSString * const reuseIdentifier = @"gridCell";
NSString * const viewControllerIdentifier = @"gridViewController";

@interface ALBaseGridCollectionViewController ()

@property (weak, nonatomic) IBOutlet UICollectionReusableView *headerView;

@end

@implementation ALBaseGridCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(self.exampleManager.title, nil);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView layoutSubviews];
}

#pragma mark - UICollectionReusableView methods

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    CGSize headerSize = [self headerSize];

    if ([self.exampleManager numberOfSections] > 1) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
        header.backgroundColor = [UIColor whiteColor];

        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(20,0, headerSize.width, headerSize.height)];
        label.text = [self.exampleManager titleForSectionIndex:indexPath.section];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont AL_proximaSemiboldWithSize:22];
        label.center = CGPointMake(label.center.x, header.center.y);
        [header addSubview:label];
        
        [reusableView addSubview:header];
    } else if (_showLogo) {
    
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
        header.backgroundColor = [UIColor whiteColor];
        
        UIImageView *anylineWhite = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AnylineLogo"]];
        [header addSubview:anylineWhite];
        anylineWhite.center = header.center;
        
        [reusableView addSubview:header];
    }

    return reusableView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.exampleManager numberOfExamplesInSectionIndex:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.exampleManager numberOfSections];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ALGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.name.text = [[self.exampleManager exampleForIndexPath:indexPath] name];
    cell.backgroundImageView.backgroundColor = [UIColor AL_examplesBlue];
    cell.backgroundImageView.image = [[self.exampleManager exampleForIndexPath:indexPath] image];
    
    cell.name.font = [UIFont AL_proximaSemiboldWithSize:16];
    cell.name.textColor = [UIColor whiteColor];
    cell.name.numberOfLines = 0;
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ALExample *example = [self.exampleManager exampleForIndexPath:indexPath];
    
    if ([example.viewController isSubclassOfClass:[ALBaseScanViewController class]] || [example.viewController isSubclassOfClass:[ALEnergyBaseViewController class]]) {
        ALBaseScanViewController *vc = [[example.viewController alloc] init];
        vc.managedObjectContext = self.managedObjectContext;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (example.viewController) {
        if ([example.viewController isSubclassOfClass:[ALMeterCollectionViewController class]]) {
            ALMeterCollectionViewController *vc = (ALMeterCollectionViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"meterGridViewController"];
            vc.exampleManager = [[example.exampleManager alloc] init];
            vc.managedObjectContext = self.managedObjectContext;

            if (vc) {
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else if ([example.viewController isSubclassOfClass:[ALBaseGridCollectionViewController class]]) {
            ALGridCollectionViewController *vc = (ALGridCollectionViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"gridViewController"];
            vc.exampleManager = [[example.exampleManager alloc] init];
            vc.managedObjectContext = self.managedObjectContext;
            vc.showLogo = YES;
            
            if (vc) {
                [self.navigationController pushViewController:vc animated:YES];
            }
         }
    }

    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - Utility Methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return [self headerSize];
}

- (UIColor *)generateRandomColor {
    return [UIColor colorWithRed:(float)rand() / RAND_MAX green:(float)rand() / RAND_MAX blue:(float)rand() / RAND_MAX alpha:1.0f];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    float cellWidth = self.view.bounds.size.width / 2.0 - 20;
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    
    return size;
}

- (CGSize)headerSize {
    return (self.showLogo) ? CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width*0.25) : CGSizeZero;
}

@end

