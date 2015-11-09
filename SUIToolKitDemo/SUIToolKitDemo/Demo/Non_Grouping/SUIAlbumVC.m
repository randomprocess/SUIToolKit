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
    [self.currTableView request:^(NSMutableDictionary *cParameters, id cResponseObject, NSMutableArray *cNewDataAry) {
        cParameters[@"kw"] = @"猫";
        if (cResponseObject)
        {
            gCurrDict(cResponseObject);
            NSArray *albumAry = [SUIAlbumMD objectArrayWithKeyValuesArray:currDict[@"albums"]];
            cNewDataAry[cNewDataAry.count] = albumAry;
        }
    } completion:^(NSError *cError, id cResponseObject) {
        [weakSelf loadingViewDissmiss];
    }];
}

@end
