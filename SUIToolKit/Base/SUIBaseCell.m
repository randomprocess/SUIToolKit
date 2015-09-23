//
//  SUIBaseCell.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/29.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBaseCell.h"
#import "SUIBaseConfig.h"
#import "UIView+SUIExt.h"

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


// _____________________________________________________________________________

- (void)setCurrTableView:(UITableView *)currTableView
{
    _currTableView = currTableView;
    [self seetSwipeTableCellDelagate];
}

- (void)seetSwipeTableCellDelagate
{
    //
}


@end
