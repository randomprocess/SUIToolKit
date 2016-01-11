//
//  SUIMVVMRootCell.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/1/11.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUIMVVMRootCell.h"
#import "SUIToolKit.h"
#import "SUIMVVMRootCellVM.h"
#import "UIImageView+AFNetworking.h"

@implementation SUIMVVMRootCell


- (void)sui_willDisplayWithViewModel:(__kindof SUIViewModel *)sui_vm
{
    SUIMVVMRootCellVM *currVM = sui_vm;
    
    RAC(self.nameLbl, text) = [RACObserve(currVM, name) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.idLbl, text) = [RACObserve(currVM, aId) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.dateLbl, text) = [RACObserve(currVM, dateText) takeUntil:self.rac_prepareForReuseSignal];
    
    @weakify(self)
    [[RACObserve(currVM, cover) takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(NSString *cCover) {
         @strongify(self)
         [self.coverView setImageWithURL:cCover.sui_toURL];
     }];
}


@end
