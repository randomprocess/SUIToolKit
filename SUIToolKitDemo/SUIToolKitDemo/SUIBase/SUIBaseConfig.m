//
//  SUIBaseConfig.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBaseConfig.h"

@interface SUIBaseConfig ()

@end

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
    // 统一背景颜色
    UIViewController *curVC = (UIViewController *)curController;
    curVC.view.backgroundColor = self.backgroundColor;
    
    // 设置Identifier
    [self configureIdentifier:curController];
    
    // 设置currTableView
    if ([curController isKindOfClass:[SUIBaseVC class]])
    {
        for (UIView *subView in ((SUIBaseVC *)curController).view.subviews)
        {
            if ([subView isKindOfClass:[UITableView class]])
            {
                curController.currTableView = (UITableView *)subView;
                break;
            }
        }
    }
    
    // 用来处理数据
    SUIDataSource *curDataSource = [[SUIDataSource alloc] init];
    curDataSource.dataSourceDelegate = curController;
    
    // 统一tableView样式和代理
    if (curController.currTableView)
    {
        [self configureTableView:curController.currTableView];
        
        curController.currDataSource = curDataSource;
        curController.currTableView.delegate = curController.currDataSource;
        curController.currTableView.dataSource = curController.currDataSource;
    }
}

- (void)configureIdentifier:(id<SUIBaseProtocol>)curController
{
    NSString *currClassName = gClassName(curController);
    NSAssert([currClassName hasPrefix:@"SUI"], @"className prefix with 'SUI'");
    
    NSString *curSuffixStr = nil;
    if ([curController isKindOfClass:[SUIBaseVC class]])
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

- (void)configureTableView:(UITableView *)curTableView
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
    curBackgroundView.backgroundColor = [UIColor clearColor];
    curTableView.backgroundView = curBackgroundView;
    
    // estimatedRowHeight 默认为0
    // ios7计算cell动态高度应为0, ios8应不为0, 不计算高度应该给个值
    // .... 方便起见, 干脆为0好了 > <....
    //curTableView.estimatedRowHeight = curTableView.rowHeight;
}



@end
