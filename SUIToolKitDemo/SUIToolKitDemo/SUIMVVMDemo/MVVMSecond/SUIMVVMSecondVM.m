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


- (void)commonInit
{
    RAC(self, coverImage) = RACObserve(self.model, coverImage);
    RAC(self, aId) = [RACObserve(self.model, aId) map:^id(NSNumber *cNum) {
        return gFormat(@"id: %@", cNum);
    }];
}


@end
