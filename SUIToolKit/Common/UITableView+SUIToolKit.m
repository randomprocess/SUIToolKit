//
//  UITableView+SUIToolKit.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/21.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "UITableView+SUIToolKit.h"
#import "NSObject+SUIAdditions.h"
#import "SUIMacros.h"

@implementation UITableView (SUIToolKit)


- (NSMutableArray *)sui_dataAry
{
    NSMutableArray *curDataAry = [self sui_getAssociatedObjectWithKey:@selector(sui_dataAry)];
    if (curDataAry) return curDataAry;
    
    curDataAry = [NSMutableArray array];
    self.sui_dataAry = curDataAry;
    return curDataAry;
}
- (void)setSui_dataAry:(NSMutableArray *)sui_dataAry
{
    [self sui_setAssociatedObject:sui_dataAry key:@selector(sui_dataAry) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}


- (void)sui_willCalculateCellHeight:(SUITableViewCalculateCellHeightBlock)cb
{
    self.sui_blockForCalculateCellHeight = cb;
}
- (void)sui_willDisplayCell:(SUITableViewDisplayCellBlock)cb
{
    self.sui_blockForDisplayCell = cb;
}
- (void)sui_cellIdentifier:(SUITableViewCellIdentifierBlock)cb
{
    self.sui_blockForCellIdentifier = cb;
}


- (void)sui_resetDataAry:(NSArray *)newDataAry
{
     [self sui_resetDataAry:newDataAry forSection:0];
}
- (void)sui_resetDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection
{
    if (newDataAry.count == 0) return;
    uMainQueue
    (
     [self sui_makeUpDataAryForSection:cSection];
     
     NSMutableArray *subAry = self.sui_dataAry[cSection];
     if (subAry.count) [subAry removeAllObjects];
     [subAry addObjectsFromArray:newDataAry];
     [self reloadData];
     )
}
- (void)sui_reloadDataAry:(NSArray *)newDataAry
{
    [self sui_reloadDataAry:newDataAry forSection:0];
}
- (void)sui_reloadDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection
{
    if (newDataAry.count == 0) return;
    uMainQueue
    (
     NSIndexSet *curIndexSet = [self sui_makeUpDataAryForSection:cSection];
     NSMutableArray *subAry = self.sui_dataAry[cSection];
     if (subAry.count) [subAry removeAllObjects];
     [subAry addObjectsFromArray:newDataAry];
     
     [self beginUpdates];
     if (curIndexSet) {
         [self insertSections:curIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
     } else {
         [self reloadSections:[NSIndexSet indexSetWithIndex:cSection] withRowAnimation:UITableViewRowAnimationNone];
     }
     [self endUpdates];
     )
}
- (void)sui_addDataAry:(NSArray *)newDataAry
{
    [self sui_addDataAry:newDataAry forSection:0];
}
- (void)sui_addDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection
{
    if (newDataAry.count == 0) return;
    uMainQueue
    (
     NSIndexSet *curIndexSet = [self sui_makeUpDataAryForSection:cSection];
     NSMutableArray *subAry = self.sui_dataAry[cSection];
     if (curIndexSet) {
         [subAry addObjectsFromArray:newDataAry];
         [self beginUpdates];
         [self insertSections:curIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
         [self endUpdates];
     } else {
         __block NSMutableArray *curIndexPaths = [NSMutableArray arrayWithCapacity:newDataAry.count];
         [newDataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [curIndexPaths addObject:[NSIndexPath indexPathForRow:subAry.count+idx inSection:cSection]];
         }];
         [subAry addObjectsFromArray:newDataAry];
         [self beginUpdates];
         [self insertRowsAtIndexPaths:curIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
         [self endUpdates];
     }
     )
}
- (void)sui_insertData:(id)cModel AtIndex:(NSIndexPath *)cIndexPath;
{
    uMainQueue
    (
     NSIndexSet *curIndexSet = [self sui_makeUpDataAryForSection:cIndexPath.section];
     NSMutableArray *subAry = self.sui_dataAry[cIndexPath.section];
     if (subAry.count < cIndexPath.row) return;
     [subAry insertObject:cModel atIndex:cIndexPath.row];
     if (curIndexSet) {
         [self beginUpdates];
         [self insertSections:curIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
         [self endUpdates];
     } else {
         [subAry insertObject:cModel atIndex:cIndexPath.row];
         [self beginUpdates];
         [self insertRowsAtIndexPaths:@[cIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
         [self endUpdates];
     }
     )
}
- (void)sui_deleteDataAtIndex:(NSIndexPath *)cIndexPath
{
    uMainQueue
    (
     if (self.sui_dataAry.count <= cIndexPath.section) return;
     NSMutableArray *subAry = self.sui_dataAry[cIndexPath.section];
     if (subAry.count <= cIndexPath.row) return;
     
     [subAry removeObjectAtIndex:cIndexPath.row];
     [self beginUpdates];
     [self deleteRowsAtIndexPaths:@[cIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
     [self endUpdates];
     )
}

- (NSIndexSet *)sui_makeUpDataAryForSection:(NSInteger)cSection
{
    NSMutableIndexSet *curIndexSet = nil;
    if (self.sui_dataAry.count <= cSection) {
        curIndexSet = [NSMutableIndexSet indexSet];
        for (NSInteger idx=0; idx<(cSection-self.sui_dataAry.count+1); idx++) {
            NSMutableArray *subAry = [NSMutableArray array];
            [self.sui_dataAry addObject:subAry];
            [curIndexSet addIndex:cSection-idx];
        }
    }
    return curIndexSet;
}


- (SUITableViewCalculateCellHeightBlock)sui_blockForCalculateCellHeight
{
    return [self sui_getAssociatedObjectWithKey:@selector(sui_blockForCalculateCellHeight)];
}
- (void)setSui_blockForCalculateCellHeight:(SUITableViewCalculateCellHeightBlock)sui_blockForCalculateCellHeight
{
    [self sui_setAssociatedObject:sui_blockForCalculateCellHeight key:@selector(sui_blockForCalculateCellHeight) policy:OBJC_ASSOCIATION_COPY];
}

- (SUITableViewDisplayCellBlock)sui_blockForDisplayCell
{
    return [self sui_getAssociatedObjectWithKey:@selector(sui_blockForDisplayCell)];
}
- (void)setSui_blockForDisplayCell:(SUITableViewDisplayCellBlock)sui_blockForDisplayCell
{
    [self sui_setAssociatedObject:sui_blockForDisplayCell key:@selector(sui_blockForDisplayCell) policy:OBJC_ASSOCIATION_COPY];
}

- (SUITableViewCellIdentifierBlock)sui_blockForCellIdentifier
{
    return [self sui_getAssociatedObjectWithKey:@selector(sui_blockForCellIdentifier)];
}
- (void)setSui_blockForCellIdentifier:(SUITableViewCellIdentifierBlock)sui_blockForCellIdentifier
{
    [self sui_setAssociatedObject:sui_blockForCellIdentifier key:@selector(sui_blockForCellIdentifier) policy:OBJC_ASSOCIATION_COPY];
}


@end
