//
//  SUIDataSource.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIDataSource.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MJRefresh.h"
#import "SUIHttpClient.h"

@interface SUIDataSource () <NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic,strong) NSMutableArray *currDataAry;

@property (nonatomic,strong) NSIndexPath *currIndexPath;

@property (nonatomic,strong) NSArray *currCellIdentifier;

@property (nonatomic,weak) NSURLSessionDataTask *currTask;

@property (nonatomic,assign,getter=loadMoreData) BOOL isLoadMoreData;

@end

@implementation SUIDataSource


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController.sections.count;
    }
    return self.currDataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_fetchedResultsController != nil)
    {
        id<NSFetchedResultsSectionInfo> sectionInfo = _fetchedResultsController.sections[section];
        return [sectionInfo numberOfObjects];
    }
    NSInteger numOfRows = [self.currDataAry[section] count];
    return numOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *currConfig = [self configureCell:indexPath];
    SUIBaseCell *currCell = [tableView dequeueReusableCellWithIdentifier:currConfig[0] forIndexPath:indexPath];
    currCell.cellActionDelegate = self.dataSourceDelegate;
    currCell.currModle = currConfig[1];
    [currCell displayWithCalculateCellHeight];
    [currCell displayWithCurrModel];
    return currCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *currConfig = [self configureCell:indexPath];
    return [tableView fd_heightForCellWithIdentifier:currConfig[0] cacheByIndexPath:indexPath configuration:^(id cell) {
        SUIBaseCell *curCell = (SUIBaseCell *)cell;
        curCell.currModle = currConfig[1];
        [curCell displayWithCalculateCellHeight];
    }];
}

- (NSArray *)configureCell:(NSIndexPath *)indexPath
{
    NSArray *curCellIdentifierSection = self.currCellIdentifier[indexPath.section];
    NSString *curCellIdentifier = (curCellIdentifierSection.count == 1) ?
    curCellIdentifierSection[0] : curCellIdentifierSection[indexPath.row];
    
    id currSourceData = nil;
    if (_fetchedResultsController != nil)
    {
        id<NSFetchedResultsSectionInfo> sectionInfo = _fetchedResultsController.sections[indexPath.section];
        if ([sectionInfo numberOfObjects] == 1)
        {
            currSourceData = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        }
        else
        {
            currSourceData = [_fetchedResultsController objectAtIndexPath:indexPath];
        }
    }
    else
    {
        NSArray *curCellSourceDataSection = self.currDataAry[indexPath.section];
        currSourceData = (curCellSourceDataSection.count == 1) ?
        curCellSourceDataSection[0] : curCellSourceDataSection[indexPath.row];
    }
    
    return @[curCellIdentifier, currSourceData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *preferredLanguage = gLanguage;
    if ([preferredLanguage isEqualToString:@"zh-Hans"]) {
        return @"删除";
    } else if ([preferredLanguage isEqualToString:@"zh-Hant"]) {
        return @"刪除";
    } else {
        return @"Delete";
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:cModel:)])
    {
        return [self.dataSourceDelegate tableView:tableView canEditRowAtIndexPath:indexPath cModel:[self currentModelAtIndex:indexPath]];
    }
    
    if ([self.dataSourceDelegate respondsToSelector:@selector(canDelete)])
    {
        return [self.dataSourceDelegate canDelete];
    }
    return NO;
}


// _____________________________________________________________________________

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currIndexPath = indexPath;
    if ([self.dataSourceDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:cModel:)])
    {
        [self.dataSourceDelegate tableView:tableView didSelectRowAtIndexPath:indexPath cModel:[self currentModelAtIndex:indexPath]];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(tableView:commitRowAtIndexPath:cModel:)])
    {
        [self.dataSourceDelegate tableView:tableView commitRowAtIndexPath:indexPath cModel:[self currentModelAtIndex:indexPath]];
    }
}


- (id)currentModelAtIndex:(NSIndexPath *)indexPath
{
    return self.currDataAry[indexPath.section][indexPath.row];
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self.dataSourceDelegate currTableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [[self.dataSourceDelegate currTableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [[self.dataSourceDelegate currTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [[self.dataSourceDelegate currTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [[self.dataSourceDelegate currTableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [[self.dataSourceDelegate currTableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [[self.dataSourceDelegate currTableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [[self.dataSourceDelegate currTableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self.dataSourceDelegate currTableView] endUpdates];
}



#pragma mark - RefreshHeader

- (void)setDataSourceDelegate:(id<SUIBaseProtocol>)dataSourceDelegate
{
    _dataSourceDelegate = dataSourceDelegate;
    [self configureRefreshHeader];
}

- (void)configureRefreshHeader
{
    if ([_dataSourceDelegate addHeaderAndRefreshStart])
    {
        [self addRefreshHeader];
        [self headerRefreshSteart];
    }
    else if ([_dataSourceDelegate addHeader])
    {
        [self addRefreshHeader];
    }
    
    if ([_dataSourceDelegate addFooter])
    {
        [self addRefreshFooter];
    }
}

- (void)addRefreshHeader
{
    if ([_dataSourceDelegate currTableView].header == nil)
    {
        [[_dataSourceDelegate currTableView] addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(handlerLoadLastData)];
    }
}
- (void)headerRefreshSteart
{
    if ([_dataSourceDelegate currTableView].header != nil)
    {
        [[_dataSourceDelegate currTableView].header beginRefreshing];
    }
}

- (void)addRefreshFooter
{
    if ([_dataSourceDelegate currTableView].footer == nil)
    {
        [[_dataSourceDelegate currTableView] addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(handlerLoadMoreData)];
    }
}

- (void)headerRefreshStop
{
    if ([_dataSourceDelegate currTableView].header != nil)
    {
        [[_dataSourceDelegate currTableView].header endRefreshing];
    }
}
- (void)footerRefreshStop
{
    if ([_dataSourceDelegate currTableView].footer != nil)
    {
        [[_dataSourceDelegate currTableView].footer endRefreshing];
    }
}

- (void)handlerLoadLastData
{
    [_dataSourceDelegate handlerMainLoadData:NO];
}
- (void)handlerLoadMoreData
{
    [_dataSourceDelegate handlerMainLoadData:YES];
}


#pragma mark - Request

- (void)requestData:(NSDictionary *)parameters
            replace:(BOOL)replace
          completed:(SUIDataSourceBlock)completed
{
    uWeakSelf
    NSURLSessionDataTask *curTask =
    [[SUIHttpClient sharedClient]
     requestWithHost:[SUIBaseConfig sharedConfig].httpHost
     httpMethod:[SUIBaseConfig sharedConfig].httpMethod
     parameters:parameters
     completion:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
         if (weakSelf) {
             NSArray *newDataAry = completed(error, responseObject);
             [weakSelf headerRefreshStop];
             [weakSelf footerRefreshStop];
             
             if (weakSelf.loadMoreData) {
                 [weakSelf addDataAry:newDataAry];
             } else {
                 [weakSelf resetDataAry:newDataAry];
             }
         }
     }];
    if (replace)
    {
        [self.currTask cancel];
        self.currTask = nil;
        self.currTask = curTask;
    }
}


- (void)resetDataAry:(NSArray *)newDataAry
{
    [self.currDataAry removeAllObjects];
    [self.currDataAry addObjectsFromArray:newDataAry];
    [[self.dataSourceDelegate currTableView] reloadData];
}

- (void)addDataAry:(NSArray *)newDataAry
{
    NSMutableArray *curIndexPathAry = [NSMutableArray array];
    for (NSInteger i=0; i<newDataAry.count; i++)
    {
        NSArray *curSectionAry = newDataAry[i];
        if (curSectionAry.count != 0)
        {
            for (NSInteger idx=0; i<curSectionAry.count; i++)
            {
                NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:[self.currDataAry[i] count]+idx inSection:i];
                [curIndexPathAry addObject:curIndexPath];
            }
            NSMutableArray *curDataSectionAry = [NSMutableArray arrayWithArray:self.currDataAry[i]];
            [curDataSectionAry addObjectsFromArray:curSectionAry];
            self.currDataAry[i] = curDataSectionAry;
        }
    }
    
    if (curIndexPathAry.count > 0)
    {
        [[self.dataSourceDelegate currTableView] beginUpdates];
        [[self.dataSourceDelegate currTableView] insertRowsAtIndexPaths:curIndexPathAry withRowAnimation:UITableViewRowAnimationAutomatic];
        [[self.dataSourceDelegate currTableView] endUpdates];
    }
}

- (id)modelPassed
{
    if (_fetchedResultsController == nil)
    {
        return self.currDataAry[self.currIndexPath.section][self.currIndexPath.row];
    }
    else
    {
        return [_fetchedResultsController objectAtIndexPath:self.currIndexPath];
    }
}



#pragma mark - Lazy

- (NSMutableArray *)currDataAry
{
    if (_currDataAry == nil)
    {
        _currDataAry = [NSMutableArray array];
    }
    return _currDataAry;
}

- (NSArray *)currCellIdentifier
{
    if (_currCellIdentifier == nil)
    {
        if ([self.dataSourceDelegate respondsToSelector:@selector(arrayOfCellIdentifier)])
        {
            _currCellIdentifier = [self.dataSourceDelegate arrayOfCellIdentifier];
        }
        else
        {
            NSString *curCellIdentifier = [NSString stringWithFormat:@"SUI%@Cell", [self.dataSourceDelegate currIdentifier]];
            return @[@[curCellIdentifier]];
        }
    }
    return _currCellIdentifier;
}

- (NSIndexPath *)currIndexPath
{
    if (_currIndexPath == nil)
    {
        _currIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _currIndexPath;
}


@end
