//
//  ALTextViewCell.h
//  ExampleApi
//
//  Created by David Dengg on 15.02.16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALTextViewCell : UITableViewCell

- (void)updateCellWithHeader:(NSString *)header mainText:(NSString *)mainText;
- (void)appendMainText:(NSString *)mainText;
- (void)appendHyperlink:(NSString *)text link:(NSString *)hyperlink;

@end
