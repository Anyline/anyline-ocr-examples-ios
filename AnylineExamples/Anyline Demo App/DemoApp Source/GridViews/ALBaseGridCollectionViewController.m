//
//  ALBaseGridCollectionViewController.m
//  AnylineExamples
//
//  Created by Philipp Müller on 21/11/2017.
//  Copyright © 2017 Anyline GmbH. All rights reserved.
//

#import "ALBaseGridCollectionViewController.h"
#import <Anyline/Anyline.h>
#import "ALGridCollectionViewCell.h"
#import "ALMeterCollectionViewController.h"
#import "ALGridCollectionViewController.h"
#import "ALExample.h"
#import "ALBaseScanViewController.h"
#import "UIFont+ALExamplesAdditions.h"
#import "UIColor+ALExamplesAdditions.h"
#import "ALEnergyBaseViewController.h"
#import "ALNFCScanViewController.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "UIColor+ALExamplesAdditions.h"
#import "ALHeaderCollectionReusableView.h"
#import "ALUniversalIDScanViewController.h"
#import "ALLicensePlateScanViewController.h"

NSString * const reuseIdentifier = @"gridCell";
NSString * const viewControllerIdentifier = @"gridViewController";
NSString * const headerViewReuseIdentifier = @"HeaderView";

@interface ALBaseGridCollectionViewController ()

@property (weak, nonatomic) IBOutlet ALHeaderCollectionReusableView *headerView;

@end

@implementation ALBaseGridCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(self.exampleManager.title, nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.collectionView registerClass:[ALHeaderCollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:headerViewReuseIdentifier];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor AL_BackButton]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor AL_BackButton]];
    if (self.exampleManager) {
        [self.collectionView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView layoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.collectionView.userInteractionEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self setSecretDevModeTheme:[NSUserDefaults AL_secretDevModeEnabled]
                      forNavBar:[self.navigationController navigationBar]];
}

- (void)setSecretDevModeTheme:(BOOL)enabled forNavBar:(UINavigationBar *)navBar {
    UIColor *newColor = nil;
    if (enabled) {
        newColor = [UIColor AL_devTestModeColor];
    } else {
        newColor = [UIColor AL_NavigationBG];
    }

    if ([navBar.barTintColor isEqual:newColor]) {
        return;
    }
    [navBar setBarTintColor:newColor];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    // when you switch from light mode to dark mode this is called to ensure
    // that the correct gridview cell border color is used.
    [self.collectionView reloadData];
}

#pragma mark - UICollectionReusableView methods

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    //todo: make this a custom class so we don't have to worry about adding subviews too many times
    int headerTag = 1337;
    ALHeaderCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                      withReuseIdentifier:headerViewReuseIdentifier
                                                                                             forIndexPath:indexPath];
    CGSize headerSize = [self headerSize];

    CGRect frame = [[UIScreen mainScreen] bounds];
    collectionView.frame = frame;
    if (self.header.superview != reusableView && [reusableView viewWithTag:headerTag] == nil) {
        if ([self.exampleManager numberOfSections] > 1) {
            NSString *title = [self.exampleManager titleForSectionIndex:indexPath.section];
            reusableView.headerTitleLabel.text = title;
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

- (UIView *)createHeaderViewWithTag:(NSInteger)tag forSize:(CGSize)size title:(NSString *)title {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [header setBackgroundColor:[UIColor AL_SectionGridBG]];
    header.tag = tag;

    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0,0, size.width, size.height)];
    label.text = title;
    label.textColor = [UIColor AL_SectionLabel];
    label.backgroundColor = [UIColor clearColor];
    
    label.textAlignment = NSTextAlignmentLeft;
    //todo: use dynamic type sizes (e.g. [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2] or scaledFontForFont:)
    label.font = [UIFont AL_proximaSemiboldWithSize:14];
    label.center = CGPointMake(label.center.x, header.center.y);
    
    // Add x padding to our header label
    NSMutableParagraphStyle *labelTextStyle = [[NSMutableParagraphStyle alloc] init];
    labelTextStyle.alignment = NSTextAlignmentLeft;
    labelTextStyle.firstLineHeadIndent = 15.0;
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:label.text attributes:@{
                    NSParagraphStyleAttributeName : labelTextStyle,
                    }];
    label.attributedText = attributedString;
    
    [header addSubview:label];
    return header;
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
    return [self decorateCell:cell indexPath:indexPath];
}

- (ALGridCollectionViewCell *)decorateCell:(ALGridCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath {

    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 8;
    
    // Certain tiles should have borders around them. Useful to make them pop out in dark mode
    // these are defined in `-[ALIdentityDocumentsExampleManager initExampleData]`
    NSArray<NSString *> *specialTiles = @[@"Universal ID", @"Arabic ID", @"Cyrillic ID"];

    ALExample *example = [self.exampleManager exampleForIndexPath:indexPath];
    if (example.image != nil) { // non-null image imply a store app with images for tiles
        
        // special case for Universal ID - paint a border so there's clear indication in
        // dark mode that this is a button like others, rather than a banner.
        for (NSString *specialTile in specialTiles) {
            if ([[example name] localizedCompare:specialTile] == NSOrderedSame) {
                cell.layer.borderColor = [UIColor AL_SectionGridBG].CGColor;
                cell.layer.borderWidth = 2;
                break;
            }
        }
        
        cell.backgroundImageView.image = example.image;
        cell.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.backgroundView.contentMode = UIViewContentModeTop;
        cell.name.font = [UIFont AL_proximaSemiboldWithSize:16];
        cell.name.textColor = [UIColor AL_LabelBlackWhite];
        cell.name.numberOfLines = 0;
    } else {
        cell.backgroundImageView.backgroundColor = [UIColor AL_BackgroundColor];
        cell.name.text = example.name;
        cell.layer.borderColor = [UIColor AL_SectionGridBG].CGColor;
        cell.layer.borderWidth = 2;
    }

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
    UIViewController *vc = [self createViewControllerFrom:example];
    [self pushViewController:vc];
}

- (void)pushViewController:(UIViewController *)viewController {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:viewController animated:YES];
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
            [self pushViewController:vc];
        } else if ([example.viewController isSubclassOfClass:[ALBaseGridCollectionViewController class]]) {
            ALGridCollectionViewController *vc = (ALGridCollectionViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"gridViewController"];
            vc.exampleManager = [[example.exampleManager alloc] init];
            vc.managedObjectContext = self.managedObjectContext;
            [self pushViewController:vc];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ALExample *example = [self.exampleManager exampleForIndexPath:indexPath];
    collectionView.userInteractionEnabled = NO;
    [self openExample:example];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - Utility Methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([self.exampleManager numberOfSections] > 1) {
        return [self headerSize];
    } else {
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger padding = 10;
    float cellWidth = 0;
    float heightRatio = 1;
    
    if ([self.collectionView numberOfItemsInSection:indexPath.section] == 1) {
        cellWidth = self.view.bounds.size.width - padding*2;
        heightRatio = 0.360;
    } else {
        cellWidth = self.view.bounds.size.width / 2.0 - padding*2;
        heightRatio = (256.0/350.0);
    }
    return CGSizeMake(cellWidth, cellWidth*heightRatio);;
}

- (CGSize)headerSize {
    //we never actually show the logo if there is more than one section, so we don't need the headers to be as tall as the logo either. Ideally the height should be based on the title height; the 0.16 multiplier is for consistency with the lock icon on the meter reading screen.
    if ([self.exampleManager numberOfSections] > 1) {
        return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width*0.12);
    }
    return (self.showLogo) ? CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width*0.25) : CGSizeZero;
}

@end

