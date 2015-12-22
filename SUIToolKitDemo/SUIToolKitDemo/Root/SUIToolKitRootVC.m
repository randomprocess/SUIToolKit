//
//  SUIToolKitRootVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/21.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIToolKitRootVC.h"
#import "SUICategories.h"
#import "SUIUtilities.h"
#import "SUIToolKit.h"
#import "SUIToolKitRootCell.h"
#import "SUIAlbumMD.h"
#import "SUIToolKitRootVM.h"
#import "MJExtension.h"

@interface SUIToolKitRootVC ()

@property (nonatomic,strong) SUIToolKitRootVM *currViewModel;

@end

@implementation SUIToolKitRootVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[SUIAlbumMD getUsingLKDBHelper] dropAllTable];
    
    self.currViewModel = self.sui_vm;
    
    [self.sui_tableView sui_DBHelperWithClass:[SUIAlbumMD class] where:@"aId > 0" orderBy:@"aId" ascending:YES];
    
    
    [[RACObserve(self.currViewModel, responseDict) filter:^BOOL(id value) {
        return value;
    }] subscribeNext:^(NSDictionary *cDict) {
        NSArray *albumAry = [SUIAlbumMD mj_objectArrayWithKeyValuesArray:cDict[@"albums"]];
        for (SUIAlbumMD *curAlbumMD in albumAry) {
            [curAlbumMD updateToDB];
        }
        
//        NSArray *albumAry = [SUIAlbumMD mj_objectArrayWithKeyValuesArray:cDict[@"albums"]];
//        [self.sui_tableView sui_resetDataAry:albumAry];
    }];
    
    
    [self.sui_tableView sui_willDisplayCell:^(__kindof UITableViewCell * _Nonnull cCell, NSIndexPath * _Nonnull cIndexPath) {
        SUIToolKitRootCell *curCell = cCell;
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
    
    
    
//    [self.sui_tableView sui_cellIdentifier:^(NSIndexPath * _Nonnull cIndexPath, id  _Nullable model) {
//        return @"SUIToolKitCell";
//    }];
    
}


@end
