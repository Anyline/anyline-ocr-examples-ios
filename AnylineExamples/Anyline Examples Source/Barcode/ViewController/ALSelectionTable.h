//
//  ALSymbologySelectionTable.h
//  AnylineExamples
//
//  Created by David Dengg on 03.12.20.
//

#import <Foundation/Foundation.h>
#import <Anyline/Anyline.h>

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol ALSelectionTableDelegate;

@interface ALSelectionTable : UITableViewController

- (instancetype)initWithSelectedItems:(NSArray<NSString*>*)selectedItems
                             allItems:(NSDictionary<NSString *,NSArray*>*)items
                         headerTitles:(NSArray<NSString *>*)headerTitles
                         defaultItems:(NSArray<NSString*>*)defaultItems
                                title:(NSString *)title 
                         singleSelect:(BOOL)singleSelect;

@property (nonatomic, weak) id<ALSelectionTableDelegate> delegate;

@end

@protocol ALSelectionTableDelegate <NSObject>

- (void)selectionTable:(ALSelectionTable *)selectionTable selectedItems:(NSArray<NSString *>*)selectedItems;

@optional
- (void)selectionTableCancelled:(ALSelectionTable *)selectionTable;

@end

NS_ASSUME_NONNULL_END
