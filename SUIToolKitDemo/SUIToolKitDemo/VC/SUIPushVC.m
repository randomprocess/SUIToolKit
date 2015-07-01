//
//  SUIPushVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/30.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIPushVC.h"
#import "SUIWeatherMD.h"

@implementation SUIPushVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SUIWeatherMD *wMD = self.scrModel;
    
    uLog(@"address=%@, alevel=%zd, cityName=%@, lat=%f, lon=%f, level=%zd", wMD.address, wMD.alevel, wMD.cityName, wMD.lat, wMD.lon, wMD.level);
}


@end
