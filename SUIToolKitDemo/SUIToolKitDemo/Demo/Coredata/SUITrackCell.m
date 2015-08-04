//
//  SUITrackCell.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/9.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUITrackCell.h"
#import "SUITrackMD.h"

@implementation SUITrackCell


- (void)displayWithCurrModel:(id)cModel
{
    SUITrackMD *tMd = cModel;
    
    if (!gRandomInRange(0, 10))
    {
        _trackLbl.text = [NSString stringWithFormat:@"%@  左滑删除", tMd.trackId];
    }
    else
    {
        _trackLbl.text = [NSString stringWithFormat:@"trackId: %@", tMd.trackId];
    }
}


@end
