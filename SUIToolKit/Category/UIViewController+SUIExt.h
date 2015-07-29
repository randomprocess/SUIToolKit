//
//  UIViewController+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SUIBaseConfig.h"
#import "SUIDataSource.h"

@interface UIViewController (SUIExt)


#pragma mark - Property

@property (nonatomic,strong) UITableView *currTableView;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,copy) NSString *currIdentifier;
@property (nonatomic,strong) SUIDataSource *currDataSource;
@property (nonatomic,weak) id<SUIBaseProtocol> currDelegate;
@property (nonatomic,strong) id scrModel;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageIndex;



#pragma mark - IB

@property (nonatomic) IBInspectable BOOL addSearch;

@property (nonatomic) IBInspectable BOOL addHeader;
@property (nonatomic) IBInspectable BOOL addFooter;
@property (nonatomic) IBInspectable BOOL addHeaderAndRefreshStart;

@property (nonatomic) IBInspectable BOOL addLoading;



#pragma mark - Request

- (void)requestData:(NSDictionary *)parameters
          completed:(SUIDataSourceCompletionBlock)completed;

- (void)requestData:(NSDictionary *)parameters
            replace:(BOOL)replace
          completed:(SUIDataSourceCompletionBlock)completed;

- (void)requestData:(NSDictionary *)parameters
            replace:(BOOL)replace
       refreshTable:(SUIDataSourceRefreshTableBlock)refreshTable
          completed:(SUIDataSourceCompletionBlock)completed;


#pragma mark -

#pragma mark - Dismiss

- (IBAction)navPopToLast:(id)sender;
- (IBAction)navPopToRoot:(id)sender;
- (IBAction)navDismiss:(id)sender;

#pragma mark - LoadView

- (void)loadingViewShow;
- (void)loadingViewDissmiss;


@end
