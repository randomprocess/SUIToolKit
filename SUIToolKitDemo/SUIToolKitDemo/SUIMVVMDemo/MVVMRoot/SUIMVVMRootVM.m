//
//  SUIMVVMRootVM.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIMVVMRootVM.h"
#import "SUIToolKit.h"
#import "SUIAlbumMD.h"
#import "SUIMVVMSecondVM.h"
#import "MJExtension.h"
#import "SUIMVVMRootCellVM.h"


@interface SUIMVVMRootVM ()


@end

@implementation SUIMVVMRootVM


- (void)sui_commonInit
{
    self.rootTitleMD.kw = @"狗";

    // 请求数据,这里只简单的封装了AFN,实际使用时替换成自己的网络请求模块
    [[SUINetwork requestWithParameters:@{@"kw" : self.rootTitleMD.kw}].requestSignal subscribeNext:^(NSDictionary *cDict) {
        
        NSArray *albumAry = [SUIAlbumMD mj_objectArrayWithKeyValuesArray:cDict[@"albums"]];
        
        self.rootTitleMD.numOfAlbums = albumAry.count;
        
        // 本应丢出去交给VC的, 这里就偷懒写了..
        [self.sui_vc.sui_tableView sui_resetDataAry:albumAry];
    }];
}


- (id)sui_modelPassed:(__kindof UIViewController *)cDestVC
{    
    return [self.sui_vc.sui_tableView.sui_tableHelper currentModel];
}

- (RACCommand *)rootTitleClickCommand
{
    return SUICOMMAND([self rootTitleClickSignal]);
}

- (RACSignal *)rootTitleClickSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        uLog(@"Click TitleView");
        [subscriber sendCompleted];
        return nil;
    }];
}

- (SUIMVVMRootTitleMD *)rootTitleMD
{
    if (!_rootTitleMD) {
        _rootTitleMD = [SUIMVVMRootTitleMD new];
    }
    return _rootTitleMD;
}


@end
