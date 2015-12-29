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

@interface SUIMVVMRootVM ()



@end

@implementation SUIMVVMRootVM


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




@end
