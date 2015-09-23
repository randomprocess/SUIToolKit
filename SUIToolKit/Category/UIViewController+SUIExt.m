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
#import "UIScrollView+EmptyDataSet.h"
#import "UIView+SUIExt.h"

@implementation UIViewController (SUIExt)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Properties Added
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

- (UITableView *)currTableView
{
    UITableView *curTableView = objc_getAssociatedObject(self, @selector(currTableView));
    if (curTableView) return curTableView;
    
    if ([self isKindOfClass:[UITableViewController class]]) {
        curTableView = (UITableView *)self.view;
    } else {
        curTableView = [self.view subviewWithClassName:@"UITableView"];
    }
    
    if (curTableView) self.currTableView = curTableView;
    return curTableView;
}
- (void)setCurrTableView:(UITableView *)currTableView
{
    currTableView.currVC = self;
    objc_setAssociatedObject(self, @selector(currTableView), currTableView, OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)currIdentifier
{
    NSString *curIdentifier = objc_getAssociatedObject(self, @selector(currIdentifier));
    if (curIdentifier) return curIdentifier;
    
    NSString *currClassName = gClassName(self);
    if ([currClassName hasPrefix:@"SUI"]) {
        uLogInfo(@"currVC ClassName ⤭ %@ ⤪  Superclass ⤭ %@ ⤪", currClassName, self.superclass)
        NSString *curSuffixStr = nil;
        if ([self isKindOfClass:[UIViewController class]] && [currClassName hasSuffix:@"VC"]) {
            curSuffixStr = @"VC";
        } else if ([self isKindOfClass:[UITableViewController class]] && [currClassName hasSuffix:@"TVC"]) {
            curSuffixStr = @"TVC";
        }
        
        NSAssert([currClassName hasSuffix:curSuffixStr], @"className suffix with '%@'", curSuffixStr);
        NSRange curRange = NSMakeRange(3, currClassName.length-(3+curSuffixStr.length));
        curIdentifier = [currClassName substringWithRange:curRange];
        self.currIdentifier = curIdentifier;
    }
    return curIdentifier;
}
- (void)setCurrIdentifier:(NSString *)currIdentifier
{
    objc_setAssociatedObject(self, @selector(currIdentifier), currIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end


@implementation UIViewController (SUIModelPassed)

- (id)srcModel
{
    id curSrcModel = objc_getAssociatedObject(self, @selector(srcModel));
    if (curSrcModel) return curSrcModel;
    
    id currSrcModel = nil;
    if (self.srcVC.currModelPassedBlock) {
        currSrcModel = self.srcVC.currModelPassedBlock();
    } else {
        currSrcModel = self.srcVC.destModel;
    }
    if (currSrcModel) self.srcModel = currSrcModel;
    return currSrcModel;
}
- (void)setSrcModel:(id)srcModel
{
    objc_setAssociatedObject(self, @selector(srcModel), srcModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)destModel
{
    return objc_getAssociatedObject(self, @selector(destModel));
}
- (void)setDestModel:(id)destModel
{
    objc_setAssociatedObject(self, @selector(destModel), destModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)srcVC
{
    return objc_getAssociatedObject(self, @selector(srcVC));
}
- (void)setSrcVC:(UIViewController *)srcVC
{
    objc_setAssociatedObject(self, @selector(srcVC), srcVC, OBJC_ASSOCIATION_ASSIGN);
}

- (SUIModelPassedBlock)currModelPassedBlock
{
    return objc_getAssociatedObject(self, @selector(currModelPassedBlock));
}
- (void)setCurrModelPassedBlock:(SUIModelPassedBlock)currModelPassedBlock
{
    objc_setAssociatedObject(self, @selector(currModelPassedBlock), currModelPassedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SUIBackRefreshedBlock)destBackRefreshedBlock
{
    return objc_getAssociatedObject(self, @selector(destBackRefreshedBlock));
}
- (void)setDestBackRefreshedBlock:(SUIBackRefreshedBlock)destBackRefreshedBlock
{
    objc_setAssociatedObject(self, @selector(destBackRefreshedBlock), destBackRefreshedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SUIDoActionBlock)destDoAction
{
    return objc_getAssociatedObject(self, @selector(destDoAction));
}
- (void)setDestDoAction:(SUIDoActionBlock)destDoAction
{
    objc_setAssociatedObject(self, @selector(destDoAction), destDoAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)modelPassed:(SUIModelPassedBlock)cb
{
    [self setCurrModelPassedBlock:cb];
}
- (void)backRefreshed:(SUIBackRefreshedBlock)cb
{
    [self setDestBackRefreshedBlock:cb];
}
- (void)doAction:(SUIDoActionBlock)cb
{
    [self setDestDoAction:cb];
}

@end


@implementation UIViewController (SUINavBackAction)

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

@end


@implementation UIViewController (SUILoadingView)

- (BOOL)addLoading
{
    return [objc_getAssociatedObject(self, @selector(addLoading)) boolValue];
}
- (void)setAddLoading:(BOOL)addLoading
{
    if (addLoading) {
        uWeakSelf
        [SUITool delay:0.01 cb:^{
            [weakSelf loadingViewShow];
        }];
    }
    objc_setAssociatedObject(self, @selector(addLoading), @(addLoading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

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
        curLoadingView.alpha = 0;
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
    uMainQueue(
               [self.view addSubview:self.loadingView];
               self.loadingView.alpha = 1.0;
    )
}
- (void)loadingViewDissmiss
{
    uMainQueue(
               if (self.loadingView.superview)
               {
                   UIView *curLoadingView = self.loadingView;
                   self.loadingView = nil;
                   [UIView animateWithDuration:0.25
                                    animations:^{
                                        curLoadingView.alpha = 0;
                                    } completion:^(BOOL finished) {
                                        [curLoadingView removeFromSuperview];
                                    }];
               }
    )
}

@end


@implementation UITableView (SUICurrVC)

- (UIViewController *)currVC
{
    return objc_getAssociatedObject(self, @selector(currVC));
}
- (void)setCurrVC:(UIViewController *)currVC
{
    objc_setAssociatedObject(self, @selector(currVC), currVC, OBJC_ASSOCIATION_ASSIGN);
}

@end
