//
//  SUIMVVMRootVC.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/3/17.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUIMVVMRootVC.h"
#import "SUIMVVMRootVM.h"
#import "SUIMVVMRootMD.h"
#import "SUIToolKit.h"
#import "SUIMVVMRootTitleView.h"

@interface SUIMVVMRootVC ()

@property (weak, nonatomic) IBOutlet SUIMVVMRootTitleView *rootTitleView;

@end

@implementation SUIMVVMRootVC


SUIClassOfViewModel(SUIMVVMRootVM)

- (void)sui_bindWithViewModel:(SUIMVVMRootVM *)sui_vm
{
    self.sui_tableView.sui_tableHelper.cellIdentifier = @"SUIMVVMRootCell";
    [self.sui_tableView.sui_tableHelper didSelect:^(NSIndexPath * _Nonnull cIndexPath, SUIMVVMRootMD *  _Nonnull cModel) {
        sui_vm.rootMD.title = cModel.title;
    }];
    
    [self.rootTitleView.sui_vm bindModel:sui_vm.rootMD];
}


@end
