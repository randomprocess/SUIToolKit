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

@interface SUIMVVMRootCell ()

@property (nonatomic,strong) SUIMVVMRootCellVM *sui_vm;

@end

@implementation SUIMVVMRootCell
@dynamic sui_vm; // ← ←


- (Class)sui_classOfViewModel
{
    return [SUIMVVMRootCellVM class];
}

- (void)sui_willDisplayWithViewModel
{
    RAC(self.nameLbl, text) = SUICELLObserve(name);
    RAC(self.idLbl, text) = SUICELLObserve(aId);
    RAC(self.dateLbl, text) = SUICELLObserve(dateText);
    
    @weakify(self)
    [SUICELLObserve(cover) subscribeNext:^(NSString *cCover) {
        @strongify(self)
        [self.coverView setImageWithURL:cCover.sui_toURL];
    }];
}


@end