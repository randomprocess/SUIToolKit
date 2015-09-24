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
    
    
    if ([SUITrackMD MR_countOfEntities] > 0) {
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            [SUITrackMD MR_truncateAllInContext:localContext];
        }];
    }
    
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

#if 1
    {
        uWeakSelf
        [self.currTableView.tableExten request:^(NSMutableDictionary *cParameters, id cResponseObject, NSMutableArray *cNewDataAry) {
            SUIAlbumMD *aMd = weakSelf.srcModel;
            cParameters[@"kw"] = aMd.name;
            cParameters[@"pi"] = @(weakSelf.currTableView.pageIndex+1);
            cParameters[@"pz"] = @(weakSelf.currTableView.pageSize);
            if (cResponseObject)
            {
                gCurrDict(cResponseObject);
                id curTrackAry = currDict[@"tracks"];
                if (curTrackAry == nil || [curTrackAry isEqual:[NSNull null]])
                {
                    uLog(@"empty Tracks");
                }
                else
                {
                    if (!weakSelf.currTableView.loadMoreData)
                    {
                        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                            [SUITrackMD MR_truncateAllInContext:localContext];
                        }];
                    }
                    
                    __block NSArray *curNewDataAry = nil;
                    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                        curNewDataAry = [SUITrackMD objectArrayWithKeyValuesArray:currDict[@"tracks"] context:localContext];
                    }];
                    cNewDataAry[cNewDataAry.count] = curNewDataAry;
                }
            }
        } completion:^(NSError *cError, id cResponseObject) {
            [weakSelf loadingViewDissmiss];
        }];
    }
#endif
    
}


@end
