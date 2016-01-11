//
//  SUIMVVMRootTitleVM.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/1/11.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUIMVVMRootTitleVM.h"
#import "SUIMVVMRootTitleMD.h"
#import "SUIToolKit.h"

@interface SUIMVVMRootTitleVM ()

@property (nonatomic,strong) SUIMVVMRootTitleMD *model;

@end

@implementation SUIMVVMRootTitleVM
@dynamic model;


- (void)commonInit
{
    RAC(self, text1) = RACObserve(self.model, kw);
    RAC(self, text2) = [RACObserve(self.model, numOfAlbums) map:^id(NSNumber *cNum) {
        return gFormat(@"num:%@",cNum);
    }];
    
    RAC(self, textColo1) = [RACObserve(self.model, numOfAlbums) map:^id(id value) {
        return gRandomColo;
    }];
    RAC(self, textColo2) = [RACObserve(self.model, numOfAlbums) map:^id(id value) {
        return gRandomColo;
    }];
}


@end
