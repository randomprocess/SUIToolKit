//
//  SUIBaseProtocol.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MGSwipeTableCell.h"

@class SUITableDataSource, SUIBaseCell, SUIDropdownTitleMenu, SUIEmojiSection, SUIEmojiItem;


typedef NS_ENUM(NSInteger, SUISwipeDirection) {
    SUISwipeDirectionToRight = 0,
    SUISwipeDirectionToLeft = 1
};


// _____________________________________________________________________________

@protocol SUIBaseProtocol <NSObject>
@optional


#pragma mark - Properties added

@property (nonatomic,strong) UITableView *currTableView;
@property (nonatomic,copy) NSString *currIdentifier;


// _____________________________________________________________________________

#pragma mark - Attributes inspector

/** 将介个addSearch设置为On, 则会在currTableView的tableHeaderView添加搜索框 */
@property (nonatomic) BOOL addSearch;

@property (nonatomic) BOOL addHeader;
@property (nonatomic) BOOL addFooter;
@property (nonatomic) BOOL addHeaderAndRefreshStart;

@property (nonatomic) BOOL addLoading;
@property (nonatomic) BOOL addEmptyDataSet;


// _____________________________________________________________________________

#pragma mark - Frequently used

/**
 *  有下拉或上拉的请求写在这个方法内, 请求数据使用SUIRequestData类
 */
- (void)handlerMainRequest:(BOOL)loadMoreData;

/**
 *  将cell上视图的Touch事件连线到cell的doAction()后在这个方法内处理
 */
- (void)handlerAction:(id)sender cModel:(id)cModel;


#pragma mark - TableView grouping

/**
 *  tableView分组时将cell的类名对应写在这个数组内, 格式为[[""]]
 *
 *  @return 默认返回的数组为[["SUI"+currIdentifier+"Cell"]]
 */
- (NSArray *)arrayOfCellIdentifier;

/**
 *  用于BasePushSegue的model传递
 */
- (id)modelPassed;


// _____________________________________________________________________________

#pragma mark - Primary

#pragma mark TableView

- (SUIBaseCell *)suiTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath cModel:(id)cModel;
- (void)suiTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath cModel:(id)cModel;
- (void)suiTableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath cModel:(id)cModel;

- (void)suiScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)suiScrollViewWillBeginDragging:(UIScrollView *)scrollView;


#pragma mark SearchBar

- (NSArray *)suiSearchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText dataAry:(NSArray *)cDataAry;


#pragma mark FetchedResults

- (void)suiFetchedResultsControllerWillChangeContent:(NSFetchedResultsController *)controller;
//- (void)suiFetchedResultsController:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
//- (void)suiFetchedResultsController:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
- (void)suiFetchedResultsControllerDidChangeContent:(NSFetchedResultsController *)controller;


// _____________________________________________________________________________

#pragma mark - SUIToolKit

#pragma mark SUIEmojiView

/** [SUIEmojiSection] */
- (NSArray *)suiEmojiViewSections;

- (void)suiEmojiViewTapItem:(SUIEmojiItem *)cItem;
- (void)suiEmojiViewTapDeleteItem;
- (void)suiEmojiViewTapSendBtn;


// _____________________________________________________________________________

#pragma mark - Vendor

#pragma mark SwipeTableCell

- (BOOL)suiSwipeTableCell:(SUIBaseCell *)curCell canSwipe:(SUISwipeDirection)direction cModel:(id)cModel;
/** @return [UIButton] */
- (NSArray *)suiSwipeTableCell:(SUIBaseCell *)curCell direction:(SUISwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings cModel:(id)cModel;
- (BOOL)suiSwipeTableCell:(SUIBaseCell *)curCell tappedAtIndex:(NSInteger)index direction:(SUISwipeDirection)direction cModel:(id)cModel;


// _____________________________________________________________________________

#pragma mark - Others

#pragma mark Dismiss

- (IBAction)navPopToLast:(id)sender;
- (IBAction)navPopToRoot:(id)sender;
- (IBAction)navDismiss:(id)sender;

#pragma mark LoadingView

- (void)loadingViewShow;
- (void)loadingViewDissmiss;



@end

