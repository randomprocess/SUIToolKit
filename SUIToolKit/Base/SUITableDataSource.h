//
//  SUITableDataSource.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/7.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+EmptyDataSet.h"
#import "SUIBaseProtocol.h"

typedef NS_ENUM(NSInteger, SUITableDataSourceType) {
    SUITableDataSourceTypeNormal          = 0,
    SUITableDataSourceTypeSearch          = 1,
    SUITableDataSourceTypeFetch           = 2,
};

@interface SUITableDataSource : NSObject <
    UITableViewDataSource,
    UITableViewDelegate,
    DZNEmptyDataSetDelegate,
    DZNEmptyDataSetSource
    >


@property (nonatomic, weak) id<SUIBaseProtocol> dataSourceDelegate;

@property (nonatomic, weak) UITableView *currTableView;



@property (nonatomic,strong) NSFetchedResultsController *currFetchedResultsController;

@property (nonatomic,strong) id scrModel;


- (SUITableDataSourceType)currDataSourceType;


- (void)resetDataAry:(NSArray *)newDataAry;

- (void)addDataAry:(NSArray *)newDataAry;

@end
