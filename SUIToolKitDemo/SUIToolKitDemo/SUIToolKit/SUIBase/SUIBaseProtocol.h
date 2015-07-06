//
//  SUIBaseProtocol.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

@class SUIDataSource;

@protocol SUIBaseProtocol <NSObject>
@optional


#pragma mark - Properties added

@property (nonatomic,strong) UITableView *currTableView;
@property (nonatomic,copy) NSString *currIdentifier;
@property (nonatomic,strong) SUIDataSource *currDataSource;



/** 在属性检查器中设置, 或代码写在调用configureController()之前 */
#pragma mark - Attributes inspector

/**
 *  1.搜索框或搜索按钮
 *
 *      -> 将介个addSearch设置为On, 则会在currTableView的tableHeaderView添加搜索框
 *      -> 如果是自己添加的搜索按钮, 连线搜索按钮的点击事件到searchButtonAction()
 *
 *  2.自定义resultsVC
 *
 *      -> 需要自定义resultsVC, 则searchIdentifier填入与新建VC中Storyboard ID相同的字符串
 *      -> 不需要自定义resultsVC, 则不需要填写searchIdentifier
 *
 *      -> 注: 现在currTableView分组或resultsTableView需分组则必须自定义
 */
@property (nonatomic) BOOL addSearch;
@property (nonatomic,copy) NSString *searchIdentifier;

/** tableView左滑删除 */
@property (nonatomic) BOOL canDelete;

/** 添加下拉刷新 */
@property (nonatomic) BOOL addHeader;
/** 添加上拉加载更多 */
@property (nonatomic) BOOL addFooter;
/** 添加下拉刷新,并自动下拉 */
@property (nonatomic) BOOL addHeaderAndRefreshStart;

// _____________________________________________________________________________



#pragma mark - Frequently used

/**
 *  有下拉或上拉的请求写在这个方法内, 请求数据调用requestData()
 */
- (void)handlerMainLoadData:(BOOL)loadMoreData;


/**
 *  将cell上视图的Touch事件连线到cell的doAction()后在这个方法内处理
 */
- (void)doAction:(id)sender cModel:(id)cModel;



#pragma mark - TableView grouping

/**
 *  tableView分组时将cell的类名对应写在这个数组内, 格式为[[""]]
 *
 *  @return 默认返回的数组为[["SUI"+currIdentifier+"Cell"]]
 */
- (NSArray *)arrayOfCellIdentifier;


/**
 *  用于BasePushSegue的model传递, tableView分组时需要实现
 */
- (id)modelPassed;


/**
 *  点击了搜索按钮推出搜索控制器
 */
- (IBAction)searchButtonAction:(id)sender;



#pragma mark - TableView delegate & dataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath cModel:(id)cModel;

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath cModel:(id)cModel; //不实现这个方法,则根据IB中canDelete属性
- (void)tableView:(UITableView *)tableView commitRowAtIndexPath:(NSIndexPath *)indexPath cModel:(id)cModel;



#pragma mark - Dismiss

- (IBAction)navPopToLast:(id)sender;
- (IBAction)navPopToRoot:(id)sender;
- (IBAction)navDismiss:(id)sender;

@end

