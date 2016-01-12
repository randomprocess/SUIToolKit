//
//  XXXDBHelperRootViewController.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "XXXDBHelperRootViewController.h"
#import "AAADBHelperRootViewModel.h"
#import "SUIToolKit.h"
#import "SUIAlbumMD.h"
#import "SUIMVVMRootCell.h"

@interface SUIDBHelperRootTableHelper : SUITableHelper

@end

@implementation SUIDBHelperRootTableHelper

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.sui_tableView.sui_vc sui_storyboardInstantiate:@"SUIMVVMDemo" storyboardID:@"SUIMVVMSecondVC"];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        SUIAlbumMD *curMD = [self currentModelAtIndexPath:indexPath];
        [SUIAlbumMD deleteToDB:curMD];
    }
}

@end


@interface XXXDBHelperRootViewController ()

@property (nonatomic,strong) AAADBHelperRootViewModel *sui_vm;

@end

@implementation XXXDBHelperRootViewController
@dynamic sui_vm;

- (Class)sui_classOfViewModel
{
    return [AAADBHelperRootViewModel class];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self sui_vm];
    
    // 清空所有数据
    [[SUIAlbumMD getUsingLKDBHelper] dropAllTable];
    
    self.sui_tableView.sui_tableHelper = [SUIDBHelperRootTableHelper new];
    
    // 目前SUIDBHelper是不支持分组的,估计以后也不会 O_O
    [self.sui_tableView.sui_tableHelper cellIdentifier:^NSString * _Nonnull(NSIndexPath * _Nonnull cIndexPath, __kindof SUIViewModel * _Nullable cVM) {
        return @"SUIMVVMRootCell";
    }];
    
    // 初始化SUIDBHelper
    [self.sui_tableView.sui_tableHelper sui_DBHelperWithClass:[SUIAlbumMD class] where:nil orderBy:@"aId desc"];
}


@end
