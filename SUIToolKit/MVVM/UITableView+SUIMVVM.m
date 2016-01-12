//
//  UITableView+SUIMVVM.m
//  SUIToolKitDemo
//
//  Created by zzZ on 16/1/5.
//  Copyright © 2016年 SUIO~. All rights reserved.
//

#import "UITableView+SUIMVVM.h"
#import "NSObject+SUIAdditions.h"
#import "SUITableHelper.h"

@implementation UITableView (SUIMVVM)

- (BOOL)sui_calculateCellHeight
{
    return [[self sui_getAssociatedObjectWithKey:@selector(sui_calculateCellHeight)] boolValue];
}
- (void)setSui_calculateCellHeight:(BOOL)sui_calculateCellHeight
{
    [self sui_setAssociatedObject:@(sui_calculateCellHeight) key:@selector(sui_calculateCellHeight) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (void)sui_resetDataAry:(NSArray *)newDataAry
{
    [self sui_resetDataAry:newDataAry forSection:0];
}
- (void)sui_resetDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection
{
    [self.sui_tableHelper resetDataAry:newDataAry forSection:cSection];
}
- (void)sui_reloadDataAry:(NSArray *)newDataAry
{
    [self sui_reloadDataAry:newDataAry forSection:0];
}
- (void)sui_reloadDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection
{
    [self.sui_tableHelper reloadDataAry:newDataAry forSection:cSection];
}
- (void)sui_addDataAry:(NSArray *)newDataAry
{
    [self sui_addDataAry:newDataAry forSection:0];
}
- (void)sui_addDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection
{
    [self.sui_tableHelper addDataAry:newDataAry forSection:cSection];
}
- (void)sui_insertData:(id)cModel AtIndex:(NSIndexPath *)cIndexPath;
{
    [self.sui_tableHelper insertData:cModel AtIndex:cIndexPath];
}
- (void)sui_deleteDataAtIndex:(NSIndexPath *)cIndexPath
{
    [self.sui_tableHelper deleteDataAtIndex:cIndexPath];
}


@end
