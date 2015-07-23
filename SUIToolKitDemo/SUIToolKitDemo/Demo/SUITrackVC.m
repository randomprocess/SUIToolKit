//
//  SUITrackVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/9.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUITrackVC.h"
#import "SUIAlbumMD.h"
#import "SUIMediaMD.h"
#import "SUITrackMD.h"
#import "MagicalRecord.h"

@interface SUITrackVC ()

@end

@implementation SUITrackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageSize = 15;
    
    self.fetchedResultsController = [SUITrackMD MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:@"trackId" ascending:YES];
    
    [self handlerMainRequest:NO];
}

- (void)handlerMainRequest:(BOOL)loadMoreData
{
    SUIAlbumMD *aMd = self.scrModel;
    
    uWeakSelf
    [self requestData:@{
                        @"kw": aMd.name,
                        @"pi": @(self.pageIndex+1),
                        @"pz": @(self.pageSize)
                        } replace:YES
         refreshTable:^NSArray *(id responseObject) {
             
             NSDictionary *curDic = responseObject;
             NSArray *trackAry = [SUITrackMD objectArrayWithKeyValuesArray:curDic[@"tracks"] context:self.managedObjectContext];
             return @[trackAry];
             
         } completed:^(NSError *error, id responseObject) {
             [weakSelf loadingViewDissmiss];
         }];
}

@end
