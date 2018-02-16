//
//  ReadingTableViewCell.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 25/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"

#import "Order.h"
#import "Customer.h"
#import "Reading.h"

@interface ReadingTableViewCell : UITableViewCell

@property (nonatomic, strong) Reading *reading;
@property (nonatomic, strong) Order *order;
@property (nonatomic, strong) Customer *customer;

+ (NSString*)reuseIdentifier;

@end
