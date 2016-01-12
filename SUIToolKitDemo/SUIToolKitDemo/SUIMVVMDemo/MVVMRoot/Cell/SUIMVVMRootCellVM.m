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

@property (nonatomic,strong) SUIAlbumMD *model;

@end

@implementation SUIMVVMRootCellVM
@dynamic model;


- (void)sui_commonInit
{
    SUIVMRAC(name, name);
    RAC(self, aId) = [SUIVMObserve(aId) map:^id(NSNumber *cNum) {
        return gFormat(@"id: %@", cNum);
    }];

    SUIVMRAC(dateText, release_date);
    SUIVMRAC(cover, cover);
}


@end
