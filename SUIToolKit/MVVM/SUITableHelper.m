//
//  SUITableHelper.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/1/11.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUITableHelper.h"
#import "SUIUtilities.h"
#import "SUICategories.h"
#import "UITableView+SUIMVVM.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SUIViewModel.h"
#import "UITableViewCell+SUIMVVM.h"
#import "UIView+SUIMVVM.h"


@interface SUITableHelper ()

@property (nonatomic,strong) NSMutableArray<NSMutableArray *> *dataArray;

@property (nonatomic,copy) SUITableHelperCellIdentifierBlock cellIdentifierBlock;

@end

@implementation SUITableHelper


- (void)cellIdentifier:(SUITableHelperCellIdentifierBlock)cb
{
    self.cellIdentifierBlock = cb;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  TableView DataSource Delegate
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - TableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.sui_DBHelper) {
        return 1;
    } else {
        NSInteger curNumOfSections = self.dataArray.count;
        return curNumOfSections;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger curNumOfRows = 0;
    if (self.sui_DBHelper) {
        curNumOfRows = self.sui_DBHelper.sui_objects.count;
    } else {
        if (self.dataArray.count > section) {
            NSMutableArray *subDataAry = self.dataArray[section];
            curNumOfRows = subDataAry.count;
        }
    }
    return curNumOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *curCell = nil;
    id curModel = [self currentModelAtIndexPath:indexPath];
    NSString *curCellIdentifier = [self cellIdentifierForRowAtIndexPath:indexPath model:curModel];
    curCell = [tableView dequeueReusableCellWithIdentifier:curCellIdentifier];
    uAssert(curCell, @"cell if nil Identifier ⤭ %@ ⤪", curCellIdentifier);
    
    [self sui_configureCell:curCell tableView:tableView atIndexPath:indexPath];
    
    if ([curCell respondsToSelector:@selector(sui_willDisplayWithViewModel:)]) {
        [curCell sui_willDisplayWithViewModel:curCell.sui_vm];
    }
    return curCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat curHeight = 0;
    if (tableView.sui_calculateCellHeight) {
        uWeakSelf
        id curModel = [self currentModelAtIndexPath:indexPath];
        NSString *curCellIdentifier = [self cellIdentifierForRowAtIndexPath:indexPath model:curModel];
        curHeight = [tableView fd_heightForCellWithIdentifier:curCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
            [weakSelf sui_configureCell:cell tableView:tableView atIndexPath:indexPath];
        }];
    } else {
        curHeight = tableView.rowHeight;
    }
    return curHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    self.sui_indexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  ViewModelHandler
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - ViewModelHandler

- (NSString *)cellIdentifierForRowAtIndexPath:(NSIndexPath *)cIndexPath model:(id)model
{
    NSString *curCellIdentifier = nil;
    if (self.cellIdentifierBlock) {
        curCellIdentifier = self.cellIdentifierBlock(cIndexPath, model);
    }
//    else {
//        NSString *curClassName = NSStringFromClass([cVM class]);
//        curCellIdentifier = [curClassName sui_regex:@"\\S+(?=VM$)"];
//    }
    return curCellIdentifier;
}

- (id)currentModel
{
    return [self currentModelAtIndexPath:self.sui_indexPath];
}

- (id)currentModelAtIndexPath:(NSIndexPath *)cIndexPath
{
    if (self.sui_DBHelper) {
        if (cIndexPath.section == 0) {
            if (self.sui_DBHelper.sui_objects.count > cIndexPath.row) {
                id curModel = self.sui_DBHelper.sui_objects[cIndexPath.row];
                return curModel;
            }
        }
    } else {
        if (self.dataArray.count > cIndexPath.section) {
            NSMutableArray *subDataAry = self.dataArray[cIndexPath.section];
            if (subDataAry.count > cIndexPath.row) {
                id curModel = subDataAry[cIndexPath.row];
                return curModel;
            }
        }
    }
    return nil;
}

- (void)sui_configureCell:(UITableViewCell *)cCell tableView:(UITableView *)cTableView atIndexPath:(NSIndexPath *)cIndexPath
{
    id model = [self currentModelAtIndexPath:cIndexPath];
    cCell.sui_tableView = cTableView;
    [cCell.sui_vm bindModel:model];
    
    if ([cCell respondsToSelector:@selector(sui_willCalculateHeightWithViewModel:)]) {
        [cCell sui_willCalculateHeightWithViewModel:cCell.sui_vm];
    }    
}


- (void)resetDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection
{
    if (newDataAry.count == 0) return;
    uMainQueue
    (
     [self sui_makeUpDataAryForSection:cSection];
     
     NSMutableArray *subAry = self.dataArray[cSection];
     if (subAry.count) [subAry removeAllObjects];
     [subAry addObjectsFromArray:newDataAry];
     [self.sui_tableView reloadData];
     )
}
- (void)reloadDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection
{
    if (newDataAry.count == 0) return;
    uMainQueue
    (
     NSIndexSet *curIndexSet = [self sui_makeUpDataAryForSection:cSection];
     NSMutableArray *subAry = self.dataArray[cSection];
     if (subAry.count) [subAry removeAllObjects];
     [subAry addObjectsFromArray:newDataAry];
     
     [self.sui_tableView beginUpdates];
     if (curIndexSet) {
         [self.sui_tableView insertSections:curIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
     } else {
         [self.sui_tableView reloadSections:[NSIndexSet indexSetWithIndex:cSection] withRowAnimation:UITableViewRowAnimationNone];
     }
     [self.sui_tableView endUpdates];
     )
}
- (void)addDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection
{
    if (newDataAry.count == 0) return;
    uMainQueue
    (
     NSIndexSet *curIndexSet = [self sui_makeUpDataAryForSection:cSection];
     NSMutableArray *subAry = self.dataArray[cSection];
     if (curIndexSet) {
         [subAry addObjectsFromArray:newDataAry];
         [self.sui_tableView beginUpdates];
         [self.sui_tableView insertSections:curIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
         [self.sui_tableView endUpdates];
     } else {
         __block NSMutableArray *curIndexPaths = [NSMutableArray arrayWithCapacity:newDataAry.count];
         [newDataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [curIndexPaths addObject:[NSIndexPath indexPathForRow:subAry.count+idx inSection:cSection]];
         }];
         [subAry addObjectsFromArray:newDataAry];
         [self.sui_tableView beginUpdates];
         [self.sui_tableView insertRowsAtIndexPaths:curIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
         [self.sui_tableView endUpdates];
     }
     )
}
- (void)insertData:(id)cModel AtIndex:(NSIndexPath *)cIndexPath;
{
    uMainQueue
    (
     NSIndexSet *curIndexSet = [self sui_makeUpDataAryForSection:cIndexPath.section];
     NSMutableArray *subAry = self.dataArray[cIndexPath.section];
     if (subAry.count < cIndexPath.row) return;
     [subAry insertObject:cModel atIndex:cIndexPath.row];
     if (curIndexSet) {
         [self.sui_tableView beginUpdates];
         [self.sui_tableView insertSections:curIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
         [self.sui_tableView endUpdates];
     } else {
         [subAry insertObject:cModel atIndex:cIndexPath.row];
         [self.sui_tableView beginUpdates];
         [self.sui_tableView insertRowsAtIndexPaths:@[cIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
         [self.sui_tableView endUpdates];
     }
     )
}
- (void)deleteDataAtIndex:(NSIndexPath *)cIndexPath
{
    uMainQueue
    (
     if (self.dataArray.count <= cIndexPath.section) return;
     NSMutableArray *subAry = self.dataArray[cIndexPath.section];
     if (subAry.count <= cIndexPath.row) return;
     
     [subAry removeObjectAtIndex:cIndexPath.row];
     [self.sui_tableView beginUpdates];
     [self.sui_tableView deleteRowsAtIndexPaths:@[cIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
     [self.sui_tableView endUpdates];
     )
}

- (NSIndexSet *)sui_makeUpDataAryForSection:(NSInteger)cSection
{
    NSMutableIndexSet *curIndexSet = nil;
    if (self.dataArray.count <= cSection) {
        curIndexSet = [NSMutableIndexSet indexSet];
        for (NSInteger idx=0; idx<(cSection-self.dataArray.count+1); idx++) {
            NSMutableArray *subAry = [NSMutableArray array];
            [self.dataArray addObject:subAry];
            [curIndexSet addIndex:cSection-idx];
        }
    }
    return curIndexSet;
}


- (NSMutableArray<NSMutableArray *> *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

@end


@implementation UITableView (SUITableExten)

- (SUITableHelper *)sui_tableHelper
{
    SUITableHelper * curTableHelper = objc_getAssociatedObject(self, @selector(sui_tableHelper));
    if (curTableHelper) return curTableHelper;
    
    curTableHelper = [SUITableHelper new];
    self.sui_tableHelper = curTableHelper;
    return curTableHelper;
}
- (void)setSui_tableHelper:(SUITableHelper *)sui_tableHelper
{
    sui_tableHelper.sui_tableView = self;
    self.delegate = sui_tableHelper;
    self.dataSource = sui_tableHelper;
    objc_setAssociatedObject(self, @selector(sui_tableHelper), sui_tableHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIDBHelper
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@implementation SUITableHelper (SUIDBHelper)

- (SUIDBHelper *)sui_DBHelper
{
    return [self sui_getAssociatedObjectWithKey:@selector(sui_DBHelper)];
}

- (void)sui_DBHelperWithClass:(Class)modelClass
{
    [self sui_DBHelperWithClass:modelClass where:nil orderBy:nil];
}
- (void)sui_DBHelperWithClass:(Class)modelClass where:(id)searchTerm
{
    [self sui_DBHelperWithClass:modelClass where:searchTerm orderBy:nil];
}
- (void)sui_DBHelperWithClass:(Class)modelClass where:(id)searchTerm orderBy:(NSString *)orderTerm
{
    [self sui_DBHelperWithClass:modelClass where:searchTerm orderBy:orderTerm offset:0 count:0];
}
- (void)sui_DBHelperWithClass:(Class)modelClass where:(nullable id)searchTerm orderBy:(nullable NSString *)orderTerm offset:(NSInteger)offset count:(NSInteger)count
{
    SUIDBHelper *curHelper = [[SUIDBHelper alloc] initWithClass:modelClass where:searchTerm orderBy:orderTerm offset:offset count:count delegate:self];
    [self sui_setAssociatedObject:curHelper key:@selector(sui_DBHelper) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIVMDBHelperDelegate
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - SUIVMDBHelperDelegate

- (void)sui_DBHelperWillChangeContent:(SUIDBHelper *)cHelper
{
    [self.sui_tableView beginUpdates];
}

- (void)sui_DBHelper:(SUIDBHelper *)cHelper didChangeObject:(__kindof SUIDBEntity *)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(SUIDBHelperChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type)
    {
        case SUIDBHelperChangeInsert:
        {
            [self.sui_tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
        case SUIDBHelperChangeDelete:
            [self.sui_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case SUIDBHelperChangeMove:
            [self.sui_tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        case SUIDBHelperChangeUpdate:
            [self.sui_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case SUIDBHelperChangeReload:
            [self.sui_tableView reloadData];
            break;
        default:
            break;
    }
}

- (void)sui_DBHelperDidChangeContent:(SUIDBHelper *)cHelper
{
    [self.sui_tableView endUpdates];
}


@end
