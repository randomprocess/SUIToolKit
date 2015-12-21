//
//  UITableViewCell+SUIToolKit.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/21.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "UITableViewCell+SUIToolKit.h"
#import "NSObject+SUIAdditions.h"

@implementation UITableViewCell (SUIToolKit)


- (id)sui_md
{
    return [self sui_getAssociatedObjectWithKey:@selector(sui_md)];
}
- (void)setSui_md:(id)sui_md
{
    [self sui_setAssociatedObject:sui_md key:@selector(sui_md) policy:OBJC_ASSOCIATION_ASSIGN];
}

- (UITableView *)sui_tableView
{
    return [self sui_getAssociatedObjectWithKey:@selector(sui_tableView)];
}
- (void)setSui_tableView:(UITableView *)sui_tableView
{
    [self sui_setAssociatedObject:sui_tableView key:@selector(sui_tableView) policy:OBJC_ASSOCIATION_ASSIGN];
}


@end
