//
//  SUIAlbumVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/8.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIAlbumVC.h"
#import "SUIAlbumMD.h"

@interface SUIAlbumVC ()

@end

@implementation SUIAlbumVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadingViewShow];
    
    /***************************************************************************
     *  Request
     **************************************************************************/
    
    uWeakSelf
    [self.currTableView request:^NSDictionary *{
        return @{@"kw" : @"猫"};
    } parser:^NSArray *(id cResponseObject) {
        gCurrDict(cResponseObject);
        NSArray *albumAry = [SUIAlbumMD objectArrayWithKeyValuesArray:currDict[@"albums"]];
        return @[albumAry];
    } completion:^(NSError *cError, id cResponseObject) {
        [weakSelf loadingViewDissmiss];
    }];
}

@end
