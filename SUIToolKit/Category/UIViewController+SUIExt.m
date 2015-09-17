//
//  UIViewController+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UIViewController+SUIExt.h"
#import <objc/runtime.h>
#import "SUIToolKitConst.h"
#import "SUIBaseConfig.h"
#import "SUITableDataSource.h"
#import "UIScrollView+EmptyDataSet.h"

@implementation UIViewController (SUIExt)

#pragma mark - Property

- (UITableView *)currTableView
{
    return objc_getAssociatedObject(self, @selector(currTableView));
}
- (void)setCurrTableView:(UITableView *)currTableView
{
    objc_setAssociatedObject(self, @selector(currTableView), currTableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)currIdentifier
{
    id curIdentifier = objc_getAssociatedObject(self, @selector(currIdentifier));
    if (curIdentifier) return curIdentifier;
    
    NSString *currClassName = gClassName(self);
    NSAssert([currClassName hasPrefix:@"SUI"], @"className prefix with 'SUI'");
    
    NSString *curSuffixStr = nil;
    if ([self isKindOfClass:[UITableViewController class]]) {
        curSuffixStr = @"TVC";
    } else if ([self isKindOfClass:[UIViewController class]]) {
        curSuffixStr = @"VC";
    } else {
        NSAssert(NO, @"unknown Class");
    }
    
    NSAssert([currClassName hasSuffix:curSuffixStr], @"className suffix with '%@'", curSuffixStr);
    NSRange curRange = NSMakeRange(3, currClassName.length-(3+curSuffixStr.length));
    curIdentifier = [currClassName substringWithRange:curRange];
    self.currIdentifier = curIdentifier;
    return curIdentifier;
}
- (void)setCurrIdentifier:(NSString *)currIdentifier
{
    objc_setAssociatedObject(self, @selector(currIdentifier), currIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SUIBaseExten *)currExten
{
    id curExten = objc_getAssociatedObject(self, @selector(currExten));
    if (curExten) return curExten;
    
    SUIBaseExten *currBaseExten = [SUIBaseExten new];
    curExten = currBaseExten;
    self.currExten = curExten;
    return curExten;
}
- (void)setCurrExten:(SUIBaseExten *)currExten
{
    objc_setAssociatedObject(self, @selector(currExten), currExten, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<SUIBaseProtocol>)currDelegate
{
    return objc_getAssociatedObject(self, @selector(currDelegate));
}
- (void)setCurrDelegate:(id<SUIBaseProtocol>)currDelegate
{
    objc_setAssociatedObject(self, @selector(currDelegate), currDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id)scrModel
{
    id curScrModel = nil;
    
    if ([self.currDelegate respondsToSelector:@selector(modelPassed)]) {
        curScrModel = [self.currDelegate modelPassed];
    } else {
        curScrModel = self.currDelegate.currTableView.currDataSource.scrModel;
    }
    
    return curScrModel;
}
- (void)setScrModel:(id)scrModel
{
    objc_setAssociatedObject(self, @selector(scrModel), scrModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - IB


- (BOOL)addSearch
{
    return [objc_getAssociatedObject(self, @selector(addSearch)) boolValue];
}
- (void)setAddSearch:(BOOL)addSearch
{
    objc_setAssociatedObject(self, @selector(addSearch), @(addSearch), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)addHeader
{
    return [objc_getAssociatedObject(self, @selector(addHeader)) boolValue];
}
- (void)setAddHeader:(BOOL)addHeader
{
    objc_setAssociatedObject(self, @selector(addHeader), @(addHeader), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)addFooter
{
    return [objc_getAssociatedObject(self, @selector(addFooter)) boolValue];
}
- (void)setAddFooter:(BOOL)addFooter
{
    objc_setAssociatedObject(self, @selector(addFooter), @(addFooter), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)addHeaderAndRefreshStart
{
    return [objc_getAssociatedObject(self, @selector(addHeaderAndRefreshStart)) boolValue];
}
- (void)setAddHeaderAndRefreshStart:(BOOL)addHeaderAndRefreshStart
{
    objc_setAssociatedObject(self, @selector(addHeaderAndRefreshStart), @(addHeaderAndRefreshStart), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)addLoading
{
    return [objc_getAssociatedObject(self, @selector(addLoading)) boolValue];
}
- (void)setAddLoading:(BOOL)addLoading
{
    objc_setAssociatedObject(self, @selector(addLoading), @(addLoading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)addEmptyDataSet
{
    return [objc_getAssociatedObject(self, @selector(addEmptyDataSet)) boolValue];
}
- (void)setAddEmptyDataSet:(BOOL)addEmptyDataSet
{
    objc_setAssociatedObject(self, @selector(addEmptyDataSet), @(addEmptyDataSet), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Dismiss

- (IBAction)navPopToLast:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)navPopToRoot:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)navDismiss:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - LoadView

- (UIView *)loadingView
{
    UIView *curLoadingView = objc_getAssociatedObject(self, @selector(loadingView));
    if (curLoadingView == nil)
    {
        if ([SUIBaseConfig sharedConfig].classNameOfLoadingView) {
            curLoadingView = [[NSClassFromString([SUIBaseConfig sharedConfig].classNameOfLoadingView) alloc] init];
        } else {
            curLoadingView = [[UIView alloc] init];
            curLoadingView.contentMode = UIViewContentModeCenter;
            UIActivityIndicatorView *curActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [curActivityIndicatorView sizeToFit];
            [curActivityIndicatorView startAnimating];
            [curLoadingView addSubview:curActivityIndicatorView];
        }
        curLoadingView.frame = self.view.bounds;
        curLoadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.loadingView = curLoadingView;
    }
    return curLoadingView;
}
- (void)setLoadingView:(UIView *)loadingView
{
    objc_setAssociatedObject(self, @selector(loadingView), loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)loadingViewShow
{
    [self.view addSubview:self.loadingView];
}
- (void)loadingViewDissmiss
{
    if (self.loadingView.superview)
    {
        uWeakSelf
        [UIView animateWithDuration:0.25
                         animations:^{
                             weakSelf.loadingView.alpha = 0;
                         } completion:^(BOOL finished) {
                             [weakSelf.loadingView removeFromSuperview];
                         }];
    }
}





@end
