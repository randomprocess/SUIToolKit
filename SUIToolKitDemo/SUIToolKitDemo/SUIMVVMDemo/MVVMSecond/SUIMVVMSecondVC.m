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

@interface SUIMVVMSecondVC ()

@property (nonatomic,strong) SUIMVVMSecondVM *currViewModel;

@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *idLbl;

@end

@implementation SUIMVVMSecondVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currViewModel = self.sui_vm;
    
    RAC(self.coverView, image) = RACObserve(self.currViewModel, coverImage);
    RAC(self.idLbl, text) = RACObserve(self.currViewModel, aId);
}


@end
