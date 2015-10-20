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
    SUIFetchedResultsChangeTypeSectionInsert,
    SUIFetchedResultsChangeTypeRowInsert,
    SUIFetchedResultsChangeTypeSectionDelete,
    SUIFetchedResultsChangeTypeRowDelete,
    SUIFetchedResultsChangeTypeMove,
    SUIFetchedResultsChangeTypeUpdate,
    SUIFetchedResultsChangeTypeReloadData
} SUIFetchedResultsChangeType;

typedef void (^SUITableExtenRequestBlock)(NSMutableDictionary *cParameters, id cResponseObject, NSMutableArray *cNewDataAry);
typedef void (^SUITableExtenRequestCompletionBlock)(NSError *cError, id cResponseObject);

typedef SUIBaseCell *(^SUITableExtenCellForRowBlock)(NSIndexPath *cIndexPath, id cModel);
typedef NSString *(^SUITableExtenCellIdentifiersBlock)(NSIndexPath *cIndexPath, id cModel);
typedef void (^SUITableExtenDidSelectRowBlock)(NSIndexPath *cIndexPath, id cModel);
typedef void (^SUITableExtenWillDisplayCellBlock)(SUIBaseCell *cCell, NSIndexPath *cIndexPath, id cModel);
typedef void (^SUITableExtenDidScrollBlock)(void);
typedef void (^SUITableExtenWillBeginDraggingBlock)(void);

typedef NSArray *(^SUITableExtenSearchTextDidChangeBlock)(UISearchBar *cSearchBar, NSString *cSearchText, NSArray *cDataAry);
typedef void (^SUITableExtenFetchedResultsControllerWillChangeContentBlock)(NSFetchedResultsController *cController);
typedef void (^SUITableExtenFetchedResultsControllerDidChangeContentBlock)(NSFetchedResultsController *cController, SUIFetchedResultsChangeType cType);
typedef UITableViewRowAnimation (^SUITableExtenFetchedResultsControllerAnimationBlock)(NSFetchedResultsController *cController, SUIFetchedResultsChangeType cType);

@interface SUITableExten : NSObject <
    UITableViewDataSource,
    UITableViewDelegate,
    NSFetchedResultsControllerDelegate,
    UISearchControllerDelegate,
    UISearchControllerDelegate,
    UISearchDisplayDelegate,
    UISearchBarDelegate
    >

/**
 *  上拉或下拉的请求写在这个blocks中
 *
 *  @param cb 请求数据使用SUIRequestData类
 */
- (void)request:(SUITableExtenRequestBlock)cb;
- (void)request:(SUITableExtenRequestBlock)cb completion:(SUITableExtenRequestCompletionBlock)completion;

- (void)cellForRow:(SUITableExtenCellForRowBlock)cb;
- (void)cellIdentifiers:(SUITableExtenCellIdentifiersBlock)cb;
- (void)didSelectRow:(SUITableExtenDidSelectRowBlock)cb;
- (void)willDisplayCell:(SUITableExtenWillDisplayCellBlock)cb;
- (void)didScroll:(SUITableExtenDidScrollBlock)cb;
- (void)willBeginDragging:(SUITableExtenWillBeginDraggingBlock)cb;

- (void)searchTextDidChange:(SUITableExtenSearchTextDidChangeBlock)cb;
- (void)fetchResultControllerWillChangeContent:(SUITableExtenFetchedResultsControllerWillChangeContentBlock)cb;
- (void)fetchResultControllerDidChangeContent:(SUITableExtenFetchedResultsControllerDidChangeContentBlock)cb;
- (void)fetchResultControllerAnimation:(SUITableExtenFetchedResultsControllerAnimationBlock)cb;

- (SUITableExtenType)extenType;

- (void)resetDataAry:(NSArray *)newDataAry;
- (void)addDataAry:(NSArray *)newDataAry;

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

@end


@interface UITableView (SUIConfig)

- (void)accordingToBaseConfig;

@end


@interface UIViewController (SUIConfig)

- (void)accordingToBaseConfig;

@end
