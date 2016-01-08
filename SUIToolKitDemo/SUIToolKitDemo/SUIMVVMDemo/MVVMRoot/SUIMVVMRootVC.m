//
//  SUIMVVMRootVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIMVVMRootVC.h"
#import "SUIMVVMRootVM.h"
#import "SUIToolKit.h"
#import "SUIAlbumMD.h"
#import "MJExtension.h"
#import "SUIMVVMRootCell.h"

@interface SUIMVVMRootVC ()

@property (nonatomic,strong) SUIMVVMRootVM *currViewModel;

@end

@implementation SUIMVVMRootVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置 ViewModel
    self.currViewModel = [SUIMVVMRootVM new];
    self.sui_vm = self.currViewModel;
//    
//    // 设置 ViewModel, (这样写需要固定格式的文件名 O_O 我自己偷懒用的)
//    self.currViewModel = self.sui_vm;
    
    // 请求数据, 使用自己习惯的网络请求代码就好
    [[RACObserve(self.currViewModel, responseDict)
       ignore:nil]
      subscribeNext:^(NSDictionary *cDict) {
        
        // 更新数据
        NSArray *albumAry = [SUIAlbumMD mj_objectArrayWithKeyValuesArray:cDict[@"albums"]];
        [self.sui_tableView sui_resetDataAry:albumAry];
    }];
    
    
    
    // *****
    
    /*
    // 如果需要动态计算cell高度,改变高度的代码写在这个block中, 需要设置好cell完整的约束
    [self.sui_tableView sui_willCalculateCellHeight:^(__kindof UITableViewCell * _Nonnull cCell, NSIndexPath * _Nonnull cIndexPath) {
        
    }];
     */
    
     // cell的Identifier, 和stroyboard中cell的相同
     [self.sui_tableView sui_cellIdentifier:^NSString * _Nonnull(NSIndexPath * _Nonnull cIndexPath, id  _Nullable model) {
         return @"SUIMVVMRootCell";
     }];
     
    
    // 将不会改变cell高度的代码写在这个block中
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
