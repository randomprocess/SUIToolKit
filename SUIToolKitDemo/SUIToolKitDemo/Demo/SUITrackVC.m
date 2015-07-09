//
//  SUITrackVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/9.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUITrackVC.h"
#import "MJExtension.h"
#import "SUIAlbumMD.h"

@interface SUITrackVC ()

@property (nonatomic,assign) NSInteger pi;

@end

@implementation SUITrackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageSize = 15;
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
                    uLog(@"%@", responseObject);
                    
                    NSDictionary *curDic = responseObject;
                    NSArray *trackAry = [SUITrackMD objectArrayWithKeyValuesArray:curDic[@"tracks"]];
                    
                    return @[trackAry];
                }
                
                return nil;
            }];
}

@end
