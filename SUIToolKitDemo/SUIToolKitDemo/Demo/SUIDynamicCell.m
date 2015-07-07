//
//  SUIDynamicCell.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/6.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIDynamicCell.h"
#import "SUIAlbumMD.h"

@interface SUIDynamicCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *idLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@end

@implementation SUIDynamicCell


- (void)displayWithCurrModel:(id)cModel
{
    SUIAlbumMD *curModel = cModel;
    _nameLbl.text = curModel.name;
    _coverView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:curModel.cover]]];
    _idLbl.text = [NSString stringWithFormat:@"id:%zd", curModel.albumId];
    _dateLbl.text = curModel.release_date;
}


@end
