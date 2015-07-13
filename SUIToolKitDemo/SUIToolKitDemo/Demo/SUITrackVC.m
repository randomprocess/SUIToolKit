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
}

- (void)handlerMainRequest:(BOOL)loadMoreData
{
    SUIAlbumMD *aMd = self.scrModel;
    
    [self requestData:@{
                        @"kw": aMd.name,
                        @"pi": @(self.pageIndex+1),
                        @"pz": @(self.pageSize)
                        }
              replace:YES
            completed:^NSArray *(NSError *error, id responseObject) {
                
                if (error == nil)
                {
                    NSDictionary *curDic = responseObject;
                    
                    NSArray *trackAry = [SUITrackMD objectArrayWithKeyValuesArray:curDic[@"tracks"] context:self.managedObjectContext];
                    
                    return @[trackAry];
                }
                
                return nil;
            }];
}

@end
