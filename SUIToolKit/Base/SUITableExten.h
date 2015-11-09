//
//  SUITableExten.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/9/23.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SUIBaseCell;

typedef enum : NSUInteger {
    SUITableExtenTypeNormal,
    SUITableExtenTypeSearch,
    SUITableExtenTypeFetch
} SUITableExtenType;

typedef enum : NSUInteger {
    SUIDataSourceChangeTypeSectionInsert,
    SUIDataSourceChangeTypeRowInsert,
    SUIDataSourceChangeTypeSectionDelete,
    SUIDataSourceChangeTypeRowDelete,
    SUIDataSourceChangeTypeMove,
    SUIDataSourceChangeTypeUpdate,
    SUIDataSourceChangeTypeReloadData
} SUIDataSourceChangeType;

typedef NSDictionary *(^SUITableViewRequestBlock)(void);
typedef NSArray *(^SUITableViewParserBlock)(id cResponseObject);
typedef void (^SUITableViewRequestCompletionBlock)(NSError *cError, id cResponseObject);

typedef SUIBaseCell *(^SUITableExtenCellForRowBlock)(UITableView *cTableView, NSIndexPath *cIndexPath, id cModel);
typedef NSString *(^SUITableExtenCellIdentifiersBlock)(UITableView *cTableView, NSIndexPath *cIndexPath, id cModel);
typedef void (^SUITableExtenDidSelectRowBlock)(UITableView *cTableView, NSIndexPath *cIndexPath, id cModel);
typedef void (^SUITableExtenWillDisplayCellBlock)(UITableView *cTableView, __kindof SUIBaseCell *cCell, NSIndexPath *cIndexPath, id cModel);
typedef void (^SUITableExtenDidScrollBlock)(UITableView *cTableView);
typedef void (^SUITableExtenWillBeginDraggingBlock)(UITableView *cTableView);

typedef NSInteger (^SUITableExtenNumberOfSectionsBlock)(UITableView *cTableView);
typedef NSInteger (^SUITableExtenNumberOfRowsBlock)(UITableView *cTableView, NSInteger cSection);
typedef id (^SUITableExtenCurrentModelBlock)(UITableView *cTableView, NSIndexPath *cIndexPath);

typedef NSArray *(^SUITableExtenSearchTextDidChangeBlock)(UISearchBar *cSearchBar, NSString *cSearchText, NSArray *cDataAry);
typedef void (^SUITableExtenFetchedResultsControllerWillChangeContentBlock)();
typedef void (^SUIReplaceIndexPath)(NSIndexPath *cIndexPath, NSIndexPath *cNewIndexPath);
typedef void (^SUITableExtenFetchedResultsControllerDidChangeObjectBlock)(NSFetchedResultsChangeType cType, id cObject, NSIndexPath *indexPath, NSIndexPath *newIndexPath, SUIReplaceIndexPath replaceIndexPath);
typedef void (^SUITableExtenFetchedResultsControllerDidChangeContentBlock)(SUIDataSourceChangeType cType);
typedef UITableViewRowAnimation (^SUITableExtenFetchedResultsControllerAnimationBlock)(SUIDataSourceChangeType cType);
typedef UITableViewRowAnimation (^SUITableExtenDataAryChangeAnimationBlock)(SUIDataSourceChangeType cType);

@interface SUITableExten : NSObject <
    UITableViewDataSource,
    UITableViewDelegate,
    NSFetchedResultsControllerDelegate,
    UISearchControllerDelegate,
    UISearchControllerDelegate,
    UISearchDisplayDelegate,
    UISearchBarDelegate
    >

- (void)cellForRow:(SUITableExtenCellForRowBlock)cb;
- (void)cellIdentifiers:(SUITableExtenCellIdentifiersBlock)cb;
- (void)didSelectRow:(SUITableExtenDidSelectRowBlock)cb;
- (void)willDisplayCell:(SUITableExtenWillDisplayCellBlock)cb;
- (void)didScroll:(SUITableExtenDidScrollBlock)cb;
- (void)willBeginDragging:(SUITableExtenWillBeginDraggingBlock)cb;

- (void)numberOfSections:(SUITableExtenNumberOfSectionsBlock)cb;
- (void)numberOfRows:(SUITableExtenNumberOfRowsBlock)cb;
- (void)currentModel:(SUITableExtenCurrentModelBlock)cb;

- (void)searchTextDidChange:(SUITableExtenSearchTextDidChangeBlock)cb;
- (void)fetchResultControllerWillChangeContent:(SUITableExtenFetchedResultsControllerWillChangeContentBlock)cb;
- (void)fetchResultControllerDidChangeObject:(SUITableExtenFetchedResultsControllerDidChangeObjectBlock)cb;
- (void)fetchResultControllerAnimation:(SUITableExtenFetchedResultsControllerAnimationBlock)cb;
- (void)fetchResultControllerDidChangeContent:(SUITableExtenFetchedResultsControllerDidChangeContentBlock)cb;

- (SUITableExtenType)extenType;
- (NSInteger)countOfSections:(SUITableExtenType)cType;
- (NSInteger)countOfRowsInSection:(NSInteger)cSection type:(SUITableExtenType)cType;
- (id)currentModelAtIndexPath:(NSIndexPath *)cIndexPath type:(SUITableExtenType)cType;

- (void)resetDataAry:(NSArray *)newDataAry; // [[Model]]
- (void)addDataAry:(NSArray *)newDataAry; // [[Model]]
- (void)insertDataAry:(NSArray *)newDataAry atIndexPath:(NSIndexPath *)cIndexPath; // [Model]
- (void)dataAryChangeAnimation:(SUITableExtenDataAryChangeAnimationBlock)cb;

@end


@interface UITableView (SUITableExten)

@property (nonatomic,strong) SUITableExten *tableExten;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic) IBInspectable BOOL addHeader;
@property (nonatomic) IBInspectable BOOL addFooter;
@property (nonatomic) IBInspectable BOOL addHeaderAndRefreshStart;
@property (nonatomic) IBInspectable BOOL addSearch;

@property (nonatomic) BOOL loadMoreData;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) NSInteger pageIndex;

- (void)addRefreshHeader;
- (void)headerRefreshSteart;
- (void)addRefreshFooter;
- (void)hideRefreshFooter:(BOOL)hidden;
- (void)headerRefreshStop;
- (void)footerRefreshStop;

- (void)refreshTable:(NSArray *)newDataAry;

- (void)request:(SUITableViewRequestBlock)rCb completion:(SUITableViewRequestCompletionBlock)completion;
- (void)request:(SUITableViewRequestBlock)rCb parser:(SUITableViewParserBlock)pCb completion:(SUITableViewRequestCompletionBlock)completion;

@end


@interface UITableView (SUIConfig)

- (void)accordingToBaseConfig;

@end


@interface UIViewController (SUIConfig)

- (void)accordingToBaseConfig;

@end
