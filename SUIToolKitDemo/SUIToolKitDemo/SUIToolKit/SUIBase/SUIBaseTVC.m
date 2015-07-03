//
//  SUIBaseTVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/1.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBaseTVC.h"

@implementation SUIBaseTVC

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[SUIBaseConfig sharedConfig] configureController:self];
}

@end
