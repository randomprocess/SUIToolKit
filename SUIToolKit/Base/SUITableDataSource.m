//
//  SUITableDataSource.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/7.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUITableDataSource.h"
#import "SUIToolKitConst.h"
#import "SUIBaseConfig.h"
#import <objc/runtime.h>
#import "MJRefresh.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SUIBaseCell.h"


@implementation UITableView (SUITableDataSource)

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


// _____________________________________________________________________________

@interface SUITableDataSource () <
    UISearchControllerDelegate,
    UISearchResultsUpdating,
    UISearchDisplayDelegate,
    UISearchBarDelegate,
    NSFetchedResultsControllerDelegate,
    MGSwipeTableCellDelegate>

@property (nonatomic,strong) NSMutableArray *currDataAry;
@property (nonatomic,strong) NSMutableArray *currSearchDataAry;

@property (nonatomic,strong) NSArray *currCellIdentifier; // 分组用

@property (nonatomic,strong) UISearchController *currSearchController;
@property (nonatomic,strong) UISearchDisplayController *currSearchDisplayController;

@end


@implementation SUITableDataSource

- (SUITableDataSourceType)currDataSourceType
{
    if (_currSearchController.active || _currSearchDisplayController.active) {
        return SUITableDataSourceTypeSearch;
    } else if (_currFetchedResultsController) {
        return SUITableDataSourceTypeFetch;
    } else {
        return SUITableDataSourceTypeNormal;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch ([self currDataSourceType])
    {
        case SUITableDataSourceTypeSearch:
            return self.currSearchDataAry.count;
            break;
        case SUITableDataSourceTypeFetch:
            return self.currFetchedResultsController.sections.count;
            break;
        default:
            return self.currDataAry.count;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 0;
    
    switch ([self currDataSourceType])
    {
        case SUITableDataSourceTypeSearch:
            numOfRows = [self.currSearchDataAry[section] count];
            break;
        case SUITableDataSourceTypeFetch: {
            id<NSFetchedResultsSectionInfo> sectionInfo = self.currFetchedResultsController.sections[section];
            numOfRows = [sectionInfo numberOfObjects];
        }
            break;
        default:
            numOfRows = [self.currDataAry[section] count];
            break;
    }
    
    return numOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *currConfig = [self configureCell:indexPath tableView:tableView];
    SUIBaseCell *currCell = [self.currTableView dequeueReusableCellWithIdentifier:currConfig[0]];
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
    return [self.currTableView fd_heightForCellWithIdentifier:currConfig[0] configuration:^(id cell) {
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
    id currSourceData = [self currentModelAtIndex:indexPath tableView:tableView];
    return @[curCellIdentifier, currSourceData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.scrModel = [self currentModelAtIndex:indexPath tableView:tableView];
    
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiTableView:didSelectRowAtIndexPath:cModel:)])
    {
        id curModel = [self currentModelAtIndex:indexPath tableView:tableView];
        [self.dataSourceDelegate suiTableView:tableView didSelectRowAtIndexPath:indexPath cModel:curModel];
    }
}

- (id)currentModelAtIndex:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    switch ([self currDataSourceType])
    {
        case SUITableDataSourceTypeSearch:
            return self.currSearchDataAry[indexPath.section][indexPath.row];
            break;
        case SUITableDataSourceTypeFetch: {
            id currSourceData = nil;
            id<NSFetchedResultsSectionInfo> sectionInfo = self.currFetchedResultsController.sections[indexPath.section];
            if ([sectionInfo numberOfObjects] == 1) {
                currSourceData = [self.currFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
            } else {
                currSourceData = [self.currFetchedResultsController objectAtIndexPath:indexPath];
            }
            return currSourceData;
        }
            break;
        default: {
            NSArray *curCellSourceDataSection = self.currDataAry[indexPath.section];
            id currSourceData = (curCellSourceDataSection.count == 1) ?
            curCellSourceDataSection[0] : curCellSourceDataSection[indexPath.row];
            return currSourceData;
        }
            break;
    }
}


#pragma mark -

- (void)setDataSourceDelegate:(id<SUIBaseProtocol>)dataSourceDelegate
{
    _dataSourceDelegate = dataSourceDelegate;
    [self configureRefreshHeader];
    [self configureSearchController];
}

- (void)setCurrTableView:(UITableView *)currTableView
{
    _currTableView = currTableView;
    _currTableView.emptyDataSetSource = self;
    _currTableView.emptyDataSetDelegate = self;
}

- (void)setCurrFetchedResultsController:(NSFetchedResultsController *)currFetchedResultsController
{
    _currFetchedResultsController = currFetchedResultsController;
    _currFetchedResultsController.delegate = self;
}


- (void)resetDataAry:(NSArray *)newDataAry
{
    [self.currDataAry removeAllObjects];
    [self.currDataAry addObjectsFromArray:newDataAry];
    [self.currTableView reloadData];
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
        [self.currTableView  beginUpdates];
        [self.currTableView  insertRowsAtIndexPaths:curIndexPathAry withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.currTableView  endUpdates];
    }
}


#pragma mark - RefreshHeader

- (void)configureRefreshHeader
{
    if ([self.dataSourceDelegate addHeaderAndRefreshStart]) {
        [self.currTableView addRefreshHeader];
        [self.currTableView headerRefreshSteart];
    } else if ([self.dataSourceDelegate addHeader]) {
        [self.currTableView addRefreshHeader];
    }
    
    if ([self.dataSourceDelegate addFooter]) {
        [self.currTableView addRefreshFooter];
        [self.currTableView hideRefreshFooter:YES];
    }
}



#pragma mark - Search

- (void)configureSearchController
{
    if ([self.dataSourceDelegate addSearch])
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


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}



#pragma mark - Lazy

- (NSMutableArray *)currDataAry
{
    if (_currDataAry == nil) {
        _currDataAry = [NSMutableArray array];
    }
    return _currDataAry;
}
- (NSMutableArray *)currSearchDataAry
{
    if (_currSearchDataAry == nil) {
        _currSearchDataAry = [NSMutableArray array];
    }
    return _currSearchDataAry;
}

- (NSArray *)currCellIdentifier
{
    if (_currCellIdentifier == nil) {
        if ([self.dataSourceDelegate respondsToSelector:@selector(arrayOfCellIdentifier)]) {
            _currCellIdentifier = [self.dataSourceDelegate arrayOfCellIdentifier];
        } else {
            NSString *curCellIdentifier = [NSString stringWithFormat:@"SUI%@Cell", [self.dataSourceDelegate currIdentifier]];
            return @[@[curCellIdentifier]];
        }
    }
    return _currCellIdentifier;
}

- (UISearchController *)currSearchController
{
    if (_currSearchController == nil) {
        _currSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _currSearchController.delegate = self;
        _currSearchController.searchBar.delegate = self;
        [self displaySearchBar:_currSearchController.searchBar];
    }
    return _currSearchController;
}
- (UISearchDisplayController *)currSearchDisplayController
{
    if (_currSearchDisplayController == nil) {
        UISearchBar *currSearchBar = [[UISearchBar alloc] init];
        currSearchBar.delegate = self;
        UIViewController *resultsVC = (UIViewController *)self.dataSourceDelegate;
        
        _currSearchDisplayController = [[UISearchDisplayController alloc]
                                        initWithSearchBar:currSearchBar
                                        contentsController:resultsVC];
        
        _currSearchDisplayController.searchResultsDataSource = self;
        _currSearchDisplayController.searchResultsDelegate = self;
        
        [[SUIBaseConfig sharedConfig] configureTableView:_currSearchDisplayController.searchResultsTableView tvc:YES];
        [self displaySearchBar:currSearchBar];
    }
    return _currSearchDisplayController;
}
- (void)displaySearchBar:(UISearchBar *)curSearchBar
{
    [curSearchBar sizeToFit];
    self.currTableView.tableHeaderView = curSearchBar;
    ((UIViewController *)self.dataSourceDelegate).definesPresentationContext = YES;
}

@end


// _____________________________________________________________________________

@implementation SUITableDataSource (DZNEmptyDataSet)

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiEmptyDataSetTitleForScrollView:)]) {
        return [self.dataSourceDelegate suiEmptyDataSetTitleForScrollView:scrollView];
    }
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiEmptyDataSetDescriptionForScrollView:)]) {
        return [self.dataSourceDelegate suiEmptyDataSetDescriptionForScrollView:scrollView];
    }
    return nil;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiEmptyDataSetImageForScrollView:)]) {
        return [self.dataSourceDelegate suiEmptyDataSetImageForScrollView:scrollView];
    }
    return nil;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiEmptyDataSetCustomViewForScrollView:generalView:)]) {
        if ([SUIBaseConfig sharedConfig].classNameOfLoadingView) {
            UIView *curGeneralView = [[NSClassFromString([SUIBaseConfig sharedConfig].classNameOfLoadingView) alloc] init];
            return [self.dataSourceDelegate suiEmptyDataSetCustomViewForScrollView:scrollView generalView:curGeneralView];
        }
        return [self.dataSourceDelegate suiEmptyDataSetCustomViewForScrollView:scrollView generalView:nil];
    }
    return nil;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiEmptyDataSetShouldDisplay:)]) {
        return [self.dataSourceDelegate suiEmptyDataSetShouldDisplay:scrollView];
    }
    return [self.dataSourceDelegate addEmptyDataSet];
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiEmptyDataSetShouldAllowTouch:)]) {
        return [self.dataSourceDelegate suiEmptyDataSetShouldAllowTouch:scrollView];
    }
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiEmptyDataSetShouldAllowScroll:)]) {
        return [self.dataSourceDelegate suiEmptyDataSetShouldAllowScroll:scrollView];
    }
    return YES;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiEmptyDataSetDidTapView:)]) {
        [self.dataSourceDelegate suiEmptyDataSetDidTapView:scrollView];
    }
}

@end


// _____________________________________________________________________________

@implementation SUITableDataSource (MGSwipeTableCell)

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiSwipeTableCell:canSwipe:cModel:)]) {
        SUISwipeDirection curDirection = direction ? SUISwipeDirectionToLeft : SUISwipeDirectionToRight;
        return [self.dataSourceDelegate suiSwipeTableCell:(SUIBaseCell *)cell canSwipe:curDirection cModel:[self modelOfSwipeTableCell:cell]];
    }
    return YES;
}

- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiSwipeTableCell:direction:swipeSettings:expansionSettings:cModel:)]) {
        swipeSettings.transition = MGSwipeTransitionDrag;
        expansionSettings.fillOnTrigger = YES;
        SUISwipeDirection curDirection = direction ? SUISwipeDirectionToLeft : SUISwipeDirectionToRight;
        return [self.dataSourceDelegate suiSwipeTableCell:(SUIBaseCell *)cell direction:curDirection swipeSettings:swipeSettings expansionSettings:expansionSettings cModel:[self modelOfSwipeTableCell:cell]];
    }
    return nil;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiSwipeTableCell:tappedAtIndex:direction:cModel:)]) {
        SUISwipeDirection curDirection = direction ? SUISwipeDirectionToLeft : SUISwipeDirectionToRight;
        return [self.dataSourceDelegate suiSwipeTableCell:(SUIBaseCell *)cell tappedAtIndex:index direction:curDirection cModel:[self modelOfSwipeTableCell:cell]];
    }
    return YES;
}

- (id)modelOfSwipeTableCell:(MGSwipeTableCell *)cell
{
    NSIndexPath* curIndexPath = [self.currTableView indexPathForCell:cell];
    return [self currentModelAtIndex:curIndexPath tableView:self.currTableView];
}

@end


// _____________________________________________________________________________

@implementation SUITableDataSource (NSFetchedResultsController)

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.currTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [self.currTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.currTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.currTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.currTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.currTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
            [self.currTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.currTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.currTableView endUpdates];
}

@end


// _____________________________________________________________________________

@implementation SUITableDataSource (UISearchBar)

- (void)didDismissSearchController:(UISearchController *)searchController
{
    [self.currTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.dataSourceDelegate respondsToSelector:@selector(suiSearchBar:textDidChange:dataAry:)])
    {
        if (self.currDataAry.count > 0)
        {
            NSArray *curResults = [self.dataSourceDelegate suiSearchBar:searchBar textDidChange:searchText dataAry:self.currDataAry];
            if (curResults == nil) return;
            
            [self.currSearchDataAry removeAllObjects];
            if (curResults.count > 0)
            {
                [self.currSearchDataAry addObjectsFromArray:curResults];
            }
            
            if (kAboveIOS8)
            {
                [self.currTableView reloadData];
            }
        }
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
}

@end

