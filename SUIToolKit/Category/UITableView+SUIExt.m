//
//  UITableView+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/7.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UITableView+SUIExt.h"
#import <objc/runtime.h>
#import "MJRefresh.h"
#import "SUIBaseConfig.h"

@implementation UITableView (SUIExt)


- (SUITableDataSource *)currDataSource
{
    SUITableDataSource *curDataSource = objc_getAssociatedObject(self, @selector(currDataSource));
    if (curDataSource == nil) {
        curDataSource = [SUITableDataSource new];
        curDataSource.currTableView = self;
        self.currDataSource = curDataSource;
    }
    return curDataSource;
}
- (void)setCurrDataSource:(SUITableDataSource *)currDataSource
{
    objc_setAssociatedObject(self, @selector(currDataSource), currDataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)loadMoreData
{
    return [objc_getAssociatedObject(self, @selector(loadMoreData)) boolValue];
}
- (void)setLoadMoreData:(BOOL)loadMoreData
{
    objc_setAssociatedObject(self, @selector(loadMoreData), @(loadMoreData), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)pageSize
{
    NSInteger curPageSize = [objc_getAssociatedObject(self, @selector(pageSize)) integerValue];
    if (curPageSize == 0)
    {
        curPageSize = [SUIBaseConfig sharedConfig].pageSize;
    }
    self.pageSize = curPageSize;
    return curPageSize;
}
- (void)setPageSize:(NSInteger)pageSize
{
    objc_setAssociatedObject(self, @selector(pageSize), @(pageSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)pageIndex
{
    return [objc_getAssociatedObject(self, @selector(pageIndex)) integerValue];
}
- (void)setPageIndex:(NSInteger)pageIndex
{
    objc_setAssociatedObject(self, @selector(pageIndex), @(pageIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)addRefreshHeader
{
    if (self.header == nil) {
        [self addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(handlerLoadLastData)];
    }
}
- (void)headerRefreshSteart
{
    if (self.header != nil) {
        [self.header beginRefreshing];
    }
}

- (void)addRefreshFooter
{
    if (self.footer == nil) {
        [self addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(handlerLoadMoreData)];
    }
}

- (void)hideRefreshFooter:(BOOL)hidden
{
    if (self.header != nil) {
        self.footer.hidden = hidden;
    }
}

- (void)headerRefreshStop
{
    if (self.header != nil) {
        [self.header endRefreshing];
    }
}
- (void)footerRefreshStop
{
    if (self.footer != nil) {
        [self.footer endRefreshing];
    }
}


- (void)handlerLoadLastData
{
    self.loadMoreData = NO;
    self.pageIndex = 0;
    [self.currDataSource.dataSourceDelegate handlerMainRequest:NO];
}
- (void)handlerLoadMoreData
{
    self.loadMoreData = YES;
    [self.currDataSource.dataSourceDelegate handlerMainRequest:YES];
}


- (void)refreshTable:(NSArray *)newDataAry
{
    if (newDataAry.count > 0)
    {
        if ([self.currDataSource.dataSourceDelegate addFooter])
        {
            NSInteger curDataCount = 0;
            for (NSArray *curSubAry in newDataAry) {
                curDataCount = MAX(curDataCount, curSubAry.count);
            }
            
            if (curDataCount < self.pageSize) {
                if (!self.footer.hidden) {
                    self.footer.hidden = YES;
                }
            }  else if (curDataCount > 0) {
                self.pageIndex ++;
                if (self.footer.hidden) {
                    self.footer.hidden = NO;
                }
            }
        }
        
        if ([self.currDataSource currDataSourceType] != SUITableDataSourceTypeFetch)
        {
            (self.loadMoreData) ? [self.currDataSource addDataAry:newDataAry] : [self.currDataSource resetDataAry:newDataAry];
        }
    }
}


@end
