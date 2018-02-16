//
//  ALScanResultViewController.m
//  eScan
//
//  Created by Daniel Albertini on 01/02/15.
//  Copyright (c) 2015 Daniel Albertini. All rights reserved.
//

#import "ALScanResultViewController.h"

//#import "ScanYourMeterViewController.h"

#import "ALMeterReading.h"
#import "ALMeterReadingView.h"
#import "ALUtils.h"

//#import <BFRImageViewer/BFRImageViewController.h>

@interface ALScanResultViewController ()

@property (weak, nonatomic) IBOutlet UIImageView                        *scannedImageImageView;
@property (weak, nonatomic) IBOutlet UIImageView                        *meterOverlayImageView;

@property (weak, nonatomic) IBOutlet UIView                             *meterReadingContainerView;

@property (strong, nonatomic, readwrite) ALMeterReading                 *originalMeterReading;
@property (strong, nonatomic) ALMeterReadingView                        *meterReadingView;
@property (assign, nonatomic) BOOL                                      editingMode;

@end

@implementation ALScanResultViewController

#pragma mark - Custom Accessors

- (ALMeterReading *)meterReading {
    return self.meterReadingView.meterReading;
}

- (void)setMeterReading:(ALMeterReading *)meterReading {
    self.meterReadingView.meterReading = meterReading;
}

#pragma mark - Public

- (instancetype)initWithMeterReading:(ALMeterReading *)meterReading editingMode:(BOOL)editingMode {
    if (self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil]) {
        self.originalMeterReading = meterReading;
        self.editingMode = editingMode;
    }
    
    return self;
}

#pragma mark - Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // some UI prep
    self.scannedImageImageView.layer.cornerRadius = 4;
    
    // set the cap insets for the meter overlay image
    self.meterOverlayImageView.image = [self.meterOverlayImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    
    // add our ALMeterReadingView
    self.meterReadingContainerView.backgroundColor = [UIColor clearColor];
    ALMeterReadingView *meterReadingView = TranslateAutoresizing([[ALMeterReadingView alloc] initWithMeterReading:self.originalMeterReading]);
    
    [self.meterReadingContainerView addSubview:meterReadingView];
    [self.meterReadingContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[meterReadingView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(meterReadingView)]];// full width
    [self.meterReadingContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[meterReadingView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(meterReadingView)]];// full height
    self.meterReadingView = meterReadingView;
    
    // set the scanned image, and manage the autolayout aspect ratio sizing
    self.scannedImageImageView.image = self.originalMeterReading.image;
    CGFloat imageAspectRatio = self.originalMeterReading.image.size.width / self.originalMeterReading.image.size.height;
    [self.scannedImageImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.scannedImageImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scannedImageImageView attribute:NSLayoutAttributeHeight multiplier:imageAspectRatio constant:0]];
    
    // set the initial mode to be ModeView
    [self.meterReadingView setEditingMode:self.editingMode animated:NO];
}

#pragma mark - Button Actions

/**
 *  Called when full screen button is tapped
 *  Opens up a fullscreen image preview vc
 */
- (IBAction)showFullscreenResultAction:(id)sender {
}

@end
