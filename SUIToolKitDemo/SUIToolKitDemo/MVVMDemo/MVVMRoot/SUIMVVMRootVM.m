//
//  SUIMVVMRootVM.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/3/17.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUIMVVMRootVM.h"
#import "SUIUtils.h"

@implementation SUIMVVMRootVM


- (void)sui_commonInit
{
    NSArray *models = @[[self testMD], [self testMD], [self testMD]];
    [self.sui_vc.sui_tableView sui_resetDataAry:models];
}

static int cNum = 0;

- (SUIMVVMRootMD *)testMD
{
    SUIMVVMRootMD *curMD = [SUIMVVMRootMD new];
    curMD.title = [@[@"suuuu", @"vtttt", @"fnnnnn", @"mppppp", @"rccccc"] sui_randomObject];
    curMD.num = cNum++;
    return curMD;
}

- (SUIMVVMRootMD *)rootMD
{
    if (!_rootMD) {
        _rootMD = [self testMD];
    }
    return _rootMD;
}

- (id)sui_modelPassed:(__kindof UIViewController *)cDestVC
{
    return [self.sui_vc.sui_tableView.sui_tableHelper currentModel];
}


@end
