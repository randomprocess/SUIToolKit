//
//  SUIMVVMSecondVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIMVVMSecondVC.h"
#import "SUIToolKit.h"
#import "SUIMVVMSecondVM.h"
#import "UIImageView+AFNetworking.h"

@interface SUIMVVMSecondVC ()

@property (nonatomic,strong) SUIMVVMSecondVM *sui_vm;

@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *idLbl;

@end

@implementation SUIMVVMSecondVC
@dynamic sui_vm;


- (Class)sui_classOfViewModel
{
    return [SUIMVVMSecondVM class];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self)
    [[SUIVIEWObserve(cover) ignore:nil] subscribeNext:^(NSString *cCover) {
        @strongify(self)
        [self.coverView setImageWithURL:cCover.sui_toURL];
    }];
    
    RAC(self.idLbl, text) = RACObserve(self.sui_vm, aId);
}


@end
