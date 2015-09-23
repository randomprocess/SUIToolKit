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


    /***************************************************************************
     *  Request
     **************************************************************************/
    
    uWeakSelf
    [self.currTableView.tableExten request:^(BOOL loadMoreData) {
        
        SUIRequest *curRequest = [SUIRequest requestData:@{
                                                           @"kw": @"猫"
                                                           }];
        
        [curRequest parser:^NSArray *(id responseObject) {
            NSDictionary *curDict = responseObject;
            NSArray *albumAry = [SUIAlbumMD objectArrayWithKeyValuesArray:curDict[@"albums"]];
            
            for (SUIAlbumMD *aMd in albumAry) {
                uLog(@"%@", aMd);
            }
            return @[albumAry];
        } refreshTable:weakSelf.currTableView];
        
        [[curRequest identifier:@"SUIAlbumVC"]
        completion:^(NSError *error, id responseObject) {
            [weakSelf loadingViewDissmiss];
        }];
        
    }];
}

@end
