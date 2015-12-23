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
    
    
    // 设置 SUIDBHelper, 实现有点类似NSFetchedResultsController
    [self.sui_tableView sui_DBHelperWithClass:[SUIAlbumMD class] where:nil orderBy:@"aId desc"];
    
    // 请求数据
    [[RACObserve(self.currViewModel, responseDict) filter:^BOOL(id value) {
        return value;
    }] subscribeNext:^(NSDictionary *cDict) {
        
        [SUITool delay:3 cb:^{
            // 请求数据成功后删除原数据
            [self.sui_tableView.sui_DBHelper.sui_objects makeObjectsPerformSelector:@selector(deleteToDB)];
            uLogInfo(@"清空原数据");
            
            [SUITool delay:3 cb:^{
                NSArray *albumAry = [SUIAlbumMD mj_objectArrayWithKeyValuesArray:cDict[@"albums"]];
                for (SUIAlbumMD *curAlbumMD in albumAry) {
                    [curAlbumMD updateToDB];
                }
                uLogInfo(@"加入新数据");
                
                [SUITool delay:3 cb:^{
                    SUIAlbumMD *curAlbumMD = albumAry[2];
                    curAlbumMD.aId = 5000000000;
                    curAlbumMD.name = @"嗷呜";
                    [curAlbumMD updateToDB];
                    uLogInfo(@"更新 id : %zd", curAlbumMD.aId);
                    
                    curAlbumMD = albumAry[3];
                    uLogInfo(@"删除 id : %zd", curAlbumMD.aId);
                    [curAlbumMD deleteToDB];
                    
                    SUIAlbumMD *newAlbumMD = [SUIAlbumMD new];
                    newAlbumMD.aId = 2250000;
                    [newAlbumMD updateToDB];
                    uLogInfo(@"插入 id : %zd", newAlbumMD.aId);
                }];
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
