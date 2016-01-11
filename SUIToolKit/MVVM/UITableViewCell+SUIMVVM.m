//
//  UITableViewCell+SUIMVVM.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "UITableViewCell+SUIMVVM.h"
#import "NSObject+SUIAdditions.h"
#import "UIView+SUIMVVM.h"

@implementation UITableViewCell (SUIMVVM)


- (UITableView *)sui_tableView
{
    return [self sui_getAssociatedObjectWithKey:@selector(sui_tableView)];
}
- (void)setSui_tableView:(UITableView *)sui_tableView
{
    [self sui_setAssociatedObject:sui_tableView key:@selector(sui_tableView) policy:OBJC_ASSOCIATION_ASSIGN];
}


@end
