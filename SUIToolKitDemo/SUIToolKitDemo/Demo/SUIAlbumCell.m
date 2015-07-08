//
//  SUIAlbumCell.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/8.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIAlbumCell.h"
#import "SUIAlbumMD.h"

@interface SUIAlbumCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *idLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@end

@implementation SUIAlbumCell

- (void)displayWithCurrModel:(id)cModel
{
    SUIAlbumMD *curModel = cModel;
    _nameLbl.text = curModel.name;
    _coverView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:curModel.cover]]];
    _idLbl.text = [NSString stringWithFormat:@"id:%@", curModel.albumId];
    _dateLbl.text = curModel.release_date;
}

@end
