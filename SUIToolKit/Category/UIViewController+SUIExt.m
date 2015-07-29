//
//  UIViewController+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UIViewController+SUIExt.h"
#import <objc/runtime.h>
#import "MagicalRecord.h"

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

- (NSFetchedResultsController *)fetchedResultsController
{
    return objc_getAssociatedObject(self, @selector(fetchedResultsController));
}
- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    objc_setAssociatedObject(self, @selector(fetchedResultsController), fetchedResultsController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    fetchedResultsController.delegate = self.currDataSource;
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *curManagedObjectContext = objc_getAssociatedObject(self, @selector(managedObjectContext));
    if (curManagedObjectContext) {
        return curManagedObjectContext;
    }
    curManagedObjectContext = [NSManagedObjectContext MR_defaultContext];
    self.managedObjectContext = curManagedObjectContext;
    return curManagedObjectContext;
}
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    objc_setAssociatedObject(self, @selector(managedObjectContext), managedObjectContext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)currIdentifier
{
    return objc_getAssociatedObject(self, @selector(currIdentifier));
}
- (void)setCurrIdentifier:(NSString *)currIdentifier
{
    objc_setAssociatedObject(self, @selector(currIdentifier), currIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SUIDataSource *)currDataSource
{
    return objc_getAssociatedObject(self, @selector(currDataSource));
}
- (void)setCurrDataSource:(NSMutableArray *)currDataSource
{
    objc_setAssociatedObject(self, @selector(currDataSource), currDataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    id curScrModel = objc_getAssociatedObject(self, @selector(scrModel));
    if (curScrModel) {
        return curScrModel;
    }
    
    if ([self.currDelegate respondsToSelector:@selector(modelPassed)]) {
        curScrModel = [self.currDelegate modelPassed];
    } else {
        curScrModel = [[self.currDelegate currDataSource] modelPassed];
    }
    self.scrModel = curScrModel;
    return curScrModel;
}
- (void)setScrModel:(id)scrModel
{
    objc_setAssociatedObject(self, @selector(scrModel), scrModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)pageSize
{
    NSInteger curPageSize = [objc_getAssociatedObject(self, @selector(pageSize)) integerValue];
    if (curPageSize == 0) {
        curPageSize = [SUIBaseConfig sharedConfig].pageSize;
    }
    self.pageSize = curPageSize;
    return curPageSize;
}
- (void)setPageSize:(NSInteger)pageSize
{
    objc_setAssociatedObject(self, @selector(pageSize), @(pageSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)pageIndex
{
    return [objc_getAssociatedObject(self, @selector(pageIndex)) integerValue];
}
- (void)setPageIndex:(NSInteger)pageIndex
{
    objc_setAssociatedObject(self, @selector(pageIndex), @(pageIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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



#pragma mark - Request

- (void)requestData:(NSDictionary *)parameters
          completed:(SUIDataSourceCompletionBlock)completed
{
    [self requestData:parameters replace:NO completed:completed];
}

- (void)requestData:(NSDictionary *)parameters
            replace:(BOOL)replace
          completed:(SUIDataSourceCompletionBlock)completed
{
    [self requestData:parameters replace:replace refreshTable:nil completed:completed];
}

- (void)requestData:(NSDictionary *)parameters
            replace:(BOOL)replace
       refreshTable:(SUIDataSourceRefreshTableBlock)refreshTable
          completed:(SUIDataSourceCompletionBlock)completed
{
    [self.currDataSource requestData:parameters
                             replace:replace
                        refreshTable:refreshTable
                           completed:completed];
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

- (void)loadingViewShow
{
    UIView *curLoadingView = [self.view viewWithTag:427012201];
    if (curLoadingView) {
        return;
    }
        
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
    curLoadingView.tag = 427012201;
    curLoadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:curLoadingView];
}
- (void)loadingViewDissmiss
{
    __weak UIView *curLoadingView = [self.view viewWithTag:427012201];
    if (curLoadingView) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             curLoadingView.alpha = 0;
                         } completion:^(BOOL finished) {
                             [curLoadingView removeFromSuperview];
                         }];
    }
}

@end
