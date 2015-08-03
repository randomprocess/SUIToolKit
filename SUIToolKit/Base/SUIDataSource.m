//
//  SUIDataSource.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIDataSource.h"
#import "SUIToolKitConst.h"
#import "SUIBaseConfig.h"
#import "SUIBaseCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MJRefresh.h"
#import "SUIHttpClient.h"


static dispatch_queue_t data_source_refresh_table_queue() {
    static dispatch_queue_t sui_data_source_refresh_table_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sui_data_source_refresh_table_queue = dispatch_queue_create([gFormat(@"com.%@.datasource.refreshtable", kProjectName) UTF8String], DISPATCH_QUEUE_SERIAL);
    });
    return sui_data_source_refresh_table_queue;
}

@interface SUIDataSource () <
    UISearchControllerDelegate,
    UISearchResultsUpdating,
    UISearchDisplayDelegate,
    UISearchBarDelegate,
    MGSwipeTableCellDelegate>


@property (nonatomic,strong) NSMutableArray *currDataAry;

@property (nonatomic,strong) id scrModel;

@property (nonatomic,strong) NSArray *currCellIdentifier;

@property (nonatomic,weak) NSURLSessionDataTask *currTask;

@property (nonatomic,assign,getter=isLoadMoreData) BOOL loadMoreData;

@property (nonatomic,strong) UISearchController *currSearchController;
@property (nonatomic,strong) UISearchDisplayController *currSearchDisplayController;

@property (nonatomic,strong) NSMutableArray *currSearchDataAry;

@end

@implementation SUIDataSource


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_currSearchController.active || _currSearchDisplayController.searchResultsTableView == tableView)
    {
        return self.currSearchDataAry.count;
    }
    
    if ([_dataSourceDelegate fetchedResultsController] != nil)
    {
        return [_dataSourceDelegate fetchedResultsController].sections.count;
    }
    return self.currDataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currSearchController.active || _currSearchDisplayController.searchResultsTableView == tableView)
    {
        return [self.currSearchDataAry[section] count];
    }
    
    if ([_dataSourceDelegate fetchedResultsController] != nil)
    {
        id<NSFetchedResultsSectionInfo> sectionInfo = [_dataSourceDelegate fetchedResultsController].sections[section];
        return [sectionInfo numberOfObjects];
    }
    
    NSInteger numOfRows = [self.currDataAry[section] count];
    return numOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *currConfig = [self configureCell:indexPath tableView:tableView];
    SUIBaseCell *currCell = [[_dataSourceDelegate currTableView] dequeueReusableCellWithIdentifier:currConfig[0]];
    currCell.cellActionDelegate = self.dataSourceDelegate;
    currCell.delegate = self;
    currCell.currModle = currConfig[1];
    [currCell displayWithCalculateCellHeight:currCell.currModle];
    [currCell displayWithCurrModel:currCell.currModle];
    return currCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *currConfig = [self configureCell:indexPath tableView:tableView];
    return [[_dataSourceDelegate currTableView] fd_heightForCellWithIdentifier:currConfig[0] configuration:^(id cell) {
        SUIBaseCell *curCell = (SUIBaseCell *)cell;
        curCell.currModle = currConfig[1];
        [curCell displayWithCalculateCellHeight:curCell.currModle];
    }];
}

- (NSArray *)configureCell:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    NSArray *curCellIdentifierSection = self.currCellIdentifier[indexPath.section];
    NSString *curCellIdentifier = (curCellIdentifierSection.count == 1) ?
    curCellIdentifierSection[0] : curCellIdentifierSection[indexPath.row];
    
    if (_currSearchController.active || _currSearchDisplayController.searchResultsTableView == tableView)
    {
        id currSourceData = self.currSearchDataAry[indexPath.section][indexPath.row];
        return @[curCellIdentifier, currSourceData];
    }
    
    id currSourceData = nil;
    if ([_dataSourceDelegate fetchedResultsController] != nil)
    {
        id<NSFetchedResultsSectionInfo> sectionInfo = [_dataSourceDelegate fetchedResultsController].sections[indexPath.section];
        if ([sectionInfo numberOfObjects] == 1)
        {
            currSourceData = [[_dataSourceDelegate fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        }
        else
        {
            currSourceData = [[_dataSourceDelegate fetchedResultsController] objectAtIndexPath:indexPath];
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


// _____________________________________________________________________________

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _scrModel = [self currentModelAtIndex:indexPath tableView:tableView];
    
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiTableView:didSelectRowAtIndexPath:cModel:)])
    {
        [self.dataSourceDelegate suiTableView:tableView didSelectRowAtIndexPath:indexPath cModel:[self currentModelAtIndex:indexPath tableView:tableView]];
    }
}

- (id)currentModelAtIndex:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if (_currSearchController.active || _currSearchDisplayController.searchResultsTableView == tableView)
    {
        return self.currSearchDataAry[indexPath.section][indexPath.row];
    }
    else
    {
        id currSourceData = nil;
        if ([_dataSourceDelegate fetchedResultsController] != nil)
        {
            id<NSFetchedResultsSectionInfo> sectionInfo = [_dataSourceDelegate fetchedResultsController].sections[indexPath.section];
            if ([sectionInfo numberOfObjects] == 1)
            {
                currSourceData = [[_dataSourceDelegate fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
            }
            else
            {
                currSourceData = [[_dataSourceDelegate fetchedResultsController] objectAtIndexPath:indexPath];
            }
        }
        else
        {
            NSArray *curCellSourceDataSection = self.currDataAry[indexPath.section];
            currSourceData = (curCellSourceDataSection.count == 1) ?
            curCellSourceDataSection[0] : curCellSourceDataSection[indexPath.row];
        }
        
        return currSourceData;
    }
}


// _____________________________________________________________________________

#pragma mark - MGSwipeTableCellDelegate

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiSwipeTableCell:canSwipe:cModel:)])
    {
        SUISwipeDirection curDirection = direction ? SUISwipeDirectionToLeft : SUISwipeDirectionToRight;
        return [self.dataSourceDelegate suiSwipeTableCell:(SUIBaseCell *)cell canSwipe:curDirection cModel:[self modelOfSwipeTableCell:cell]];
    }
    return YES;
}

- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiSwipeTableCell:direction:swipeSettings:expansionSettings:cModel:)])
    {
        swipeSettings.transition = MGSwipeTransitionDrag;
        expansionSettings.fillOnTrigger = YES;
        
        SUISwipeDirection curDirection = direction ? SUISwipeDirectionToLeft : SUISwipeDirectionToRight;
        return [self.dataSourceDelegate suiSwipeTableCell:(SUIBaseCell *)cell direction:curDirection swipeSettings:swipeSettings expansionSettings:expansionSettings cModel:[self modelOfSwipeTableCell:cell]];
    }
    return nil;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiSwipeTableCell:tappedAtIndex:direction:cModel:)])
    {
        SUISwipeDirection curDirection = direction ? SUISwipeDirectionToLeft : SUISwipeDirectionToRight;
        return [self.dataSourceDelegate suiSwipeTableCell:(SUIBaseCell *)cell tappedAtIndex:index direction:curDirection cModel:[self modelOfSwipeTableCell:cell]];
    }
    return YES;
}

- (id)modelOfSwipeTableCell:(MGSwipeTableCell *)cell
{
    NSIndexPath* curIndexPath = [[self.dataSourceDelegate currTableView] indexPathForCell:cell];
    return [self currentModelAtIndex:curIndexPath tableView:[self.dataSourceDelegate currTableView]];
}


// _____________________________________________________________________________

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



#pragma mark -

- (void)setDataSourceDelegate:(id<SUIBaseProtocol>)dataSourceDelegate
{
    _dataSourceDelegate = dataSourceDelegate;
    [self configureRefreshHeader];
    [self configureSearchController];
}


#pragma mark - RefreshHeader

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
        _dataSourceDelegate.currTableView.footer.hidden = YES;
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
    self.loadMoreData = NO;
    _dataSourceDelegate.pageIndex = 0;
    [_dataSourceDelegate handlerMainRequest:NO];
}
- (void)handlerLoadMoreData
{
    self.loadMoreData = YES;
    [_dataSourceDelegate handlerMainRequest:YES];
}


#pragma mark - Search

- (void)configureSearchController
{
    if ([_dataSourceDelegate addSearch])
    {
        if (kAboveIOS8) {
            uWarcWunusedGetter(
                               self.currSearchController;
                               )
        } else {
            uWarcWunusedGetter(
                               self.currSearchDisplayController;
                               )
        }
    }
}


#pragma mark UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
//    [[self.dataSourceDelegate currTableView] reloadData];
}

#pragma mark UISearchControllerDelegate

- (void)didDismissSearchController:(UISearchController *)searchController
{
    [[self.dataSourceDelegate currTableView] reloadData];
}

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([_dataSourceDelegate respondsToSelector:@selector(suiSearchBar:textDidChange:dataAry:)])
    {
        if (self.currDataAry.count > 0)
        {
            NSArray *curResults = [_dataSourceDelegate suiSearchBar:searchBar textDidChange:searchText dataAry:self.currDataAry];
            if (curResults == nil) return;
            
            [self.currSearchDataAry removeAllObjects];
            if (curResults.count > 0)
            {
                [self.currSearchDataAry addObjectsFromArray:curResults];
            }
            
            if (kAboveIOS8)
            {
                [[self.dataSourceDelegate currTableView] reloadData];
            }
        }
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
}


#pragma mark - Request


- (void)requestData:(NSDictionary *)parameters
            replace:(BOOL)replace
       refreshTable:(SUIDataSourceRefreshTableBlock)refreshTable
          completed:(SUIDataSourceCompletionBlock)completed
{
    uWeakSelf
    NSURLSessionDataTask *curTask =
    [[SUIHttpClient sharedClient]
     requestWithHost:[SUIBaseConfig sharedConfig].httpHost
     httpMethod:[SUIBaseConfig sharedConfig].httpMethod
     parameters:parameters
     completion:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
         if (weakSelf) {
             uStrongSelf

#if DEBUG
             if (error == nil) {
                 uLogInfo("========== response ==========\n%@\n", responseObject);
             } else {
                 uLogError("========== error ==========\n%@\n", error)
             }
#endif
             
             if ([strongSelf.dataSourceDelegate fetchedResultsController])
             {
                 if (replace && !strongSelf.loadMoreData)
                 {
                     NSManagedObjectContext *curManagedObjectContext = [strongSelf.dataSourceDelegate managedObjectContext];
                     for (NSManagedObject *ct in [curManagedObjectContext registeredObjects]) {
                         [curManagedObjectContext deleteObject:ct];
                     }
                     [curManagedObjectContext save:nil];
                 }
             }
             
             if (refreshTable)
             {
                 typeof(strongSelf) __weak weakSelf = strongSelf;
                 dispatch_async(data_source_refresh_table_queue(), ^{
                     NSArray *newDataAry = nil;
                     if (error == nil) {
                         newDataAry = refreshTable(responseObject);
                     }
                     
                     uMainQueue(
                                if (weakSelf)
                                {
                                    uStrongSelf
                                    
                                    [strongSelf headerRefreshStop];
                                    [strongSelf footerRefreshStop];
                                    
                                    if (newDataAry)
                                    {
                                        if ([strongSelf.dataSourceDelegate addFooter])
                                        {
                                            NSInteger curDataCount = 0;
                                            for (NSArray *curSubAry in newDataAry)
                                            {
                                                curDataCount = MAX(curDataCount, curSubAry.count);
                                            }
                                            
                                            if (curDataCount < strongSelf.dataSourceDelegate.pageSize) {
                                                if (!strongSelf.dataSourceDelegate.currTableView.footer.hidden) {
                                                    strongSelf.dataSourceDelegate.currTableView.footer.hidden = YES;
                                                }
                                            }  else if (curDataCount > 0) {
                                                strongSelf.dataSourceDelegate.pageIndex ++;
                                                if (strongSelf.dataSourceDelegate.currTableView.footer.hidden) {
                                                    strongSelf.dataSourceDelegate.currTableView.footer.hidden = NO;
                                                }
                                            }
                                        }
                                        
                                        if (replace)
                                        {
                                            if ([strongSelf.dataSourceDelegate fetchedResultsController]) {
                                                [[strongSelf.dataSourceDelegate managedObjectContext] save:nil];
                                            } else {
                                                (strongSelf.loadMoreData) ? [strongSelf addDataAry:newDataAry] : [strongSelf resetDataAry:newDataAry];
                                            }
                                        }
                                    }
                                }
                                
                                if (completed)
                                {
                                   completed(error, responseObject);
                                }
                        );
                 });
             }
             else
             {
                 if (completed)
                 {
                     uMainQueue(
                                completed(error, responseObject);
                     )
                 }
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
    [[_dataSourceDelegate currTableView] reloadData];
}

- (void)addDataAry:(NSArray *)newDataAry
{
    NSMutableArray *curIndexPathAry = [NSMutableArray array];
    for (NSInteger i=0; i<newDataAry.count; i++)
    {
        NSArray *curSectionAry = newDataAry[i];
        if (curSectionAry.count != 0)
        {
            for (NSInteger idx=0; idx<curSectionAry.count; idx++)
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
    return _scrModel;
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

- (UISearchController *)currSearchController
{
    if (_currSearchController == nil)
    {
        _currSearchController = [[UISearchController alloc]
                                 initWithSearchResultsController:nil];
//        _currSearchController.searchResultsUpdater = self;
        _currSearchController.delegate = self;
        _currSearchController.searchBar.delegate = self;
        [self displaySearchBar:_currSearchController.searchBar];
    }
    return _currSearchController;
}

- (UISearchDisplayController *)currSearchDisplayController
{
    if (_currSearchDisplayController == nil)
    {
        UISearchBar *currSearchBar = [[UISearchBar alloc] init];
        UIViewController *resultsVC = (UIViewController *)_dataSourceDelegate;
        
        _currSearchDisplayController = [[UISearchDisplayController alloc]
                                        initWithSearchBar:currSearchBar
                                        contentsController:resultsVC];
        
        _currSearchDisplayController.searchResultsDataSource = self;
        _currSearchDisplayController.searchResultsDelegate = self;
        currSearchBar.delegate = self;
        
        [[SUIBaseConfig sharedConfig] configureTableView:_currSearchDisplayController.searchResultsTableView tvc:YES];
        
        [self displaySearchBar:currSearchBar];
    }
    return _currSearchDisplayController;
}

- (void)displaySearchBar:(UISearchBar *)curSearchBar
{
    [curSearchBar sizeToFit];
    [_dataSourceDelegate currTableView].tableHeaderView = curSearchBar;
    ((UIViewController *)_dataSourceDelegate).definesPresentationContext = YES;
}

- (NSMutableArray *)currSearchDataAry
{
    if (_currSearchDataAry == nil)
    {
        _currSearchDataAry = [NSMutableArray array];
    }
    return _currSearchDataAry;
}


@end
