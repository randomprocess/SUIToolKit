//
//  XXXSecondViewModel.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/21.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "XXXSecondViewModel.h"
#import "SUICategories.h"
#import "SUIUtilities.h"
#import "SUIToolKit.h"
#import "SUIAlbumMD.h"


@interface XXXSecondViewModel ()

@property (nonatomic,strong) SUIAlbumMD *currModel;

@end

@implementation XXXSecondViewModel

@dynamic currModel;

- (void)commonInit
{
    RAC(self, coverImage) = RACObserve(self.currModel, coverImage);
}


@end
