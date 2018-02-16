//
//  ReadingTableViewCell.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 25/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "ReadingTableViewCell.h"

@interface ReadingTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UILabel *completedOrdersLabel;
@property (strong, nonatomic) IBOutlet UIImageView *checkMarkImageView;

@end

@implementation ReadingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (UIEdgeInsets)layoutMargins{
    return UIEdgeInsetsZero;
}

+ (NSString*)reuseIdentifier{
    return @"readingCellID";
}

- (NSString *)readableStringForDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    return [formatter stringFromDate:date];
}

#pragma mark -

- (void)setReading:(Reading *)reading{
    _reading = reading;
    
    _completedOrdersLabel.hidden = YES;
    _checkMarkImageView.hidden = YES;
    
    _iconView.image = [UIImage imageNamed:@"order icon"];
    
    _titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Reading #%d", @"heading"), [reading.sort intValue]];
    
    _detailLabel.text = [self readableStringForDate:reading.readingDate];
}

- (void)setOrder:(Order *)order{
    _order = order;
    
    _completedOrdersLabel.hidden = NO;
    _checkMarkImageView.hidden = YES;
    
    _iconView.image = [UIImage imageNamed:@"order icon"];
    _titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Order #%d", @"heading"), [order.orderNr intValue]];
    _completedOrdersLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)order.completedCustomers, (unsigned long)order.customers.count];
}

- (void)setCustomer:(Customer *)customer{
    _customer = customer;
    
    _completedOrdersLabel.hidden = YES;
    _checkMarkImageView.hidden = ![customer.isCompleted boolValue];
    
    _titleLabel.text = customer.name;
    _detailLabel.text = [NSString stringWithFormat:@"# %@", customer.meterID];
    _iconView.image = [UIImage imageNamed:@"hollow person icon"];
}

@end
