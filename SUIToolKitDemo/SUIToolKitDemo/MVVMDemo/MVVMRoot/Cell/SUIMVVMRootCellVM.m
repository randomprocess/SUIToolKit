//
//  SUIMVVMRootCellVM.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/3/17.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUIMVVMRootCellVM.h"
#import "SUIMVVMRootMD.h"
#import "SUIViewModel.h"

@implementation SUIMVVMRootCellVM


- (void)sui_bindWithModel:(SUIMVVMRootMD *)model
{
    RAC(self, numText) = [SUIVMObserve(num) map:^id(id value) {
        return [NSString sui_stringFromObject:value];
    }];
    SUIVMRAC(titleText, title)
}


@end
