//
//  AAADBHelperRootViewModel.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "AAADBHelperRootViewModel.h"
#import "SUIToolKit.h"
#import "SUIAlbumMD.h"
#import "SUIMVVMSecondVM.h"

@interface AAADBHelperRootViewModel ()



@end

@implementation AAADBHelperRootViewModel


- (void)commonInit
{
    [[SUINetwork requestWithParameters:@{@"kw" : @"猫"}].requestSignal subscribeNext:^(id x) {
        self.responseDict = x;
    }];
}


- (SUIViewModel *)viewModelPassed:(__kindof UIViewController *)cDestVC
{
    SUIMVVMSecondVM *curVM = [[SUIMVVMSecondVM alloc] initWithModel:[self currentModelAtIndexPath:self.currIndexPath]];
    return curVM;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.sui_vc sui_storyboardInstantiate:@"SUIMVVMDemo" storyboardID:@"SUIMVVMSecondVC"];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        SUIAlbumMD *curMD = [self currentModelAtIndexPath:indexPath tableView:tableView];
        [SUIAlbumMD deleteToDB:curMD];
    }
}


@end
