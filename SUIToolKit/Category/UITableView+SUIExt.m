//
//  UITableView+SUIExt.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/10/19.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "UITableView+SUIExt.h"

@implementation UITableView (SUIExt)


- (void)scrollToBottomWithAnimated:(BOOL)animated
{
    NSInteger rows = [self numberOfRowsInSection:self.numberOfSections-1];
    
    if (rows > 0)
    {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows-1 inSection:self.numberOfSections-1]
                    atScrollPosition:UITableViewScrollPositionBottom
                            animated:animated];
    }
}


@end
