//
//  SUIBaseConfig.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBaseConfig.h"
#import "SUIToolKitConst.h"
#import "UIScrollView+EmptyDataSet.h"


@implementation SUIBaseConfig


#pragma mark - Shared

+ (instancetype)sharedConfig
{
    static SUIBaseConfig *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[self alloc] init];
    });
    return sharedSingleton;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _requesets = [NSMutableArray array];
    }
    return self;
}


#pragma mark - Http

- (NSString *)httpMethod
{
    if (_httpMethod == nil)
    {
        _httpMethod = @"POST";
    }
    return _httpMethod;
}

- (NSString *)httpHost
{
    if (_httpHost == nil)
    {
        NSAssert(NO, @"should set httpHost");
    }
    return _httpHost;
}


#pragma mark - VC

- (UIColor *)backgroundColor
{
    if (_backgroundColor == nil)
    {
        return [UIColor whiteColor];
    }
    return _backgroundColor;
}

- (UIColor *)separatorColor
{
    if (_separatorColor == nil)
    {
        return gRGB(20, 20, 20);
    }
    return _separatorColor;
}

- (NSString *)separatorInset
{
    if (_separatorInset == nil)
    {
        return @"{0,10,0,0}";
    }
    return _separatorInset;
}

- (NSInteger)pageSize
{
    if (_pageSize == 0)
    {
        _pageSize = 20;
    }
    return _pageSize;
}



#pragma mark -

- (void)configureController:(id<SUIBaseProtocol>)cController
{
    // backgroundColor
    UIViewController *curVC = (UIViewController *)cController;
    curVC.view.backgroundColor = self.backgroundColor;
    
    // currIdentifier
    [self configureIdentifier:cController];
    
    // data processing
    [self configureDataSource:cController];
    
    // loadingView
    [self configureLoadingView:cController];
}

- (void)configureIdentifier:(id<SUIBaseProtocol>)cController
{
    NSString *currClassName = gClassName(cController);
    NSAssert([currClassName hasPrefix:@"SUI"], @"className prefix with 'SUI'");
    
    NSString *curSuffixStr = nil;
    if ([cController isKindOfClass:[UITableViewController class]])
    {
        curSuffixStr = @"TVC";
    }
    else if ([cController isKindOfClass:[UIViewController class]])
    {
        curSuffixStr = @"VC";
    }
    else
    {
        NSAssert(NO, @"unknown Class");
    }
    
    NSAssert([currClassName hasSuffix:curSuffixStr], @"className suffix with '%@'", curSuffixStr);
    NSRange curRange = NSMakeRange(3, currClassName.length-(3+curSuffixStr.length));
    cController.currIdentifier = [currClassName substringWithRange:curRange];
}

- (void)configureDataSource:(id<SUIBaseProtocol>)cController
{
    if ([cController isKindOfClass:[UITableViewController class]])
    {
        cController.currTableView = ((UITableViewController *)cController).tableView;
        [self configureTableView:cController.currTableView tvc:YES];
        cController.currTableView.currDataSource.dataSourceDelegate = cController;
    }
    else if ([cController isKindOfClass:[UIViewController class]])
    {
        for (UIView *subView in ((UIViewController *)cController).view.subviews)
        {
            if ([subView isKindOfClass:[UITableView class]])
            {
                UITableView *curTableView = (UITableView *)subView;
                if (cController.currTableView == nil) {
                    cController.currTableView = curTableView;
                }
                
                [self configureTableView:curTableView tvc:NO];
                curTableView.currDataSource.dataSourceDelegate = cController;
                
                curTableView.delegate = curTableView.currDataSource;
                curTableView.dataSource = curTableView.currDataSource;
                break;
            }
        }
    }
}

- (void)configureTableView:(UITableView *)cTableView tvc:(BOOL)tvc
{
    cTableView.separatorColor = self.separatorColor;
    cTableView.separatorInset = UIEdgeInsetsFromString(self.separatorInset);
    cTableView.backgroundColor = [UIColor clearColor];
    cTableView.tableFooterView = [UIView new];
    
    UIView *curBackgroundView = [[UIView alloc] init];
    cTableView.backgroundView = curBackgroundView;
    
    if (tvc)
    {
        curBackgroundView.frame = cTableView.bounds;
        curBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        curBackgroundView.backgroundColor = self.backgroundColor;
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

- (void)configureLoadingView:(id<SUIBaseProtocol>)curController
{
    if ([curController addLoading])
    {
        [curController loadingViewShow];
    }
}


@end
