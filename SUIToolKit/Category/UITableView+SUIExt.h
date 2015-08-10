//
//  UITableView+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/7.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUITableDataSource.h"

@interface UITableView (SUIExt)


@property (nonatomic,strong) SUITableDataSource *currDataSource;


@property (nonatomic,assign) BOOL loadMoreData;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageIndex;


- (void)addRefreshHeader;
- (void)headerRefreshSteart;
- (void)addRefreshFooter;
- (void)hideRefreshFooter:(BOOL)hidden;
- (void)headerRefreshStop;
- (void)footerRefreshStop;


- (void)refreshTable:(NSArray *)newDataAry;


@end
