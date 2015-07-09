//
//  UIViewController+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SUIExt)


#pragma mark - Property

@property (nonatomic,strong) UITableView *currTableView;
@property (nonatomic,copy) NSString *currIdentifier;
@property (nonatomic,strong) SUIDataSource *currDataSource;
@property (nonatomic,weak) id<SUIBaseProtocol> currDelegate;
@property (nonatomic,strong) id scrModel;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageIndex;



#pragma mark - IB

@property (nonatomic) IBInspectable BOOL addSearch;
@property (nonatomic) IBInspectable BOOL canDelete;

@property (nonatomic) IBInspectable BOOL addHeader;
@property (nonatomic) IBInspectable BOOL addFooter;
@property (nonatomic) IBInspectable BOOL addHeaderAndRefreshStart;



#pragma mark - Dismiss

- (IBAction)navPopToLast:(id)sender;
- (IBAction)navPopToRoot:(id)sender;
- (IBAction)navDismiss:(id)sender;


#pragma mark - Request

- (void)requestData:(NSDictionary *)parameters completed:(SUIDataSourceBlock)completed;
- (void)requestData:(NSDictionary *)parameters replace:(BOOL)replace completed:(SUIDataSourceBlock)completed;


@end
