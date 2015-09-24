//
//  SUIBaseCell.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/29.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@class SUIBaseCell;

typedef NS_ENUM(NSInteger, SUISwipeDirection) {
    SUISwipeDirectionToRight = 0,
    SUISwipeDirectionToLeft = 1
};

typedef NSArray *(^SUISwipeTableCellButtonsBlock)(SUIBaseCell *cCell, SUISwipeDirection cDirection, MGSwipeSettings *cSwipeSettings, MGSwipeExpansionSettings *expansionSettings);
typedef BOOL (^SUISwipeTableCellDidTapBtnBlock)(SUIBaseCell *cCell, NSInteger cIndex, SUISwipeDirection cDirection);


@interface SUIBaseCell : MGSwipeTableCell

@property (nonatomic,strong) id currModle;

@property (nonatomic,weak) UITableView *currTableView;


/**
 *  需要计算动态高度时, 影响cell高度的代码写在子类重写的这个方法内
 */
- (void)displayWithCalculateCellHeight:(id)cModel;

/**
 *  需要计算动态高度时, 不影响cell高度的代码写在子类重写的这个方法内
 *  不需要计算动态高度, 则全部写在重写的这个方法中
 */
- (void)displayWithCurrModel:(id)cModel;

@end


@interface SUISwipeTableCell : NSObject <MGSwipeTableCellDelegate>

- (void)buttons:(SUISwipeTableCellButtonsBlock)cb; // 返回@[UIButton]
- (void)didTapBtn:(SUISwipeTableCellDidTapBtnBlock)cb;

@end


@interface UITableView (SUISwipeTableCell)

@property (nonatomic,strong) SUISwipeTableCell *swipeTableCell;

@end
