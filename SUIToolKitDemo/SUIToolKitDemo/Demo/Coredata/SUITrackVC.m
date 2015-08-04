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
             id curTrackAry = curDic[@"tracks"];
             
             if (curTrackAry == nil || [curTrackAry isEqual:[NSNull null]])
             {
                 return nil;
             }
             
             NSArray *trackAry = [SUITrackMD objectArrayWithKeyValuesArray:curDic[@"tracks"] context:self.managedObjectContext];
             return @[trackAry];

         } completed:^(NSError *error, id responseObject) {
             [weakSelf loadingViewDissmiss];
         }];
}


- (NSArray *)suiSwipeTableCell:(SUIBaseCell *)curCell direction:(SUISwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings cModel:(id)cModel
{
    if (direction == SUISwipeDirectionToLeft)
    {
        UIButton *coneBtn = [UIButton customBtn];
        coneBtn.normalTitle = @"点击删除";
        coneBtn.backgroundColor = gRandomColo;
        coneBtn.padding = 25.0f;
        coneBtn.clickBlock = ^() {
            uLog(@"miao miao");
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                [cModel MR_deleteEntity];
            }];
        };
        
        UIButton *ctowBtn = [UIButton customBtn];
        ctowBtn.normalTitle = @"aowu";
        ctowBtn.backgroundColor = gRandomColo;
        ctowBtn.padding = 25.0f;
        ctowBtn.clickBlock = ^() {
            uLog(@"aoao aoao");
        };
        
        return @[coneBtn, ctowBtn];
    }
    return nil;
}

@end
