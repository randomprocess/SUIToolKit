//
//  SUIArtistVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/8.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIArtistVC.h"
#import "SUIAlbumMD.h"

@interface SUIArtistVC ()

@end

@implementation SUIArtistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SUIAlbumMD *aMd = self.scrModel;
    
    uLog(@"/****/ %@", aMd);
}






@end
