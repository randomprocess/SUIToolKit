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

@property (nonatomic,copy) SUITableExtenCellForRowBlock cellForRowBlock;
@property (nonatomic,copy) SUITableExtenCellIdentifiersBlock cellIdentifiersBlock;
@property (nonatomic,copy) SUITableExtenDidSelectRowBlock didSelectRowBlock;
@property (nonatomic,copy) SUITableExtenWillDisplayCellBlock willDisplayCellBlock;
@property (nonatomic,copy) SUITableExtenDidScrollBlock didScrollBlock;
@property (nonatomic,copy) SUITableExtenWillBeginDraggingBlock willBeginDraggingBlock;

@property (nonatomic,copy) SUITableExtenNumberOfSectionsBlock numberOfSectionsBlock;
@property (nonatomic,copy) SUITableExtenNumberOfRowsBlock numberOfRowsBlock;
@property (nonatomic,copy) SUITableExtenCurrentModelBlock currentModelBlock;

@property (nonatomic,copy) SUITableExtenSearchTextDidChangeBlock searchTextDidChangeBlock;
@property (nonatomic,copy) SUITableExtenFetchedResultsControllerWillChangeContentBlock fetchedResultsControllerWillChangeContentBlock;
@property (nonatomic,copy) SUITableExtenFetchedResultsControllerDidChangeObjectBlock fetchedResultsControllerDidChangeObjectBlock;
@property (nonatomic,copy) SUITableExtenFetchedResultsControllerAnimationBlock fetchedResultsControllerAnimationBlock;
@property (nonatomic,copy) SUITableExtenFetchedResultsControllerDidChangeContentBlock fetchedResultsControllerDidChangeContentBlock;
@property (nonatomic,copy) SUITableExtenDataAryChangeAnimationBlock dataAryChangeAnimationBlock;

@property (nonatomic,strong) NSMutableIndexSet *deletedSectionIndexes;
@property (nonatomic,strong) NSMutableIndexSet *insertedSectionIndexes;
@property (nonatomic,strong) NSMutableArray *deletedRowIndexPaths;
@property (nonatomic,strong) NSMutableArray *insertedRowIndexPaths;
@property (nonatomic,strong) NSMutableArray *updatedRowIndexPaths;

@end


#pragma mark -

@implementation SUITableExten

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

- (void)numberOfSections:(SUITableExtenNumberOfSectionsBlock)cb
{
    self.numberOfSectionsBlock = cb;
}
- (void)numberOfRows:(SUITableExtenNumberOfRowsBlock)cb
{
    self.numberOfRowsBlock = cb;
}
- (void)currentModel:(SUITableExtenCurrentModelBlock)cb
{
    self.currentModelBlock = cb;
}

- (void)searchTextDidChange:(SUITableExtenSearchTextDidChangeBlock)cb
{
    self.searchTextDidChangeBlock = cb;
}
- (void)fetchResultControllerWillChangeContent:(SUITableExtenFetchedResultsControllerWillChangeContentBlock)cb
{
    self.fetchedResultsControllerWillChangeContentBlock = cb;
}
- (void)fetchResultControllerDidChangeObject:(SUITableExtenFetchedResultsControllerDidChangeObjectBlock)cb
{
    self.fetchedResultsControllerDidChangeObjectBlock = cb;
}
- (void)fetchResultControllerAnimation:(SUITableExtenFetchedResultsControllerAnimationBlock)cb
{
    self.fetchedResultsControllerAnimationBlock = cb;
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

- (NSInteger)countOfSections:(SUITableExtenType)cType
{
    switch (cType)
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

- (NSInteger)countOfRowsInSection:(NSInteger)cSection type:(SUITableExtenType)cType
{
    NSInteger numOfRows = 0;
    if ([self countOfSections:cType] > 0)
    {
        switch (cType)
        {
            case SUITableExtenTypeSearch:
                numOfRows = [self.currSearchDataAry[cSection] count];
                break;
            case SUITableExtenTypeFetch: {
                id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[cSection];
                numOfRows = [sectionInfo numberOfObjects];
            }
                break;
            default:
                numOfRows = [self.currDataAry[cSection] count];
                break;
        }
    }
    return numOfRows;
}

- (id)currentModelAtIndexPath:(NSIndexPath *)cIndexPath type:(SUITableExtenType)cType
{
    switch (cType)
    {
        case SUITableExtenTypeSearch:
            return self.currSearchDataAry[cIndexPath.section][cIndexPath.row];
            break;
        case SUITableExtenTypeFetch: {
            id currSourceData = nil;
            id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[cIndexPath.section];
            if ([sectionInfo numberOfObjects] == 1) {
                currSourceData = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:cIndexPath.section]];
            } else {
                currSourceData = [self.fetchedResultsController objectAtIndexPath:cIndexPath];
            }
            return currSourceData;
        }
            break;
        default: {
            NSArray *curCellSourceDataSection = self.currDataAry[cIndexPath.section];
            id currSourceData = (curCellSourceDataSection.count == 1) ?
            curCellSourceDataSection[0] : curCellSourceDataSection[cIndexPath.row];
            return currSourceData;
        }
            break;
    }
}

- (void)resetDataAry:(NSArray *)newDataAry
{
    uMainQueue(
               [self.currDataAry removeAllObjects];
               [self.currDataAry addObjectsFromArray:newDataAry];
               [self.currTableView reloadData];
    )
}
- (void)addDataAry:(NSArray *)newDataAry
{
    if (!newDataAry.count) return;
    
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
        UITableViewRowAnimation defaultRowAnimation = UITableViewRowAnimationAutomatic;
        if (self.dataAryChangeAnimationBlock) {
            defaultRowAnimation = self.dataAryChangeAnimationBlock(SUIDataSourceChangeTypeRowInsert);
        }
        uMainQueue(
                   [self.currTableView  beginUpdates];
                   [self.currTableView  insertRowsAtIndexPaths:curIndexPathAry withRowAnimation:defaultRowAnimation];
                   [self.currTableView  endUpdates];
                   )
    }
}
- (void)insertDataAry:(NSArray *)newDataAry atIndexPath:(NSIndexPath *)cIndexPath
{
    if (!newDataAry.count) return;

    NSMutableArray *curDataSectionAry = nil;
    if (self.currDataAry.count <= cIndexPath.section)
    {
        curDataSectionAry = [NSMutableArray array];
        [self.currDataAry addObject:curDataSectionAry];
        uAssert(cIndexPath.section == 0, @"this may not be what you want");
    }
    else
    {
        curDataSectionAry = self.currDataAry[cIndexPath.section];
    }
    
    NSInteger curFlag = cIndexPath.row;
    if (curDataSectionAry.count < cIndexPath.row) curFlag = curDataSectionAry.count;
    
    NSMutableArray *curIndexPaths = [NSMutableArray arrayWithCapacity:newDataAry.count];
    NSMutableIndexSet *curIndexSet = [NSMutableIndexSet indexSet];
    [newDataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:curFlag+idx inSection:cIndexPath.section];
        [curIndexPaths addObject:curIndexPath];
        [curIndexSet addIndex:curFlag+idx];
    }];
    [curDataSectionAry insertObjects:newDataAry atIndexes:curIndexSet];
    
    UITableViewRowAnimation defaultRowAnimation = UITableViewRowAnimationAutomatic;
    if (self.dataAryChangeAnimationBlock) {
        defaultRowAnimation = self.dataAryChangeAnimationBlock(SUIDataSourceChangeTypeRowInsert);
    }
    uMainQueue(
               [self.currTableView  beginUpdates];
               [self.currTableView  insertRowsAtIndexPaths:curIndexPaths withRowAnimation:defaultRowAnimation];
               [self.currTableView  endUpdates];
               )
}

- (void)dataAryChangeAnimation:(SUITableExtenDataAryChangeAnimationBlock)cb
{
    self.dataAryChangeAnimationBlock = cb;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  TableView Delegate&DataSource
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.numberOfSectionsBlock) {
        return self.numberOfSectionsBlock(tableView);
    }
    return [self countOfSections:[self extenType]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.numberOfRowsBlock) {
        return self.numberOfRowsBlock(tableView, section);
    }
    return [self countOfRowsInSection:section type:[self extenType]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *currConfig = [self configureCell:indexPath tableView:tableView];
    id curModel = currConfig[1];
    SUIBaseCell *currCell = nil;
    if (self.cellForRowBlock) {
        currCell = self.cellForRowBlock(tableView, indexPath, curModel);
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
    return [self.currTableView fd_heightForCellWithIdentifier:currConfig[0] cacheByIndexPath:indexPath configuration:^(id cell) {
        SUIBaseCell *curCell = (SUIBaseCell *)cell;
        curCell.currModle = currConfig[1];
        [curCell displayWithCalculateCellHeight:curCell.currModle];
    }];
    
//    return [self.currTableView fd_heightForCellWithIdentifier:currConfig[0] configuration:^(id cell) {
//        SUIBaseCell *curCell = (SUIBaseCell *)cell;
//        curCell.currModle = currConfig[1];
//        [curCell displayWithCalculateCellHeight:curCell.currModle];
//    }];
}

- (NSArray *)configureCell:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    id currSourceData = [self currentModelAtIndex:indexPath tableView:tableView];
    NSString *curCellIdentifier = nil;
    if (self.cellIdentifiersBlock) {
        curCellIdentifier = self.cellIdentifiersBlock(tableView, indexPath, currSourceData);
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
    if (self.currentModelBlock) {
        return self.currentModelBlock(tableView, indexPath);
    }
    return [self currentModelAtIndexPath:indexPath type:[self extenType]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *currVC = tableView.theVC;
    currVC.destModel = [self currentModelAtIndex:indexPath tableView:tableView];
    if (self.didSelectRowBlock) {
        self.didSelectRowBlock(tableView, indexPath, currVC.destModel);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id curModel = [self currentModelAtIndex:indexPath tableView:tableView];
    if (self.willDisplayCellBlock) {
        self.willDisplayCellBlock(tableView, (SUIBaseCell *)cell, indexPath, curModel);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.didScrollBlock) {
        self.didScrollBlock((UITableView *)scrollView);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.willBeginDraggingBlock) {
        self.willBeginDraggingBlock((UITableView *)scrollView);
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
    if (self.fetchedResultsControllerDidChangeObjectBlock) {
        __block NSIndexPath *pIndexPath = indexPath;
        __block NSIndexPath *pNewIndexPath = newIndexPath;
        SUIReplaceIndexPath curReplaceIndexPath = ^(NSIndexPath *cIndexPath, NSIndexPath *cNewIndexPath) {
            pIndexPath = cIndexPath;
            pNewIndexPath = cNewIndexPath;
        };
        self.fetchedResultsControllerDidChangeObjectBlock(type, anObject, indexPath, newIndexPath, curReplaceIndexPath);
        indexPath = pIndexPath;
        newIndexPath = pNewIndexPath;
    }
    
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
            if ([self.deletedSectionIndexes containsIndex:indexPath.section]) return;
            [self.deletedRowIndexPaths addObject:indexPath];
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
    uWeakSelf
    
    [self.currTableView beginUpdates];
    [self fetchedResultsControllerChangeType:^(SUIDataSourceChangeType cType) {
        
        if (cType == SUIDataSourceChangeTypeReloadData)
        {
            [weakSelf.currTableView reloadData];
        }
        else
        {
            UITableViewRowAnimation curAnimation = UITableViewRowAnimationAutomatic;
            if (weakSelf.fetchedResultsControllerAnimationBlock) {
                curAnimation = weakSelf.fetchedResultsControllerAnimationBlock(cType);
            }
            
            switch (cType) {
                case SUIDataSourceChangeTypeMove:
                {
                    [weakSelf.currTableView deleteRowsAtIndexPaths:weakSelf.deletedRowIndexPaths withRowAnimation:curAnimation];
                    [weakSelf.currTableView insertRowsAtIndexPaths:weakSelf.insertedRowIndexPaths withRowAnimation:curAnimation];
                }
                    break;
                case SUIDataSourceChangeTypeRowInsert:
                {
                    [weakSelf.currTableView insertRowsAtIndexPaths:weakSelf.insertedRowIndexPaths withRowAnimation:curAnimation];
                }
                    break;
                case SUIDataSourceChangeTypeRowDelete:
                {
                    [weakSelf.currTableView deleteRowsAtIndexPaths:weakSelf.deletedRowIndexPaths withRowAnimation:curAnimation];
                }
                    break;
                case SUIDataSourceChangeTypeSectionInsert:
                {
                    [weakSelf.currTableView insertSections:weakSelf.insertedSectionIndexes withRowAnimation:curAnimation];
                }
                    break;
                case SUIDataSourceChangeTypeSectionDelete:
                {
                    [weakSelf.currTableView deleteSections:weakSelf.insertedSectionIndexes withRowAnimation:curAnimation];
                }
                    break;
                case SUIDataSourceChangeTypeUpdate:
                {
                    [weakSelf.currTableView reloadRowsAtIndexPaths:weakSelf.updatedRowIndexPaths withRowAnimation:curAnimation];
                }
                    break;
                default:
                    break;
            }
        }
    }];
    [self.currTableView endUpdates];
    
    if (weakSelf.fetchedResultsControllerDidChangeContentBlock) {
        [self fetchedResultsControllerChangeType:^(SUIDataSourceChangeType cType) {
            weakSelf.fetchedResultsControllerDidChangeContentBlock(cType);
        }];
    }
    
    self.insertedSectionIndexes = nil;
    self.deletedSectionIndexes = nil;
    self.deletedRowIndexPaths = nil;
    self.insertedRowIndexPaths = nil;
    self.updatedRowIndexPaths = nil;
}

- (void)fetchedResultsControllerChangeType:(void (^)(SUIDataSourceChangeType cType))cb
{
    NSInteger totalChanges = self.deletedSectionIndexes.count +
    self.insertedSectionIndexes.count +
    self.deletedRowIndexPaths.count +
    self.insertedRowIndexPaths.count +
    self.updatedRowIndexPaths.count;
    
    if (totalChanges > 50)
    {
        cb(SUIDataSourceChangeTypeReloadData);
        return;
    }
    
    if (self.insertedRowIndexPaths.count && self.deletedRowIndexPaths.count) {
        cb(SUIDataSourceChangeTypeMove);
    } else if (self.insertedRowIndexPaths.count) {
        cb(SUIDataSourceChangeTypeRowInsert);
    } else if (self.deletedRowIndexPaths.count) {
        cb(SUIDataSourceChangeTypeRowDelete);
    }
    
    if (self.insertedSectionIndexes.count) {
        cb(SUIDataSourceChangeTypeSectionInsert);
    }
    if (self.deletedSectionIndexes.count) {
        cb(SUIDataSourceChangeTypeSectionDelete);
    }
    
    if (self.updatedRowIndexPaths.count) {
        cb(SUIDataSourceChangeTypeUpdate);
    }
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
    if ([self requestBlock])
    {
        if (self.requesets.count) {
            [self.requesets makeObjectsPerformSelector:@selector(cancel)];
        }
        
        NSMutableDictionary *currParameters = [NSMutableDictionary dictionary];
        NSMutableArray *currNewDataAry = [NSMutableArray array];
        [self requestBlock](currParameters, nil, nil);
        
        uWeakSelf
        [[[self requestData:currParameters]
        parser:^(id cResponseObject) {
            [weakSelf requestBlock](nil, cResponseObject, currNewDataAry);
            uMainQueue
            (
             [weakSelf headerRefreshStop];
             [weakSelf footerRefreshStop];
             [weakSelf refreshTable:currNewDataAry];
            )
        }]
        completion:^(NSError *cError, id cResponseObject) {
            if (cError) {
                [weakSelf headerRefreshStop];
                [weakSelf footerRefreshStop];
            }
            
            if ([weakSelf requestCompletionBlock]) {
                [weakSelf requestCompletionBlock](cError, cResponseObject);
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

- (SUITableExtenRequestBlock)requestBlock
{
    return objc_getAssociatedObject(self, @selector(requestBlock));
}
- (void)setRequestBlock:(SUITableExtenRequestBlock)requestBlock
{
    objc_setAssociatedObject(self, @selector(requestBlock), requestBlock, OBJC_ASSOCIATION_COPY);
}

- (SUITableExtenRequestCompletionBlock)requestCompletionBlock
{
    return objc_getAssociatedObject(self, @selector(requestCompletionBlock));
}
- (void)setRequestCompletionBlock:(SUITableExtenRequestCompletionBlock)requestCompletionBlock
{
    objc_setAssociatedObject(self, @selector(requestCompletionBlock), requestCompletionBlock, OBJC_ASSOCIATION_COPY);
}

- (void)request:(SUITableExtenRequestBlock)cb
{
    [self request:cb completion:nil];
}
- (void)request:(SUITableExtenRequestBlock)cb completion:(SUITableExtenRequestCompletionBlock)completion
{
    [self setRequestBlock:cb];
    if (completion) [self setRequestCompletionBlock:completion];
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
