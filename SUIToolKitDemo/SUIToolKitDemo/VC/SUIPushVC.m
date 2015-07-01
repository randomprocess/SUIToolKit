//
//  SUIPushVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/30.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIPushVC.h"
#import "SUIWeatherMD.h"

@interface SUIPushVC ()

@property (weak, nonatomic) IBOutlet UILabel *lonLbl;

@end


@implementation SUIPushVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // SB中的Segue选择base push就会把选中cell对应的model丢进来
    SUIWeatherMD *wMD = self.scrModel;
    
    uLog(@"address=%@, alevel=%zd, cityName=%@, lat=%f, lon=%f, level=%zd", wMD.address, wMD.alevel, wMD.cityName, wMD.lat, wMD.lon, wMD.level);
    
    _lonLbl.text = [NSString stringWithFormat:@"lon:%f", wMD.lon];
}


@end
