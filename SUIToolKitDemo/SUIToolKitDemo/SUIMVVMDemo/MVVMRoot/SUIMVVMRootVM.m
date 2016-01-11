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
#import "SUIMVVMRootTitleMD.h"
#import "MJExtension.h"
#import "SUIMVVMRootCellVM.h"

@interface SUIMVVMRootVM ()

@property (nonatomic,strong) SUIMVVMRootTitleMD *rootTitleMD;

@end

@implementation SUIMVVMRootVM


- (void)commonInit
{
    self.rootTitleMD.kw = @"猫";

    // 请求数据,这里只简单的封装了AFN,实际使用时替换成自己的网络请求模块
    [[SUINetwork requestWithParameters:@{@"kw" : self.rootTitleMD.kw}].requestSignal subscribeNext:^(NSDictionary *cDict) {
        
        NSMutableArray *cellVMAry = [NSMutableArray new];
        NSArray *albumAry = [SUIAlbumMD mj_objectArrayWithKeyValuesArray:cDict[@"albums"]];
        [albumAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SUIMVVMRootCellVM *curCellVM = [[SUIMVVMRootCellVM alloc] initWithModel:obj];
            [cellVMAry addObject:curCellVM];
        }];
        
        self.rootTitleMD.numOfAlbums = albumAry.count;
        
        // 本应丢出去交给VC的, 这里就偷懒写了..
        [self.sui_vc.sui_tableView sui_resetDataAry:cellVMAry];
    }];
}


- (SUIViewModel *)viewModelPassed:(__kindof UIViewController *)cDestVC
{
//    if ([cDestVC isKindOfClass:NSClassFromString(@"SUIMVVMSecondVC")]){
//        
//    }
    
    SUIMVVMSecondVM *curVM = [[SUIMVVMSecondVM alloc] initWithModel:[self.sui_vc.sui_tableView.sui_tableHelper currentViewModel].model];
    return curVM;
}


- (RACCommand *)rootTitleClickCommand
{
    @weakify(self)
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return (self.rootTitleClickSignal ? self.rootTitleClickSignal : [RACSignal empty]);
    }];
}

- (SUIMVVMRootTitleVM *)rootTitleVM
{
    SUIMVVMRootTitleVM *rootTitleVM = [[SUIMVVMRootTitleVM alloc] initWithModel:self.rootTitleMD];
    rootTitleVM.clickCommand = [self rootTitleClickCommand];
    return rootTitleVM;
}

- (SUIMVVMRootTitleMD *)rootTitleMD
{
    if (!_rootTitleMD) {
        _rootTitleMD = [SUIMVVMRootTitleMD new];
    }
    return _rootTitleMD;
}


@end
