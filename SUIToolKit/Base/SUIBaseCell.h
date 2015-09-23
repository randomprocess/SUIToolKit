//
//  SUIBaseCell.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/29.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"


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
