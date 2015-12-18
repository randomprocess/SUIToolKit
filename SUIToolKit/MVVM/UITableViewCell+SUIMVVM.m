//
//  UITableViewCell+SUIMVVM.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "UITableViewCell+SUIMVVM.h"
#import "SUIViewModel.h"
#import "NSObject+SUIAdditions.h"

@implementation UITableViewCell (SUIMVVM)


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

- (SUIViewModel *)sui_vm
{
    return [self sui_getAssociatedObjectWithKey:@selector(sui_vm)];
}
- (void)setSui_vm:(__kindof SUIViewModel *)sui_vm
{
    [self sui_setAssociatedObject:sui_vm key:@selector(sui_vm) policy:OBJC_ASSOCIATION_ASSIGN];
}


@end
