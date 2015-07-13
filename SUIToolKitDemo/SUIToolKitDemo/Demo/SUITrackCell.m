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
    
    _trackLbl.text = [NSString stringWithFormat:@"%@", tMd.trackId];
}


@end
