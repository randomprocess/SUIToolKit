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


- (void)sui_commonInit
{
    
    // 用了宏无法在其中设置断点,也不能在宏内部使用LLDB O_O
    // 为了调试方便可能还是自行展开写比较好
    SUIVMBIND(SUIAlbumMD,
              
              SUIVMRAC(name, name);
              RAC(self, aId) = [SUIVMObserve(aId)
                                map:^id(NSNumber *cNum) {
                                    return gFormat(@"id: %@", cNum);
                                }];
              
              SUIVMRAC(dateText, release_date);
              SUIVMRAC(cover, cover);
              
              )
    
}


@end
