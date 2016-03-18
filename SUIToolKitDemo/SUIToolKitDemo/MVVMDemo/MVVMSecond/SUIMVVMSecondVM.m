//
//  SUIMVVMSecondVM.m
//  SUIToolKitDemo
//
//  Created by 姜雨良 on 16/3/18.
//  Copyright © 2016年 RainfallMax. All rights reserved.
//

#import "SUIMVVMSecondVM.h"
#import "SUIMVVMRootMD.h"
#import "SUIToolKit.h"


@implementation SUIMVVMSecondVM

- (void)sui_bindWithModel:(SUIMVVMRootMD *)model
{
    SUIVMRAC(titleText, title)
    RAC(self, numText) = [SUIVMObserve(num) map:^id(id value) {
        return [NSString sui_stringFromObject:value];
    }];
}



@end
