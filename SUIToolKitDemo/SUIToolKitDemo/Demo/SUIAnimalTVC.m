//
//  SUIAnimalTVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/1.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIAnimalTVC.h"
#import "SUIWeatherMD.h"

@interface SUIAnimalTVC ()

@property (weak, nonatomic) IBOutlet UILabel *latLbl;
@property (weak, nonatomic) IBOutlet UILabel *lonLbl;

@end

@implementation SUIAnimalTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // SB中的Segue选择base push就会把选中cell对应的model丢进来
    SUIWeatherMD *wMD = self.scrModel;
    
    _latLbl.text = [NSString stringWithFormat:@"lon:%f", wMD.lat];
    _lonLbl.text = [NSString stringWithFormat:@"lon:%f", wMD.lon];
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    uFun
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    uFun
}


@end
