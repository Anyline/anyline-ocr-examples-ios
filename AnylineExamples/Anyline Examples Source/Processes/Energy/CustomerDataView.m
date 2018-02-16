//
//  CustomerDataView.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 27/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "CustomerDataView.h"
#import "Reading.h"

static NSString * const kMainKey =                      @"main";
static NSString * const kIconKey =                      @"icon";

@interface CustomerDataView()

@property (weak, nonatomic) IBOutlet UILabel            *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel            *customerIDLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *customerIDIconImageView;
@property (weak, nonatomic) IBOutlet UILabel            *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *addressIconImageView;
@property (weak, nonatomic) IBOutlet UILabel            *readingValueBigLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *readingValueBigIconImageView;
@property (weak, nonatomic) IBOutlet UILabel            *readingValueSmallLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *readingValueSmallIconImageView;
@property (weak, nonatomic) IBOutlet UILabel            *readingDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *readingDateIconImageView;
@property (weak, nonatomic) IBOutlet UIView             *notesContainerView;
@property (weak, nonatomic) IBOutlet UILabel            *notesLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *notesIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *readingImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *readingImageIconImageView;
@property (weak, nonatomic) IBOutlet UIButton           *notesEditButton;
@property (weak, nonatomic) IBOutlet UIView             *facetsContainerView;

@property (assign, nonatomic) BOOL                      facetsConfigured;

@end

@implementation CustomerDataView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setFacets:(CustomerDataFacet)facets {
    if (self.facetsConfigured) @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Facets can only be configured once, to change them you will need to re-allocated a new instance of this view." userInfo:nil];
    self.facetsConfigured = YES;
    
    _facets = facets;
    
    // take care of hiding and showing the facets as well as autolayout
    [self _showFacets:facets];
}

- (void)_showFacets:(CustomerDataFacet)facets {
    NSDictionary *facetMapping = @{
        @(CustomerDataFacetCustomerID):         @{kMainKey: self.customerIDLabel,           kIconKey: self.customerIDIconImageView},
        @(CustomerDataFacetAddress):            @{kMainKey: self.addressLabel,              kIconKey: self.addressIconImageView},
        @(CustomerDataFacetReadingValueBig):    @{kMainKey: self.readingValueBigLabel,      kIconKey: self.readingValueBigIconImageView},
        @(CustomerDataFacetReadingValueSmall):  @{kMainKey: self.readingValueSmallLabel,    kIconKey: self.readingValueSmallIconImageView},
        @(CustomerDataFacetReadingDate):        @{kMainKey: self.readingDateLabel,          kIconKey: self.readingDateIconImageView},
        @(CustomerDataFacetReadingImage):       @{kMainKey: self.readingImageView,          kIconKey: self.readingImageIconImageView},
    };
    
    // take care of visibility...
    for (NSNumber *facet in facetMapping.allKeys) {
        // first we need to know if this facet should be shown or not
        BOOL showFacet = facets & facet.integerValue;
        
        // let's get our relevant views for the facet
        UIView *mainView = facetMapping[facet][kMainKey];
        UIView *iconView = facetMapping[facet][kIconKey];
        
        // remove the views which we don't need
        if (!showFacet) for (UIView *view in @[mainView, iconView]) { [view removeFromSuperview]; }
    }
}

- (void)setCustomer:(Customer *)customer{
    _customer = customer;
    
    Reading *lastReading = customer.lastReading;
    
    self.customerNameLabel.text = customer.name;
    self.customerIDLabel.text = [NSString stringWithFormat:@"# %@", customer.meterID];
    self.addressLabel.text = customer.address;
    self.readingValueSmallLabel.text = lastReading.localizedReadingValue;
    self.readingValueBigLabel.text = lastReading.localizedReadingValue;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    self.readingDateLabel.text = [formatter stringFromDate:lastReading.readingDate];
    
    self.notesLabel.text = customer.notes;

    if (lastReading.scannedImage && (self.facets & CustomerDataFacetReadingImage)) {
        UIImage *readingImage = lastReading.scannedImage;
        self.readingImageView.image = readingImage;
        
        // set the scanned image, and manage the autolayout aspect ratio sizing
//        [self.readingImageView.constraints autoRemoveConstraints];
        CGFloat imageAspectRatio = readingImage.size.width / readingImage.size.height;
        [self.readingImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.readingImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.readingImageView attribute:NSLayoutAttributeHeight multiplier:imageAspectRatio constant:0]];
    }
}

- (IBAction)editAction:(id)sender {
    if (self.notesEditRequestBlock) {
        self.notesEditRequestBlock();
    }
}

@end
