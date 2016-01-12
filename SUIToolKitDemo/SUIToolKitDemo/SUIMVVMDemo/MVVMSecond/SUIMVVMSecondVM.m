//
//  SUIMVVMSecondVM.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIMVVMSecondVM.h"
#import "SUIToolKit.h"
#import "SUIAlbumMD.h"

@interface SUIMVVMSecondVM ()

@property (nonatomic,strong) SUIAlbumMD *model;

@end

@implementation SUIMVVMSecondVM
@dynamic model;


- (void)sui_commonInit
{
    SUIVMRAC(cover, cover);
    
    RAC(self, aId) = [SUIVMObserve(aId) map:^id(NSNumber *cNum) {
        return gFormat(@"id: %@", cNum);
    }];
}


@end
