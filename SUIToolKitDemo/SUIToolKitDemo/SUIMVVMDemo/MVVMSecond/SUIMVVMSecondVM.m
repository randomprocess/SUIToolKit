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

@property (nonatomic,strong) SUIAlbumMD *currModel;

@end

@implementation SUIMVVMSecondVM

@dynamic currModel;


- (void)commonInit
{
    RAC(self, coverImage) = RACObserve(self.currModel, coverImage);
    RAC(self, aId) = [RACObserve(self.currModel, aId) map:^id(NSNumber *cNum) {
        return gFormat(@"id: %@", cNum);
    }];
}


@end
