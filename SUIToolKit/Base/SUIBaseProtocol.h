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

@class SUITableDataSource, SUIBaseCell, SUIDropdownTitleMenu;


typedef NS_ENUM(NSInteger, SUISwipeDirection) {
    SUISwipeDirectionToRight = 0,
    SUISwipeDirectionToLeft = 1
};

@protocol SUIBaseProtocol <NSObject>
@optional


#pragma mark - Properties added

@property (nonatomic,strong) UITableView *currTableView;
@property (nonatomic,copy) NSString *currIdentifier;


/** 在属性检查器中设置, 或代码写在调用configureController()之前 */
#pragma mark - Attributes inspector

/** 将介个addSearch设置为On, 则会在currTableView的tableHeaderView添加搜索框 */
@property (nonatomic) BOOL addSearch;

/** 添加下拉刷新 */
@property (nonatomic) BOOL addHeader;
/** 添加上拉加载更多 */
@property (nonatomic) BOOL addFooter;
/** 添加下拉刷新,并自动下拉 */
@property (nonatomic) BOOL addHeaderAndRefreshStart;


@property (nonatomic) BOOL addLoading;

@property (nonatomic) BOOL addEmptyDataSet;


// _____________________________________________________________________________



#pragma mark - Frequently used

/**
 *  有下拉或上拉的请求写在这个方法内, 请求数据调用requestData()
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


#pragma mark - TableView

- (SUIBaseCell *)suiTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath cModel:(id)cModel;
- (void)suiTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath cModel:(id)cModel;
- (void)suiTableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath cModel:(id)cModel;

- (void)suiScrollViewDidScroll:(UIScrollView *)scrollView;


#pragma mark - SearchBar

- (NSArray *)suiSearchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText dataAry:(NSArray *)cDataAry;


#pragma mark - SwipeTableCell

- (BOOL)suiSwipeTableCell:(SUIBaseCell *)curCell canSwipe:(SUISwipeDirection)direction cModel:(id)cModel;
/** @return [UIButton] */
- (NSArray *)suiSwipeTableCell:(SUIBaseCell *)curCell direction:(SUISwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings cModel:(id)cModel;
- (BOOL)suiSwipeTableCell:(SUIBaseCell *)curCell tappedAtIndex:(NSInteger)index direction:(SUISwipeDirection)direction cModel:(id)cModel;


#pragma mark - FetchedResults

- (void)suiFetchedResultsControllerWillChangeContent:(NSFetchedResultsController *)controller;
//- (void)suiFetchedResultsController:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
//- (void)suiFetchedResultsController:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
- (void)suiFetchedResultsControllerDidChangeContent:(NSFetchedResultsController *)controller;


#pragma mark - DropdownTitleMenu

/** @return [TitleString] */
- (NSArray *)suiDropdownTitleMenuTitles:(SUIDropdownTitleMenu *)cView;
/** @return [View] */
- (NSArray *)suiDropdownTitleMenuViews:(SUIDropdownTitleMenu *)cView;
- (void)suiDropdownTitleMenuDidSelectAtIndex:(NSInteger)curIndex;


#pragma mark - EmptyDataSet

- (NSAttributedString *)suiEmptyDataSetTitleForScrollView:(UIScrollView *)scrollView;
- (NSAttributedString *)suiEmptyDataSetDescriptionForScrollView:(UIScrollView *)scrollView;
- (UIImage *)suiEmptyDataSetImageForScrollView:(UIScrollView *)scrollView;
- (UIView *)suiEmptyDataSetCustomViewForScrollView:(UIScrollView *)scrollView generalView:(UIView *)generalView;

- (BOOL)suiEmptyDataSetShouldDisplay:(UIScrollView *)scrollView; // Default is NO;
- (BOOL)suiEmptyDataSetShouldAllowTouch:(UIScrollView *)scrollView; // Default is YES;
- (BOOL)suiEmptyDataSetShouldAllowScroll:(UIScrollView *)scrollView; // Default is YES;
- (void)suiEmptyDataSetDidTapView:(UIScrollView *)scrollView; // Default is YES;


#pragma mark -

#pragma mark Dismiss

- (IBAction)navPopToLast:(id)sender;
- (IBAction)navPopToRoot:(id)sender;
- (IBAction)navDismiss:(id)sender;

#pragma mark LoadingView

- (void)loadingViewShow;
- (void)loadingViewDissmiss;



@end

