//
//  SUIRootCell.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/30.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIRootCell.h"
#import "SUIWeatherMD.h"

@implementation SUIRootCell


- (void)displayWithCurrModel:(id)cModel
{
    _latLbl.text = [NSString stringWithFormat:@"lat:%f", ((SUIWeatherMD *)cModel).lat];
}


@end
