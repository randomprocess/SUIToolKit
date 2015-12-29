//
//  XXXDBHelperRootViewController.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "XXXDBHelperRootViewController.h"
#import "AAADBHelperRootViewModel.h"
#import "SUIToolKit.h"
#import "SUIAlbumMD.h"
#import "MJExtension.h"
#import "SUIMVVMRootCell.h"

@interface XXXDBHelperRootViewController ()

@property (nonatomic,strong) AAADBHelperRootViewModel *currViewModel;

@end

@implementation XXXDBHelperRootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置 ViewModel
    self.currViewModel = [AAADBHelperRootViewModel new];
    self.sui_vm = self.currViewModel;
    
    
    [[SUIAlbumMD getUsingLKDBHelper] dropAllTable];
    
    // 设置 SUIDBHelper, 实现有点类似NSFetchedResultsController
    [self.sui_tableView sui_DBHelperWithClass:[SUIAlbumMD class] where:nil orderBy:@"aId desc"];
    
    // 请求数据
    [[RACObserve(self.currViewModel, responseDict) ignore:nil]
     subscribeNext:^(NSDictionary *cDict) {
         [SUITool delay:1 cb:^{
             NSArray *albumAry = [SUIAlbumMD mj_objectArrayWithKeyValuesArray:cDict[@"albums"]];
             [SUIAlbumMD insertToDBWithArray:albumAry filter:nil];
             uLogInfo(@"加入新数据");
             
             //  2460504
             //  2352873
             //  2275420
             //  2258459
             //  1157330
             
             [SUITool delay:1 cb:^{
                 
                 SUIAlbumMD *newAlbumMD = [SUIAlbumMD new];
                 newAlbumMD.aId = 1;
                 [newAlbumMD updateToDB];
                 uLogInfo(@"插入 id : %zd", newAlbumMD.aId);
                 
                 for (SUIAlbumMD *cAlbumMD in albumAry) {
                     
                     if (cAlbumMD.aId == 2258459) {
                         cAlbumMD.aId = 50000000;
                         cAlbumMD.name = @"嗷呜";
                         [cAlbumMD updateToDB];
                         uLogInfo(@"更新 id : %zd", cAlbumMD.aId);
                     }
                     
                     if (cAlbumMD.aId == 2460504) {
                         [cAlbumMD deleteToDB];
                         uLogInfo(@"删除 id : %zd", cAlbumMD.aId);
                     }
                     if (cAlbumMD.aId == 2275420) {
                         [cAlbumMD deleteToDB];
                         uLogInfo(@"删除 id : %zd", cAlbumMD.aId);
                     }
                 }

                 SUIAlbumMD *newAlbumMD2 = [SUIAlbumMD new];
                 newAlbumMD2.aId = 50000001;
                 [newAlbumMD2 updateToDB];
                 uLogInfo(@"插入 id : %zd", newAlbumMD2.aId);
                 
                 newAlbumMD.aId = 40000001;
                 [newAlbumMD updateToDB];
                 uLogInfo(@"更新 id : %zd", newAlbumMD.aId);
             }];
         }];
     }];
    
    // *****
    
    // 目前SUIDBHelper是不支持分组的,估计以后也不会 O_O
    [self.sui_tableView sui_cellIdentifier:^(NSIndexPath * _Nonnull cIndexPath, id  _Nullable model) {
        return @"SUIMVVMRootCell";
    }];
    
    // 将cell和model绑定
    [self.sui_tableView sui_willDisplayCell:^(__kindof UITableViewCell * _Nonnull cCell, NSIndexPath * _Nonnull cIndexPath) {
        SUIMVVMRootCell *curCell = cCell;
        SUIAlbumMD *curMd = curCell.sui_md;
        
        RAC(curCell.nameLbl, text) = [RACObserve(curMd, name)
                                      takeUntil:cCell.rac_prepareForReuseSignal];
        
        [[RACObserve(curMd, cover) takeUntil:cCell.rac_prepareForReuseSignal]
         subscribeNext:^(NSString *cCover) {
             uGlobalQueue
             (
              curMd.coverImage = [UIImage imageWithData:
                                  [NSData dataWithContentsOfURL:cCover.sui_toURL]];
              uMainQueue
              (
               curCell.coverView.image = curMd.coverImage;
               )
              )
         }];
        
        RAC(curCell.idLbl, text) = [[RACObserve(curMd, aId)
                                     takeUntil:cCell.rac_prepareForReuseSignal]
                                    map:^id(NSNumber *cAId) {
                                        return gFormat(@"id: %@", cAId);
                                    }];
        
        RAC(curCell.dateLbl, text) = [RACObserve(curMd, release_date)
                                      takeUntil:cCell.rac_prepareForReuseSignal];
    }];
}


@end
