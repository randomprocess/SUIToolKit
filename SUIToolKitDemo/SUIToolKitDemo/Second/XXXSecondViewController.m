//
//  XXXSecondViewController.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/21.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "XXXSecondViewController.h"
#import "SUICategories.h"
#import "SUIUtilities.h"
#import "SUIToolKit.h"
#import "XXXSecondViewModel.h"


@interface XXXSecondViewController ()

@property (nonatomic,strong) XXXSecondViewModel *currViewModel;

@property (weak, nonatomic) IBOutlet UIImageView *coverView;

@end

@implementation XXXSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.sui_identifier = @"Second";

    self.currViewModel = self.sui_vm;

    RAC(self.coverView, image) = RACObserve(self.currViewModel, coverImage);
}


@end
