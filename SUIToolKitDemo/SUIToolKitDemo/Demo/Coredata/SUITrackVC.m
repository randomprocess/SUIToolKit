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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currTableView.pageSize = 15;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        [SUITrackMD MR_truncateAllInContext:localContext];
    }];
    
    self.currTableView.fetchedResultsController = [SUITrackMD MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:@"trackId" ascending:YES];
    
    
    /***************************************************************************
     *  EmptyDataSet
     **************************************************************************/
    
#if 1
    {
        [self.currTableView.emptyDataSet title:^NSAttributedString *{
            NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
            paragraph.lineBreakMode = NSLineBreakByWordWrapping;
            paragraph.alignment = NSTextAlignmentCenter;
            
            NSDictionary *curAttributes = @{
                                            NSFontAttributeName : gBFont(20),
                                            NSForegroundColorAttributeName : gRandomColo,
                                            NSParagraphStyleAttributeName : paragraph,
                                            };
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"miaowuwuwuwwu" attributes:curAttributes];
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:gRandomColo range:[attributedString.string rangeOfString:@"wuwuwuwwu"]];
            return attributedString;
        }];
        
        [self.currTableView.emptyDataSet des:^NSAttributedString *{
            NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
            paragraph.lineBreakMode = NSLineBreakByWordWrapping;
            paragraph.alignment = NSTextAlignmentCenter;
            NSDictionary *curAttributes = @{
                                            NSFontAttributeName : gFont(16),
                                            NSForegroundColorAttributeName : gRandomColo,
                                            NSParagraphStyleAttributeName : paragraph
                                            };
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"aowowowowowoowowowoowowowoowowowoowowoowowowowoowoowowowowowowowoowowowoowowowowwowoowuuwoowowwo" attributes:curAttributes];
            [attributedString addAttribute:NSForegroundColorAttributeName value:gRandomColo range:[attributedString.string rangeOfString:@"oowuuwoo"]];
            return attributedString;
        }];
        
        [self.currTableView.emptyDataSet image:^UIImage *{
            return gImageNamed(@"FlyCat_Pink");
        }];
        
        uWeakSelf
        [self.currTableView.emptyDataSet didTapView:^{
            [weakSelf.currTableView headerRefreshSteart];
        }];
    }
#endif
    
    
    /***************************************************************************
     *  SwipeTableCell
     **************************************************************************/
    
#if 1
    {
        [self.currTableView.swipeTableCell buttons:^NSArray *(SUIBaseCell *cCell, SUISwipeDirection cDirection, MGSwipeSettings *cSwipeSettings, MGSwipeExpansionSettings *expansionSettings) {
            
            if (cDirection == SUISwipeDirectionToLeft)
            {
                UIButton *coneBtn = [UIButton customBtn];
                coneBtn.normalTitle = @"点击删除";
                coneBtn.backgroundColor = gRandomColo;
                coneBtn.padding = 25.0f;
                coneBtn.clickBlock = ^() {
                    uLog(@"miao miao");
                    
                    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                        [cCell.currModle MR_deleteEntity];
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
            
        }];
    }
#endif
    
    
    /***************************************************************************
     *  Request
     **************************************************************************/
    
    uWeakSelf
    [self.currTableView.tableExten request:^(BOOL loadMoreData) {
        
        SUIAlbumMD *aMd = weakSelf.srcModel;
        
        [[[[SUIRequest requestData:@{
                                     @"kw": aMd.name,
                                     @"pi": @(weakSelf.currTableView.pageIndex+1),
                                     @"pz": @(weakSelf.currTableView.pageSize)
                                     }]
           parser:^NSArray *(id responseObject) {
               NSDictionary *curDic = responseObject;
               id curTrackAry = curDic[@"tracks"];

               if (curTrackAry == nil || [curTrackAry isEqual:[NSNull null]])
               {
                   uLog(@"empty Tracks");
               }
               else
               {
                   if (!loadMoreData)
                   {
                       [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                           [SUITrackMD MR_truncateAllInContext:localContext];
                       }];
                   }

                   __block NSArray *curNewDataAry = nil;
                   [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                       curNewDataAry = [SUITrackMD objectArrayWithKeyValuesArray:curDic[@"tracks"] context:localContext];
                   }];
                   return @[curNewDataAry];
               }
               return nil;
           } refreshTable:weakSelf.currTableView]
          completion:^(NSError *error, id responseObject) {
              [weakSelf loadingViewDissmiss];
          }]
         identifier:gFormat(@"%@", gClassName(weakSelf))];
    }];
}

//- (void)handlerMainRequest:(BOOL)loadMoreData
//{
//    SUIAlbumMD *aMd = self.scrModel;
//
//    uWeakSelf
//    SUIRequest *curRequest = [SUIRequest requestData:@{
//                                                       @"kw": aMd.name,
//                                                       @"pi": @(self.currTableView.pageIndex+1),
//                                                       @"pz": @(self.currTableView.pageSize)
//                                                       }];
//    
//    [curRequest parser:^NSArray *(id responseObject) {
//        
//        NSDictionary *curDic = responseObject;
//        id curTrackAry = curDic[@"tracks"];
//        
//        if (curTrackAry == nil || [curTrackAry isEqual:[NSNull null]])
//        {
//            uLog(@"empty Tracks");
//        }
//        else
//        {
//            if (!loadMoreData)
//            {
//                [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//                    [SUITrackMD MR_truncateAllInContext:localContext];
//                }];
//            }
//            
//            __block NSArray *curNewDataAry = nil;
//            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//                curNewDataAry = [SUITrackMD objectArrayWithKeyValuesArray:curDic[@"tracks"] context:localContext];
//            }];
//            return @[curNewDataAry];
//        }
//        return nil;
//        
//    } refreshTable:self.currTableView];
//    
//    [curRequest completion:^(NSError *error, id responseObject) {
//        
//        [SUITool delay:1.0 cb:^{
//            [weakSelf loadingViewDissmiss];
//        }];
//        
//    }];
//    
//    [curRequest identifier:gFormat(@"%@", gClassName(self))];
//}


@end
