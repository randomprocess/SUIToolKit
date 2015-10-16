//
//  SUITableExten.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/9/23.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUITableExten.h"
#import <objc/runtime.h>
#import "SUIToolKitConst.h"
#import "SUIBaseConfig.h"
#import "UIViewController+SUIExt.h"
#import "SUIBaseCell.h"
#import "UIView+SUIExt.h"
#import "MJRefresh.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SUIRequest.h"


@interface SUITableExten ()

@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,strong) UISearchDisplayController *searchDisplayController;

@property (nonatomic,weak) UITableView *currTableView;
@property (nonatomic,strong) NSMutableArray *currDataAry;
@property (nonatomic,strong) NSMutableArray *currSearchDataAry;

@property (nonatomic,copy) SUITableExtenRequestBlock requestBlock;
@property (nonatomic,copy) SUITableExtenRequestCompletionBlock requestCompletionBlock;

@property (nonatomic,copy) SUITableExtenCellForRowBlock cellForRowBlock;
@property (nonatomic,copy) SUITableExtenCellIdentifiersBlock cellIdentifiersBlock;
@property (nonatomic,copy) SUITableExtenDidSelectRowBlock didSelectRowBlock;
@property (nonatomic,copy) SUITableExtenWillDisplayCellBlock willDisplayCellBlock;
@property (nonatomic,copy) SUITableExtenDidScrollBlock didScrollBlock;
@property (nonatomic,copy) SUITableExtenWillBeginDraggingBlock willBeginDraggingBlock;

@property (nonatomic,copy) SUITableExtenSearchTextDidChangeBlock searchTextDidChangeBlock;
@property (nonatomic,copy) SUITableExtenFetchedResultsControllerWillChangeContentBlock fetchedResultsControllerWillChangeContentBlock;
@property (nonatomic,copy) SUITableExtenFetchedResultsControllerDidChangeContentBlock fetchedResultsControllerDidChangeContentBlock;

@property (nonatomic, strong) NSMutableIndexSet *deletedSectionIndexes;
@property (nonatomic, strong) NSMutableIndexSet *insertedSectionIndexes;
@property (nonatomic, strong) NSMutableArray *deletedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *updatedRowIndexPaths;

@end


#pragma mark -

@implementation SUITableExten

- (void)request:(SUITableExtenRequestBlock)cb
{
    [self request:cb completion:nil];
}
- (void)request:(SUITableExtenRequestBlock)cb completion:(SUITableExtenRequestCompletionBlock)completion
{
    self.requestBlock = cb;
    self.requestCompletionBlock = completion;
}
- (void)cellForRow:(SUITableExtenCellForRowBlock)cb
{
    self.cellForRowBlock = cb;
}
- (void)cellIdentifiers:(SUITableExtenCellIdentifiersBlock)cb
{
    self.cellIdentifiersBlock = cb;
}
- (void)didSelectRow:(SUITableExtenDidSelectRowBlock)cb
{
    self.didSelectRowBlock = cb;
}
- (void)willDisplayCell:(SUITableExtenWillDisplayCellBlock)cb
{
    self.willDisplayCellBlock = cb;
}
- (void)didScroll:(SUITableExtenDidScrollBlock)cb
{
    self.didScrollBlock = cb;
}
- (void)willBeginDragging:(SUITableExtenWillBeginDraggingBlock)cb
{
    self.willBeginDraggingBlock = cb;
}

- (void)searchTextDidChange:(SUITableExtenSearchTextDidChangeBlock)cb
{
    self.searchTextDidChangeBlock = cb;
}
- (void)fetchResultControllerWillChangeContent:(SUITableExtenFetchedResultsControllerWillChangeContentBlock)cb
{
    self.fetchedResultsControllerWillChangeContentBlock = cb;
}
- (void)fetchResultControllerDidChangeContent:(SUITableExtenFetchedResultsControllerDidChangeContentBlock)cb
{
    self.fetchedResultsControllerDidChangeContentBlock = cb;
}


- (SUITableExtenType)extenType
{
    if (_searchController.active || _searchDisplayController.active) {
        return SUITableExtenTypeSearch;
    } else if (_fetchedResultsController) {
        return SUITableExtenTypeFetch;
    } else {
        return SUITableExtenTypeNormal;
    }
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


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  TableView Delegate&DataSource
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch ([self extenType])
    {
        case SUITableExtenTypeSearch:
            return self.currSearchDataAry.count;
            break;
        case SUITableExtenTypeFetch:
            return self.fetchedResultsController.sections.count;
            break;
        default:
            return self.currDataAry.count;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 0;
    switch ([self extenType])
    {
        case SUITableExtenTypeSearch:
            numOfRows = [self.currSearchDataAry[section] count];
            break;
        case SUITableExtenTypeFetch: {
            id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
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
    id curModel = currConfig[1];
    SUIBaseCell *currCell = nil;
    if (self.cellForRowBlock) {
        currCell = self.cellForRowBlock(indexPath, curModel);
    } else {
        currCell = [self.currTableView dequeueReusableCellWithIdentifier:currConfig[0]];
    }
    if (!currCell) uLogError(@"currCell is nil");
    
    currCell.currTableView = tableView;
    currCell.currModle = curModel;
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
    id currSourceData = [self currentModelAtIndex:indexPath tableView:tableView];
    NSString *curCellIdentifier = nil;
    if (self.cellIdentifiersBlock) {
        curCellIdentifier = self.cellIdentifiersBlock(indexPath, currSourceData);
        if (!curCellIdentifier) uLogError(@"curCellIdentifier is nil");
    } else {
        UIViewController *currVC = [self.currTableView currVC];
        if (currVC.currIdentifier) {
            curCellIdentifier = gFormat(@"SUI%@Cell", currVC.currIdentifier);
        } else {
            uLogError(@"currVC className should prefix with 'SUI' and suffix with 'VC' or 'TVC'");
        }
    }
    return @[curCellIdentifier, currSourceData];
}

- (id)currentModelAtIndex:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    switch ([self extenType])
    {
        case SUITableExtenTypeSearch:
            return self.currSearchDataAry[indexPath.section][indexPath.row];
            break;
        case SUITableExtenTypeFetch: {
            id currSourceData = nil;
            id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[indexPath.section];
            if ([sectionInfo numberOfObjects] == 1) {
                currSourceData = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
            } else {
                currSourceData = [self.fetchedResultsController objectAtIndexPath:indexPath];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *currVC = tableView.theVC;
    currVC.destModel = [self currentModelAtIndex:indexPath tableView:tableView];
    if (self.didSelectRowBlock) {
        self.didSelectRowBlock(indexPath, currVC.destModel);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id curModel = [self currentModelAtIndex:indexPath tableView:tableView];
    if (self.willDisplayCellBlock) {
        self.willDisplayCellBlock((SUIBaseCell *)cell, indexPath, curModel);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.didScrollBlock) {
        self.didScrollBlock();
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.willBeginDraggingBlock) {
        self.willBeginDraggingBlock();
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Lazily instantiate
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

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

- (UISearchController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.delegate = self;
        _searchController.searchBar.delegate = self;
        [self displaySearchBar:_searchController.searchBar];
    }
    return _searchController;
}

- (UISearchDisplayController *)searchDisplayController
{
    if (_searchDisplayController == nil)
    {
        UISearchBar *currSearchBar = [[UISearchBar alloc] init];
        currSearchBar.delegate = self;
        UIViewController *currVC = [self.currTableView theVC];
        
        _searchDisplayController = [[UISearchDisplayController alloc]
                                    initWithSearchBar:currSearchBar
                                    contentsController:currVC];
        
        _searchDisplayController.searchResultsDataSource = self;
        _searchDisplayController.searchResultsDelegate = self;
        
        [_searchDisplayController.searchResultsTableView accordingToBaseConfig];
        [self displaySearchBar:currSearchBar];
    }
    return _searchDisplayController;
}

- (void)displaySearchBar:(UISearchBar *)curSearchBar
{
    [curSearchBar sizeToFit];
    self.currTableView.tableHeaderView = curSearchBar;
    [self.currTableView currVC].definesPresentationContext = YES;
}

@end


#pragma mark -

@implementation SUITableExten (UISearchBar)

- (void)didDismissSearchController:(UISearchController *)searchController
{
    [self.currTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.searchTextDidChangeBlock)
    {
        if (self.currDataAry.count > 0)
        {
            NSArray *curResults = self.searchTextDidChangeBlock(searchBar, searchText, self.currDataAry);
            
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


#pragma mark -

@implementation SUITableExten (NSFetchedResultsController)

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (self.fetchedResultsControllerWillChangeContentBlock) {
        self.fetchedResultsControllerWillChangeContentBlock(controller);
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
        {
            if ([self.insertedSectionIndexes containsIndex:newIndexPath.section]) return;
            [self.insertedRowIndexPaths addObject:newIndexPath];
        }
            break;
        case NSFetchedResultsChangeDelete:
        {
            if ([self.deletedSectionIndexes containsIndex:newIndexPath.section]) return;
            [self.deletedRowIndexPaths addObject:newIndexPath];
        }
            break;
        case NSFetchedResultsChangeMove:
        {
            if ([self.insertedSectionIndexes containsIndex:newIndexPath.section] == NO) {
                [self.insertedRowIndexPaths addObject:newIndexPath];
            }
            if ([self.deletedSectionIndexes containsIndex:indexPath.section] == NO) {
                [self.deletedRowIndexPaths addObject:indexPath];
            }
        }
            break;
        case NSFetchedResultsChangeUpdate:
        {
            [self.updatedRowIndexPaths addObject:indexPath];
        }
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
            [self.insertedSectionIndexes addIndex:sectionIndex];
            break;
        case NSFetchedResultsChangeDelete:
            [self.deletedSectionIndexes addIndex:sectionIndex];
            break;
        default:
            // Shouldn't have a default
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSInteger totalChanges = [self.deletedSectionIndexes count] +
    [self.insertedSectionIndexes count] +
    [self.deletedRowIndexPaths count] +
    [self.insertedRowIndexPaths count] +
    [self.updatedRowIndexPaths count];
    
    if (totalChanges > 50)
    {
        [self.currTableView reloadData];
    }
    else
    {
        [self.currTableView beginUpdates];
        [self.currTableView deleteSections:self.deletedSectionIndexes withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.currTableView insertSections:self.insertedSectionIndexes withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.currTableView deleteRowsAtIndexPaths:self.deletedRowIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.currTableView insertRowsAtIndexPaths:self.insertedRowIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.currTableView reloadRowsAtIndexPaths:self.updatedRowIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.currTableView endUpdates];
    }
    
    self.insertedSectionIndexes = nil;
    self.deletedSectionIndexes = nil;
    self.deletedRowIndexPaths = nil;
    self.insertedRowIndexPaths = nil;
    self.updatedRowIndexPaths = nil;
    
    if (self.fetchedResultsControllerDidChangeContentBlock) {
        self.fetchedResultsControllerDidChangeContentBlock(controller);
    }
}

- (NSMutableIndexSet *)deletedSectionIndexes
{
    if (_deletedSectionIndexes == nil) {
        _deletedSectionIndexes = [[NSMutableIndexSet alloc] init];
    }
    return _deletedSectionIndexes;
}

- (NSMutableIndexSet *)insertedSectionIndexes
{
    if (_insertedSectionIndexes == nil) {
        _insertedSectionIndexes = [[NSMutableIndexSet alloc] init];
    }
    return _insertedSectionIndexes;
}

- (NSMutableArray *)deletedRowIndexPaths
{
    if (_deletedRowIndexPaths == nil) {
        _deletedRowIndexPaths = [[NSMutableArray alloc] init];
    }
    return _deletedRowIndexPaths;
}

- (NSMutableArray *)insertedRowIndexPaths
{
    if (_insertedRowIndexPaths == nil) {
        _insertedRowIndexPaths = [[NSMutableArray alloc] init];
    }
    return _insertedRowIndexPaths;
}

- (NSMutableArray *)updatedRowIndexPaths
{
    if (_updatedRowIndexPaths == nil) {
        _updatedRowIndexPaths = [[NSMutableArray alloc] init];
    }
    return _updatedRowIndexPaths;
}

@end


#pragma mark -

@implementation UITableView (SUITableExten)

- (SUITableExten *)tableExten
{
    id curTableExten = objc_getAssociatedObject(self, @selector(tableExten));
    if (curTableExten) return curTableExten;
    
    SUITableExten *currTableExten = [SUITableExten new];
    self.tableExten = currTableExten;
    return currTableExten;
}
- (void)setTableExten:(SUITableExten *)tableExten
{
    objc_setAssociatedObject(self, @selector(tableExten), tableExten, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSFetchedResultsController *)fetchedResultsController
{
    return self.tableExten.fetchedResultsController;
}
- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    fetchedResultsController.delegate = self.tableExten;
    self.tableExten.fetchedResultsController = fetchedResultsController;
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

- (BOOL)addHeader
{
    return [objc_getAssociatedObject(self, @selector(addHeader)) boolValue];
}
- (void)setAddHeader:(BOOL)addHeader
{
    objc_setAssociatedObject(self, @selector(addHeader), @(addHeader), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)addFooter
{
    return [objc_getAssociatedObject(self, @selector(addFooter)) boolValue];
}
- (void)setAddFooter:(BOOL)addFooter
{
    objc_setAssociatedObject(self, @selector(addFooter), @(addFooter), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)addHeaderAndRefreshStart
{
    return [objc_getAssociatedObject(self, @selector(addHeaderAndRefreshStart)) boolValue];
}
- (void)setAddHeaderAndRefreshStart:(BOOL)addHeaderAndRefreshStart
{
    objc_setAssociatedObject(self, @selector(addHeaderAndRefreshStart), @(addHeaderAndRefreshStart), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)addSearch
{
    return [objc_getAssociatedObject(self, @selector(addSearch)) boolValue];
}
- (void)setAddSearch:(BOOL)addSearch
{
    objc_setAssociatedObject(self, @selector(addSearch), @(addSearch), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    [self handlerLoadCurrData];
}
- (void)handlerLoadMoreData
{
    self.loadMoreData = YES;
    [self handlerLoadCurrData];
}

- (void)handlerLoadCurrData
{
    if (self.tableExten.requestBlock)
    {
        NSMutableDictionary *currParameters = [NSMutableDictionary dictionary];
        NSMutableArray *currNewDataAry = [NSMutableArray array];
        self.tableExten.requestBlock(currParameters, nil, nil);
        
        uWeakSelf
        [[[SUIRequest requestData:currParameters]
          parser:^NSArray *(id cResponseObject) {
              weakSelf.tableExten.requestBlock(nil, cResponseObject, currNewDataAry);
              return currNewDataAry;
          } refreshTable:self]
         completion:^(NSError *cError, id cResponseObject) {
             if (weakSelf.tableExten.requestCompletionBlock) {
                 weakSelf.tableExten.requestCompletionBlock(cError, cResponseObject);
             }
         }];
    }
    else
    {
        uLogError(@"load data without ^request");
    }
}

- (void)refreshTable:(NSArray *)newDataAry
{
    if (newDataAry.count > 0)
    {
        if (self.addFooter)
        {
            NSInteger curDataCount = 0;
            for (NSArray *curSubAry in newDataAry) {
                curDataCount = MAX(curDataCount, curSubAry.count);
            }
            
            if (curDataCount < self.pageSize)
            {
                if (!self.footer.hidden) self.footer.hidden = !self.footer.hidden;
            }
            else if (curDataCount > 0)
            {
                if (self.footer.hidden) self.footer.hidden = !self.footer.hidden;
                self.pageIndex ++;
            }
        }
        
        if (self.tableExten.extenType != SUITableExtenTypeFetch)
        {
            (self.loadMoreData) ? [self.tableExten addDataAry:newDataAry] : [self.tableExten resetDataAry:newDataAry];
        }
    }
}

@end


#pragma mark -

@implementation UITableView (SUIConfig)

- (void)accordingToBaseConfig
{
    self.separatorColor = [SUIBaseConfig sharedConfig].separatorColor;
    self.separatorInset = UIEdgeInsetsFromString([SUIBaseConfig sharedConfig].separatorInset);
    self.backgroundColor = [UIColor clearColor];
    self.tableFooterView = [UIView new];
    
    UIView *curBackgroundView = [UIView new];
    self.backgroundView = curBackgroundView;
    
    UIViewController *currVC = self.currVC ? self.currVC : self.theVC;
    
    if ([currVC isKindOfClass:[UITableViewController class]])
    {
        curBackgroundView.frame = self.bounds;
        curBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        curBackgroundView.backgroundColor = [SUIBaseConfig sharedConfig].backgroundColor;
    }
    else
    {
        curBackgroundView.backgroundColor = [UIColor clearColor];
    }
    
    // estimatedRowHeight 默认为0
    // ios7计算cell动态高度应为0, ios8应不为0, 不计算高度应该给个值
    // .... 方便起见, 干脆为0好了 > <....
    //curTableView.estimatedRowHeight = curTableView.rowHeight;
}

@end


#pragma mark -

@implementation UIViewController (SUIConfig)

- (void)accordingToBaseConfig
{
    self.view.backgroundColor = [SUIBaseConfig sharedConfig].backgroundColor;
    if (self.currTableView) {
        [self.currTableView accordingToBaseConfig];
        self.currTableView.tableExten.currTableView = self.currTableView;
        if (![self isKindOfClass:[UITableViewController class]]) {
            self.currTableView.delegate = self.currTableView.tableExten;
            self.currTableView.dataSource = self.currTableView.tableExten;
        }
        [self configureRefreshHeader];
        [self configureSearchController];
    }
}

- (void)configureRefreshHeader
{
    if (self.currTableView.addHeaderAndRefreshStart) {
        [self.currTableView addRefreshHeader];
        [self.currTableView headerRefreshSteart];
    } else if (self.currTableView.addHeader) {
        [self.currTableView addRefreshHeader];
    }
    
    if (self.currTableView.addFooter) {
        [self.currTableView addRefreshFooter];
        [self.currTableView hideRefreshFooter:YES];
    }
}

- (void)configureSearchController
{
    if (self.currTableView.addSearch)
    {
        if (kAboveIOS8) {
            uWarcWunusedGetter(
                               self.currTableView.tableExten.searchController;
                               )
        } else {
            uWarcWunusedGetter(
                               self.currTableView.tableExten.searchDisplayController;
                               )
        }
    }
}

@end
