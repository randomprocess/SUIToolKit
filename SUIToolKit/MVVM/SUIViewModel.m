//
//  SUIViewModel.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIViewModel.h"
#import "UIViewController+SUIAdditions.h"
#import "UITableView+SUIToolKit.h"
#import "UITableViewCell+SUIToolKit.h"
#import "UIViewController+SUIMVVM.h"
#import "UITableViewCell+SUIMVVM.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SUIMacros.h"
#import "SUIDBHelper.h"

@interface SUIViewModel ()

@property (nullable,nonatomic,strong) id currModel;

@end

@implementation SUIViewModel

- (instancetype)initWithModel:(id)model
{
    self = [super init];
    if (self) {
        self.currModel = model;
        [self commonInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  TableView DataSource Delegate
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - TableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.sui_DBHelper) {
        return 1;
    } else {
        NSInteger curNumOfSections = tableView.sui_dataAry.count;
        return curNumOfSections;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger curNumOfRows = 0;
    if (tableView.sui_DBHelper) {
        curNumOfRows = tableView.sui_DBHelper.sui_objects.count;
    } else {
        if (tableView.sui_dataAry.count > section) {
            NSMutableArray *subDataAry = tableView.sui_dataAry[section];
            curNumOfRows = subDataAry.count;
        }
    }
    return curNumOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *curCell = nil;
    NSString *curCellIdentifier = [self sui_cellIdentifierForRowAtIndexPath:indexPath tableView:tableView];
    curCell = [tableView dequeueReusableCellWithIdentifier:curCellIdentifier];
    uAssert(curCell, @"cell if nil Identifier ⤭ %@ ⤪", curCellIdentifier);
    
    [self sui_configureCell:curCell tableView:tableView atIndexPath:indexPath];
    
    if (tableView.sui_blockForDisplayCell) {
        tableView.sui_blockForDisplayCell(curCell, indexPath);
    }
    return curCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat curHeight = 0;
    if (tableView.sui_blockForCalculateCellHeight) {
        uWeakSelf
        NSString *curCellIdentifier = [weakSelf sui_cellIdentifierForRowAtIndexPath:indexPath tableView:tableView];
        curHeight = [tableView fd_heightForCellWithIdentifier:curCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
            [weakSelf sui_configureCell:cell tableView:tableView atIndexPath:indexPath];
        }];
    } else {
        curHeight = tableView.rowHeight;
    }
    return curHeight;
}

- (void)sui_configureCell:(UITableViewCell *)cCell tableView:(UITableView *)cTableView atIndexPath:(NSIndexPath *)cIndexPath
{
    id curModel = [self currentModelAtIndexPath:cIndexPath tableView:cTableView];
    cCell.sui_md = curModel;
    cCell.sui_tableView = cTableView;
    cCell.sui_vm = self;
    
    if (cTableView.sui_blockForCalculateCellHeight) {
        cTableView.sui_blockForCalculateCellHeight(cCell, cIndexPath);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView == self.sui_vc.sui_tableView) {
        _currIndexPath = indexPath;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (id)currentModelAtIndexPath:(NSIndexPath *)cIndexPath
{
    return [self currentModelAtIndexPath:cIndexPath tableView:self.sui_vc.sui_tableView];
}

- (id)currentModelAtIndexPath:(NSIndexPath *)cIndexPath tableView:(UITableView *)cTableView
{
    if (!cTableView) return nil;
    
    if (cTableView.sui_DBHelper) {
        if (cIndexPath.section == 0) {
            if (cTableView.sui_DBHelper.sui_objects.count > cIndexPath.row) {
                id curModel = cTableView.sui_DBHelper.sui_objects[cIndexPath.row];
                return curModel;
            }
        }
    } else {
        if (cTableView.sui_dataAry.count > cIndexPath.section) {
            NSMutableArray *subDataAry = cTableView.sui_dataAry[cIndexPath.section];
            if (subDataAry.count > cIndexPath.row) {
                id curModel = subDataAry[cIndexPath.row];
                return curModel;
            }
        }
    }
    return nil;
}

- (NSString *)sui_cellIdentifierForRowAtIndexPath:(NSIndexPath *)cIndexPath tableView:(UITableView *)cTableView
{
    NSString *curCellIdentifier = nil;
    if (cTableView.sui_blockForCellIdentifier) {
        curCellIdentifier = cTableView.sui_blockForCellIdentifier(cIndexPath, [self currentModelAtIndexPath:cIndexPath tableView:cTableView]);
    }
    else
    {
        curCellIdentifier = gFormat(@"SUI%@Cell", self.sui_vc.sui_identifier);
    }
    return curCellIdentifier;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIVMDBHelperDelegate
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - SUIVMDBHelperDelegate

- (void)sui_DBHelperWillChangeContent:(SUIDBHelper *)cHelper tableView:(UITableView *)cTableView
{
    [cTableView beginUpdates];
}

- (void)sui_DBHelper:(SUIDBHelper *)cHelper didChangeObject:(__kindof SUIDBEntity *)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(SUIDBHelperChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath tableView:(UITableView *)cTableView
{    
    switch (type)
    {
        case SUIDBHelperChangeInsert:
            [cTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case SUIDBHelperChangeDelete:
            [cTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case SUIDBHelperChangeMove:
        {
            [cTableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
        }
            break;
        case SUIDBHelperChangeUpdate:
            [cTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        default:
            break;
    }
}

- (void)sui_DBHelperDidChangeContent:(SUIDBHelper *)cHelper tableView:(UITableView *)cTableView
{
    [cTableView endUpdates];
}


@end
