//
//  UIViewController+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SUIBaseProtocol.h"
#import "SUIBaseExten.h"

@interface UIViewController (SUIExt)


#pragma mark - Property

@property (nonatomic,weak) UITableView *currTableView;
@property (nonatomic,copy) NSString *currIdentifier;
@property (nonatomic,strong) SUIBaseExten *currExten;
@property (nonatomic,weak) id<SUIBaseProtocol> currDelegate;
@property (nonatomic,strong) id scrModel;

#pragma mark - IB

@property (nonatomic) IBInspectable BOOL addSearch;

@property (nonatomic) IBInspectable BOOL addHeader;
@property (nonatomic) IBInspectable BOOL addFooter;
@property (nonatomic) IBInspectable BOOL addHeaderAndRefreshStart;

@property (nonatomic) IBInspectable BOOL addLoading;


#pragma mark - Dismiss

- (IBAction)navPopToLast:(id)sender;
- (IBAction)navPopToRoot:(id)sender;
- (IBAction)navDismiss:(id)sender;


#pragma mark - LoadingView

@property (nonatomic,strong) UIView *loadingView;

- (void)loadingViewShow;
- (void)loadingViewDissmiss;


@end
