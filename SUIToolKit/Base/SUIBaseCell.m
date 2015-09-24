//
//  SUIBaseCell.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/29.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBaseCell.h"
#import <objc/runtime.h>
#import "SUIBaseConfig.h"
#import "UIView+SUIExt.h"
#import "UIViewController+SUIExt.h"


@implementation SUIBaseCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    if (self.selectionStyle == UITableViewCellSelectionStyleDefault)
    {
        self.selectionStyle = [SUIBaseConfig sharedConfig].selectionStyle;
    }
}


/**
 *  需要计算动态高度时, 影响cell高度的代码写在子类重写的这个方法内
 */
- (void)displayWithCalculateCellHeight:(id)cModel
{
    
}

/**
 *  需要计算动态高度时, 不影响cell高度的代码写在子类重写的这个方法内
 *  不需要计算动态高度, 则全部写在重写的这个方法中
 */
- (void)displayWithCurrModel:(id)cModel
{
    
}


// _____________________________________________________________________________

- (IBAction)doAction:(id)sender
{
    UIViewController *currVC = self.theVC;
    if (currVC.destDoAction) {
        currVC.destDoAction(sender, self.currModle);
    }
}

- (void)setCurrTableView:(UITableView *)currTableView
{
    _currTableView = currTableView;
    self.delegate = self.currTableView.swipeTableCell;
}

@end


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
