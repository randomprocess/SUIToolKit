//
//  SUIMVVMRootVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIMVVMRootVC.h"
#import "SUIMVVMRootVM.h"
#import "SUIToolKit.h"
#import "SUIMVVMRootTitleView.h"
#import "SUIMVVMRootTitleVM.h"

@interface SUIMVVMRootVC ()

@property (nonatomic,strong) SUIMVVMRootVM *sui_vm;

@property (weak, nonatomic) IBOutlet SUIMVVMRootTitleView *currTitleView;

@end

@implementation SUIMVVMRootVC
@dynamic sui_vm;


- (Class)sui_classOfViewModel
{
    return [SUIMVVMRootVM class];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // 懒加载生成VM, 所以这里这句可不写
    [self sui_vm];
    
    // _________________________________________________________________________

    
    /**
     *  自定义视图
     */
    
    // TitleView绑定model
    [self.currTitleView.sui_vm bindWithModel:self.sui_vm.rootTitleMD];
    // TitleView点击事件
    uTypeof(SUIMVVMRootTitleVM, self.currTitleView.sui_vm).clickCommand = self.sui_vm.rootTitleClickCommand;
    
    
    // _________________________________________________________________________

    /**
     *  TableView
     */
    
    [self.sui_tableView.sui_tableHelper cellIdentifier:^NSString * _Nonnull(NSIndexPath * _Nonnull cIndexPath, __kindof SUIViewModel * _Nullable cVM) {
        // 和stroyboard中cell的cellIdentifier相同
        return @"SUIMVVMRootCell";
    }];
    
    // _________________________________________________________________________
}


@end
