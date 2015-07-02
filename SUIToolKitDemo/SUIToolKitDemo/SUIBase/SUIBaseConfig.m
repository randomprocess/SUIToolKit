//
//  SUIBaseConfig.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBaseConfig.h"

@implementation SUIBaseConfig

+ (instancetype)sharedConfig
{
    static SUIBaseConfig *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[self alloc] init];
    });
    return sharedSingleton;
}


#pragma mark -

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


// _____________________________________________________________________________

- (void)configureController:(id<SUIBaseProtocol>)curController
{
    // backgroundColor
    UIViewController *curVC = (UIViewController *)curController;
    curVC.view.backgroundColor = self.backgroundColor;
    
    // currIdentifier
    [self configureIdentifier:curController];
    
    // data processing
    SUIDataSource *curDataSource = [[SUIDataSource alloc] init];
    
    // currTableView
    if ([curController isKindOfClass:[UITableViewController class]])
    {
        curController.currTableView = ((UITableViewController *)curController).tableView;
        [self configureTableView:curController.currTableView tvc:YES];
        curController.currDataSource = curDataSource;
        curDataSource.dataSourceDelegate = curController;
    }
    else if ([curController isKindOfClass:[UIViewController class]])
    {
        for (UIView *subView in ((UIViewController *)curController).view.subviews)
        {
            if ([subView isKindOfClass:[UITableView class]])
            {
                curController.currTableView = (UITableView *)subView;
                [self configureTableView:curController.currTableView tvc:NO];
                curController.currDataSource = curDataSource;
                curController.currTableView.delegate = curController.currDataSource;
                curController.currTableView.dataSource = curController.currDataSource;
                curDataSource.dataSourceDelegate = curController;
                break;
            }
        }
    }
}

- (void)configureIdentifier:(id<SUIBaseProtocol>)curController
{
    NSString *currClassName = gClassName(curController);
    NSAssert([currClassName hasPrefix:@"SUI"], @"className prefix with 'SUI'");
    
    NSString *curSuffixStr = nil;
    if ([curController isKindOfClass:[UITableViewController class]])
    {
        curSuffixStr = @"TVC";
    }
    else if ([curController isKindOfClass:[UIViewController class]])
    {
        curSuffixStr = @"VC";
    }
    else
    {
        NSAssert(NO, @"unknown Class");
    }
    
    NSAssert([currClassName hasSuffix:curSuffixStr], @"className suffix with '%@'", curSuffixStr);
    NSRange curRange = NSMakeRange(3, currClassName.length-(3+curSuffixStr.length));
    curController.currIdentifier = [currClassName substringWithRange:curRange];
}

- (void)configureTableView:(UITableView *)curTableView tvc:(BOOL)tvc
{
    curTableView.separatorColor = self.separatorColor;
    curTableView.separatorInset = UIEdgeInsetsFromString(self.separatorInset);
    curTableView.backgroundColor = [UIColor clearColor];
    
    // 去掉tableView下方多余的分割线
    UIView *curFootView = [[UIView alloc] init];
    curFootView.frame = (CGRect){{0.0, 1.0}, {curTableView.width, 1.0}};
    curFootView.backgroundColor = [UIColor clearColor];
    curTableView.tableFooterView = curFootView;
    
    UIView *curBackgroundView = [[UIView alloc] init];
    curTableView.backgroundView = curBackgroundView;
    
    if (tvc)
    {
        curBackgroundView.frame = curTableView.bounds;
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
