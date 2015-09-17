//
//  SUIEmptyDataSet.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/9/15.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+EmptyDataSet.h"


typedef NSAttributedString *(^SUIEmptyDataSetTitleBlock)(void);
typedef NSAttributedString *(^SUIEmptyDataSetDesBlock)(void);
typedef UIImage *(^SUIEmptyDataSetImageBlock)(void);
typedef UIView *(^SUIEmptyDataSetCustomViewBlock)(void);
typedef BOOL (^SUIEmptyDataSetShouldDisplayBlock)(void);
typedef BOOL (^SUIEmptyDataSetShouldAllowTouchBlock)(void);
typedef BOOL (^SUIEmptyDataSetShouldAllowScrollBlock)(void);
typedef void (^SUIEmptyDataSetDidTapViewBlock)(void);

@interface SUIEmptyDataSet : NSObject <
    DZNEmptyDataSetDelegate,
    DZNEmptyDataSetSource
    >

- (void)title:(SUIEmptyDataSetTitleBlock)cb;
- (void)des:(SUIEmptyDataSetDesBlock)cb;
- (void)image:(SUIEmptyDataSetImageBlock)cb;
- (void)customView:(SUIEmptyDataSetCustomViewBlock)cb;
- (void)shouldDisplay:(SUIEmptyDataSetShouldDisplayBlock)cb;
- (void)shouldAllowTouch:(SUIEmptyDataSetShouldAllowTouchBlock)cb;
- (void)shouldAllowScroll:(SUIEmptyDataSetShouldAllowScrollBlock)cb;
- (void)didTapView:(SUIEmptyDataSetDidTapViewBlock)cb;

@end


@interface UIScrollView (SUIEmptyDataSet)

@property (nonatomic) IBInspectable BOOL addEmptyDataSet;
@property (nonatomic,strong) SUIEmptyDataSet *emptyDataSet;

@end
