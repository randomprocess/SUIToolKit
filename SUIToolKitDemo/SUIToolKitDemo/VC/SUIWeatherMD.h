//
//  SUIWeatherMD.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/30.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUIWeatherMD : NSObject


@property (nonatomic,copy) NSString *address;
@property (nonatomic,assign) NSInteger alevel;
@property (nonatomic,copy) NSString *cityName;

@property (nonatomic,assign) CGFloat lat;
@property (nonatomic,assign) CGFloat lon;
@property (nonatomic,assign) NSInteger level;

@end
