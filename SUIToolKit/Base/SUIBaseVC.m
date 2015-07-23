//
//  SUIBaseVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/24.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBaseVC.h"
#import "SUIBaseConfig.h"

@implementation SUIBaseVC

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[SUIBaseConfig sharedConfig] configureController:self];
}

@end
