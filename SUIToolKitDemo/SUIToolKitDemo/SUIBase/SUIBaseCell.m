//
//  SUIBaseCell.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/29.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBaseCell.h"

@implementation SUIBaseCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    NSString *curSelectionStyle = [SUIBaseConfig sharedConfig].selectionStyle;
    if (curSelectionStyle)
    {
        if ([curSelectionStyle isEqualToString:@"None"])
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else if ([curSelectionStyle isEqualToString:@"Blue"])
        {
            self.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        else if ([curSelectionStyle isEqualToString:@"Gray"])
        {
            self.selectionStyle = UITableViewCellSelectionStyleGray;
        }
    }
}

/**
 *  需要计算动态高度时, 影响cell高度的代码写在子类重写的这个方法内
 */
- (void)displayWithCalculateCellHeight
{
    
}

/**
 *  需要计算动态高度时, 不影响cell高度的代码写在子类重写的这个方法内
 *  不需要计算动态高度, 则全部写在重写的这个方法中
 */
- (void)displayWithCurrModel
{
    
}



- (IBAction)doAction:(id)sender
{
    if ([self.cellActionDelegate respondsToSelector:@selector(doAction:)])
    {
        [self.cellActionDelegate doAction:sender cModel:self.currModle];
    }
}



@end
