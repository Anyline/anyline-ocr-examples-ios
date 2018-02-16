//
//  CustomerDataView.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 27/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"

typedef NS_OPTIONS(NSInteger, CustomerDataFacet) {
    CustomerDataFacetCustomerID         = (1 << 0),
    CustomerDataFacetAddress            = (1 << 1),
    CustomerDataFacetReadingValueBig    = (1 << 2),
    CustomerDataFacetReadingValueSmall  = (1 << 3),
    CustomerDataFacetReadingDate        = (1 << 4),
    CustomerDataFacetNotes              = (1 << 5),
    CustomerDataFacetReadingImage       = (1 << 6),
};

typedef void(^CustomerDataViewNotesEditReqeustedBlock)(void);

@interface CustomerDataView : UIView

@property (nonatomic, copy) CustomerDataViewNotesEditReqeustedBlock     notesEditRequestBlock;

/**
 A bitmask of CustomerDataFacets to display
 */
@property (nonatomic, assign) CustomerDataFacet                         facets;

@property (nonatomic, strong) Customer                                  *customer;

@end
