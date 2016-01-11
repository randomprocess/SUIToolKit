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
        SUIAlbumMD *curMD = [self currentViewModelAtIndexPath:indexPath].model;
        [SUIAlbumMD deleteToDB:curMD];
    }
}

@end


@interface XXXDBHelperRootViewController ()

@property (nonatomic,strong) AAADBHelperRootViewModel *currViewModel;

@end

@implementation XXXDBHelperRootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 清空所有数据
    [[SUIAlbumMD getUsingLKDBHelper] dropAllTable];
    
    // 当前VC的ViewModel
    self.currViewModel = [AAADBHelperRootViewModel new];
    self.sui_vm = self.currViewModel;
    
    self.sui_tableView.sui_tableHelper = [SUIDBHelperRootTableHelper new];
    
    // 目前SUIDBHelper是不支持分组的,估计以后也不会 O_O
    [self.sui_tableView.sui_tableHelper cellIdentifier:^NSString * _Nonnull(NSIndexPath * _Nonnull cIndexPath, __kindof SUIViewModel * _Nullable cVM) {
        return @"SUIMVVMRootCell";
    }];
    
    [self.sui_tableView.sui_tableHelper cellViewModelClassName:^NSString * _Nonnull(NSIndexPath * _Nonnull cIndexPath, id  _Nonnull model) {
        return @"SUIMVVMRootCellVM";
    }];
    
    // 初始化SUIDBHelper
    [self.sui_tableView.sui_tableHelper sui_DBHelperWithClass:[SUIAlbumMD class] where:nil orderBy:@"aId desc"];
}


@end
