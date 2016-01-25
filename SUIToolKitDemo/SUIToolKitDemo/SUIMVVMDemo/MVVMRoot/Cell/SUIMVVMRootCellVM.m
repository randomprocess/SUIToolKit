//
//  SUIMVVMRootCellVM.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/1/11.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUIMVVMRootCellVM.h"
#import "SUIToolKit.h"
#import "SUIAlbumMD.h"

@interface SUIMVVMRootCellVM ()

@end

@implementation SUIMVVMRootCellVM


/**
 SUIVMBIND宏改为下方这种写法
 绑定相同的model可以直接这么写
 如果可能绑定不同model那么就自行判断类型 O_O
 */
- (void)sui_bindWithModel:(SUIAlbumMD *)model
{
    SUIVMRAC(name, name);
    RAC(self, aId) = [SUIVMObserve(aId)
                      map:^id(NSNumber *cNum) {
                          return gFormat(@"id: %@", cNum);
                      }];
    
    SUIVMRAC(dateText, release_date);
    SUIVMRAC(cover, cover);
}


@end

