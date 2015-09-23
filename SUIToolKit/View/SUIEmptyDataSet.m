//
//  SUIEmptyDataSet.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/9/15.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIEmptyDataSet.h"
#import <objc/runtime.h>
#import "SUIBaseConfig.h"

@interface SUIEmptyDataSet ()

@property (nonatomic,copy) SUIEmptyDataSetTitleBlock titleBlock;
@property (nonatomic,copy) SUIEmptyDataSetDesBlock desBlock;
@property (nonatomic,copy) SUIEmptyDataSetImageBlock imageBlock;
@property (nonatomic,copy) SUIEmptyDataSetCustomViewBlock customViewBlock;
@property (nonatomic,copy) SUIEmptyDataSetShouldDisplayBlock shouldDisplayBlock;
@property (nonatomic,copy) SUIEmptyDataSetShouldAllowTouchBlock shouldAllowToucBlock;
@property (nonatomic,copy) SUIEmptyDataSetShouldAllowScrollBlock shouldAllowScrollBlock;
@property (nonatomic,copy) SUIEmptyDataSetDidTapViewBlock didTapViewBlock;

@property (nonatomic,weak) UIScrollView *currScrollView;

@end


@implementation SUIEmptyDataSet

- (void)title:(SUIEmptyDataSetTitleBlock)cb
{
    self.titleBlock = cb;
}
- (void)des:(SUIEmptyDataSetDesBlock)cb
{
    self.desBlock = cb;
}
- (void)image:(SUIEmptyDataSetImageBlock)cb
{
    self.imageBlock = cb;
}
- (void)customView:(SUIEmptyDataSetCustomViewBlock)cb
{
    self.customViewBlock = cb;
}
- (void)shouldDisplay:(SUIEmptyDataSetShouldDisplayBlock)cb
{
    self.shouldDisplayBlock = cb;
}
- (void)shouldAllowTouch:(SUIEmptyDataSetShouldAllowTouchBlock)cb
{
    self.shouldAllowToucBlock = cb;
}
- (void)shouldAllowScroll:(SUIEmptyDataSetShouldAllowScrollBlock)cb
{
    self.shouldAllowScrollBlock = cb;
}
- (void)didTapView:(SUIEmptyDataSetDidTapViewBlock)cb
{
    self.didTapViewBlock = cb;
}


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.titleBlock) return self.titleBlock();
    return nil;
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.desBlock) return self.desBlock();
    return nil;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.imageBlock) return self.imageBlock();
    return nil;
}
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.customViewBlock) return self.customViewBlock();
    if (self.titleBlock || self.desBlock || self.imageBlock) return nil;
    if ([SUIBaseConfig sharedConfig].classNameOfLoadingView) {
        UIView *curGeneralView = [[NSClassFromString([SUIBaseConfig sharedConfig].classNameOfLoadingView) alloc] init];
        return curGeneralView;
    }
    return nil;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if (self.shouldDisplayBlock) return self.shouldDisplayBlock();
    if (self.titleBlock || self.desBlock || self.imageBlock || self.customViewBlock) return YES;
    if (self.currScrollView.addEmptyDataSet && [SUIBaseConfig sharedConfig].classNameOfLoadingView) return YES;
    return NO;
}
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    if (self.shouldAllowToucBlock) return self.shouldAllowToucBlock();
    return YES;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    if (self.shouldAllowScrollBlock) return self.shouldAllowScrollBlock();
    return YES;
}
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    if (self.didTapViewBlock) return self.didTapViewBlock();
}

@end


@implementation UIScrollView (SUIEmptyDataSet)

- (BOOL)addEmptyDataSet
{
    return [objc_getAssociatedObject(self, @selector(addEmptyDataSet)) boolValue];
}
- (void)setAddEmptyDataSet:(BOOL)addEmptyDataSet
{
    if (addEmptyDataSet) {
        [self emptyDataSet];
    }
    objc_setAssociatedObject(self, @selector(addEmptyDataSet), @(addEmptyDataSet), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SUIEmptyDataSet *)emptyDataSet
{
    id curEmptyDataSet = objc_getAssociatedObject(self, @selector(emptyDataSet));
    if (curEmptyDataSet) return curEmptyDataSet;
    
    SUIEmptyDataSet *currEmptyDataSet = [SUIEmptyDataSet new];
    self.emptyDataSet = currEmptyDataSet;
    currEmptyDataSet.currScrollView = self;
    self.emptyDataSetDelegate = self.emptyDataSet;
    self.emptyDataSetSource = self.emptyDataSet;
    return currEmptyDataSet;
}
- (void)setEmptyDataSet:(SUIEmptyDataSet *)emptyDataSet
{
    objc_setAssociatedObject(self, @selector(emptyDataSet), emptyDataSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
