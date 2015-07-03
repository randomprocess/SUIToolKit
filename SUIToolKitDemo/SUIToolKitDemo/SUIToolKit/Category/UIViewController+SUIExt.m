//
//  UIViewController+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "UIViewController+SUIExt.h"
#import <objc/runtime.h>


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
    
    if ([self.currDelegate respondsToSelector:@selector(modelPassed)])
    {
        curScrModel = [self.currDelegate modelPassed];
    }
    else
    {
        curScrModel = [[self.currDelegate currDataSource] modelPassed];
    }
    self.scrModel = curScrModel;
    return curScrModel;
}
- (void)setScrModel:(id)scrModel
{
    objc_setAssociatedObject(self, @selector(scrModel), scrModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



#pragma mark - IB

- (BOOL)canDelete
{
    return [objc_getAssociatedObject(self, @selector(canDelete)) boolValue];
}
- (void)setCanDelete:(BOOL)canDelete
{
    objc_setAssociatedObject(self, @selector(canDelete), @(canDelete), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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



#pragma mark - Request

- (void)requestData:(NSDictionary *)parameters completed:(SUIDataSourceBlock)completed
{
    [self requestData:parameters replace:NO completed:completed];
}

- (void)requestData:(NSDictionary *)parameters replace:(BOOL)replace completed:(SUIDataSourceBlock)completed
{
    [self.currDataSource requestData:parameters replace:replace completed:completed];
}



@end
