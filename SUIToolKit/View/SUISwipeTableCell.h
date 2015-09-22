//
//  SUISwipeTableCell.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/9/22.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGSwipeTableCell.h"
#import "SUIBaseCell.h"

typedef NS_ENUM(NSInteger, SUISwipeDirection) {
    SUISwipeDirectionToRight = 0,
    SUISwipeDirectionToLeft = 1
};

typedef NSArray *(^SUISwipeTableCellButtonsBlock)(SUIBaseCell *cCell, SUISwipeDirection cDirection, MGSwipeSettings *cSwipeSettings, MGSwipeExpansionSettings *expansionSettings);
typedef BOOL (^SUISwipeTableCellDidTapBtnBlock)(SUIBaseCell *cCell, NSInteger cIndex, SUISwipeDirection cDirection);

@interface SUISwipeTableCell : NSObject <MGSwipeTableCellDelegate>

- (void)buttons:(SUISwipeTableCellButtonsBlock)cb;
- (void)didTapBtn:(SUISwipeTableCellDidTapBtnBlock)cb;

@end


@interface UITableView (SUISwipeTableCell)

@property (nonatomic,strong) SUISwipeTableCell *swipeTableCell;

@end
