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

@interface SUIMVVMRootVC ()

@property (nonatomic,strong) SUIMVVMRootVM *currViewModel;
@property (weak, nonatomic) IBOutlet SUIMVVMRootTitleView *currTitleView;

@end

@implementation SUIMVVMRootVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 当前VC的ViewModel
    self.currViewModel = [SUIMVVMRootVM new];
    self.sui_vm = self.currViewModel;
//    
//    // 设置ViewModel, (这样写需要固定格式的文件名 O_O 我自己偷懒用的)
//    self.currViewModel = self.sui_vm;
    
    // _________________________________________________________________________

    
    /**
     *  自定义视图
     */
    
    // TitleView的ViewModel
    self.currTitleView.sui_vm = self.currViewModel.rootTitleVM;
    // TitleView点击事件
    self.currViewModel.rootTitleClickSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        uLog(@"Click TitleView");
        [subscriber sendCompleted];
        return nil;
    }];
    
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
