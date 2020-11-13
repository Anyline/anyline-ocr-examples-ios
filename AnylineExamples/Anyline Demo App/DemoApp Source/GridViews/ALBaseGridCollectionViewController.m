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

#import "ALNFCScanViewController.h"

NSString * const reuseIdentifier = @"gridCell";
NSString * const viewControllerIdentifier = @"gridViewController";

@interface ALBaseGridCollectionViewController ()

@property (weak, nonatomic) IBOutlet UICollectionReusableView *headerView;

@end

@implementation ALBaseGridCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //self.view.backgroundColor = [UIColor whiteColor];
    //self.collectionView.backgroundColor = [UIColor whiteColor];
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
    //todo: make this a custom class so we don't have to worry about adding subviews too many times
    int headerTag = 1337;
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    CGSize headerSize = [self headerSize];

    CGRect frame = [[UIScreen mainScreen] bounds];
    collectionView.frame = frame;
    if (self.header.superview != reusableView && [reusableView viewWithTag:headerTag] == nil) {
        if ([self.exampleManager numberOfSections] > 1) {
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
            header.tag = headerTag;
            self.header.backgroundColor = [UIColor whiteColor];

            UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(20,0, headerSize.width, headerSize.height)];
            label.text = [self.exampleManager titleForSectionIndex:indexPath.section];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentLeft;
            //todo: use dynamic type sizes (e.g. [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2] or scaledFontForFont:)
            label.font = [UIFont AL_proximaSemiboldWithSize:22];
            label.center = CGPointMake(label.center.x, header.center.y);
            [header addSubview:label];
            
            [reusableView addSubview:header];
            if (indexPath.section == 0) {
                self.header = header;
            }
        } else if (_showLogo) {
        
            self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
            self.header.tag = headerTag;
            self.header.backgroundColor = [UIColor whiteColor];
            
            UIImageView *anylineWhite = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AnylineLogo"]];
            [self.header addSubview:anylineWhite];
            anylineWhite.center = self.header.center;
            
            [reusableView addSubview:self.header];
        }
    }
    return reusableView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.exampleManager numberOfExamplesInSectionIndex:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.exampleManager numberOfSections];
}

- (UIColor *)gradientColorForIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ALGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.name.text = [[self.exampleManager exampleForIndexPath:indexPath] name];
    cell.backgroundImageView.backgroundColor = [UIColor AL_examplesBlue];
    cell.backgroundImageView.image = [[self.exampleManager exampleForIndexPath:indexPath] image];
    cell.backgroundView.contentMode = UIViewContentModeTop;
    cell.gradientColor = [self gradientColorForIndexPath:indexPath];
    cell.name.font = [UIFont AL_proximaSemiboldWithSize:16];
    cell.name.textColor = [UIColor whiteColor];
    cell.name.numberOfLines = 0;
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 2;
    
    return cell;
}

- (UIViewController *)createViewControllerFrom:(ALExample *)example {
    UIViewController *vc = nil;
    if ([example.viewController instancesRespondToSelector:@selector(initWithTitle:)]) {
        vc = [[example.viewController alloc] initWithTitle:example.navTitle];
    } else {
        vc = [[example.viewController alloc] init];
    }
    if ([vc respondsToSelector:@selector(setManagedObjectContext:)]) {
        [vc performSelector:@selector(setManagedObjectContext:) withObject:self.managedObjectContext];
    }
    return vc;
}

- (void)showViewController:(ALExample *)example {
    UIViewController * vc = [self createViewControllerFrom:example];
    [self.navigationController pushViewController:vc animated:YES];
}

//todo: share this code with the method in ALBaseScanViewController (in a category on UIViewController?)
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:dismissAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)openExample:(ALExample *)example {
    if ([example.viewController isSubclassOfClass:[ALBaseScanViewController class]] || [example.viewController isSubclassOfClass:[ALEnergyBaseViewController class]]) {
        if ([[example viewController] isSubclassOfClass:[ALNFCScanViewController class]]) {
            if (@available(iOS 13.0, *)) {
                if ([ALNFCDetector readingAvailable]) {
                    [self showViewController:example];
                } else {
                    [self showAlertWithTitle:@"NFC Not Supported" message:@"NFC passport reading is not supported on this device."];
                }
            } else {
                [self showAlertWithTitle:@"NFC Not Supported" message:@"NFC passport reading is only supported on iOS 13 and later."];
            }
        } else {
            [self showViewController:example];
        }
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
            //as per the redesign we don't want to show the logo on any of these screens
            //vc.showLogo = YES;
            
            if (vc) {
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ALExample *example = [self.exampleManager exampleForIndexPath:indexPath];
    [self openExample:example];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - Utility Methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return [self headerSize];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    float cellWidth = self.view.bounds.size.width / 2.0 - 20;
    CGSize size = CGSizeMake(cellWidth, cellWidth*(128.0/175.0));
    
    return size;
}

- (CGSize)headerSize {
    //we never actually show the logo if there is more than one section, so we don't need the headers to be as tall as the logo either. Ideally the height should be based on the title height; the 0.16 multiplier is for consistency with the lock icon on the meter reading screen.
    if ([self.exampleManager numberOfSections] > 1) {
        return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width*0.16);
    }
    return (self.showLogo) ? CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width*0.25) : CGSizeZero;
}

@end

