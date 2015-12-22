//
//  SUIToolKitRootVM.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/21.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIToolKitRootVM.h"
#import "XXXSecondViewModel.h"
#import "SUICategories.h"
#import "SUIUtilities.h"
#import "SUIAlbumMD.h"
#import "SUIToolKit.h"

@implementation SUIToolKitRootVM


- (void)commonInit
{
    @weakify(self)
    [[SUINetwork requestWithParameters:@{@"kw" : @"猫"}].requestSignal subscribeNext:^(id x) {
        @strongify(self)
        self.responseDict = x;
    }];
}


- (SUIViewModel *)viewModelPassed:(__kindof UIViewController *)cDestVC
{
    XXXSecondViewModel *curVM = [[XXXSecondViewModel alloc] initWithModel:[self currentModelAtIndexPath:self.currIndexPath]];
    return curVM;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        SUIAlbumMD *curMD = [self currentModelAtIndexPath:indexPath];
        [SUIAlbumMD deleteToDB:curMD];
    }
}






@end
