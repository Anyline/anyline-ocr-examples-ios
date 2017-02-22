//
//  ALISBNHeaderCell.h
//  ExampleApi
//
//  Created by David Dengg on 15.02.16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALISBNHeaderCell : UITableViewCell
/*
 * Update the cells information
 */
- (void)updateCellWithTitle:(NSString *)title
                     author:(NSString *)author
                  publisher:(NSString *)publisher
                       year:(NSString *)year
              thumbnailLink:(NSString *)thumbnailLink;


// Return the height of the cell
- (CGFloat)cellHeight;
+ (CGFloat)cellHeight;

@end
