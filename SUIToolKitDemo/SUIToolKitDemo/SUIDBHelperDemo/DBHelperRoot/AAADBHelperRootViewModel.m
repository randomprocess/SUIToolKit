//
//  AAADBHelperRootViewModel.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "AAADBHelperRootViewModel.h"
#import "SUIToolKit.h"
#import "SUIAlbumMD.h"
#import "SUIMVVMSecondVM.h"
#import "SUIMVVMRootTitleMD.h"
#import "MJExtension.h"
#import "SUIMVVMRootCellVM.h"

@interface AAADBHelperRootViewModel ()



@end

@implementation AAADBHelperRootViewModel


- (void)sui_commonInit
{
    [[SUINetwork requestWithParameters:@{@"kw" : @"猫"}].requestSignal subscribeNext:^(NSDictionary *cDict) {
        
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
                uFun;
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
                uFun;
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
}

- (id)sui_modelPassed:(__kindof UIViewController *)cDestVC
{
    return [self.sui_vc.sui_tableView.sui_tableHelper currentModel];
}


@end
