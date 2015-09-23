//
//  SUISwipeTableCell.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/9/22.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUISwipeTableCell.h"
#import <objc/runtime.h>

@interface SUISwipeTableCell ()

@property (nonatomic,copy) SUISwipeTableCellButtonsBlock buttonsBlock;
@property (nonatomic,copy) SUISwipeTableCellDidTapBtnBlock didTapBtnBlock;

@end

@implementation SUISwipeTableCell

- (void)buttons:(SUISwipeTableCellButtonsBlock)cb
{
    self.buttonsBlock = cb;
}
- (void)didTapBtn:(SUISwipeTableCellDidTapBtnBlock)cb
{
    self.didTapBtnBlock = cb;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point
{
    if (self.buttonsBlock) {
        NSArray *curBtns = self.buttonsBlock((SUIBaseCell *)cell, [self currDirection:direction], nil, nil);
        if (curBtns.count > 0) return YES;
    }
    return NO;
}
- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    if (self.buttonsBlock) {
        swipeSettings.transition = MGSwipeTransitionDrag;
        expansionSettings.fillOnTrigger = YES;
        NSArray *curBtns = self.buttonsBlock((SUIBaseCell *)cell, [self currDirection:direction], swipeSettings, expansionSettings);
        if (curBtns.count > 0) return curBtns;
    }
    return nil;
}
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    if (self.didTapBtnBlock) {
        return self.didTapBtnBlock((SUIBaseCell *)cell, index, [self currDirection:direction]);
    }
    return YES;
}
- (SUISwipeDirection)currDirection:(MGSwipeDirection)cDirection
{
    SUISwipeDirection curDirection = cDirection ? SUISwipeDirectionToLeft : SUISwipeDirectionToRight;
    return curDirection;
}

@end


@implementation UITableView (SUISwipeTableCell)

- (SUISwipeTableCell *)swipeTableCell
{
    id curSwipeTableCell = objc_getAssociatedObject(self, @selector(swipeTableCell));
    if (curSwipeTableCell) return curSwipeTableCell;
    
    SUISwipeTableCell *currSwipeTableCell = [SUISwipeTableCell new];
    self.swipeTableCell = currSwipeTableCell;
    return currSwipeTableCell;
}
- (void)setSwipeTableCell:(SUISwipeTableCell *)swipeTableCell
{
    objc_setAssociatedObject(self, @selector(swipeTableCell), swipeTableCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation SUIBaseCell (SUISwipeTableCell)

- (void)seetSwipeTableCellDelagate
{
    self.delegate = self.currTableView.swipeTableCell;
}

@end
