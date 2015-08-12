//
//  SUIMainTVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/6.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIMainTVC.h"
#import "SUIAlbumMD.h"

@interface SUIMainTVC ()

@end

@implementation SUIMainTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        UIViewController *curVC = gViewControllerInstantiate(@"SUITrackVC");
        curVC.currDelegate = self;
        [self.navigationController pushViewController:curVC animated:YES];
    }
}

- (id)modelPassed
{
    SUIAlbumMD *aMd = [SUIAlbumMD new];
    aMd.name = @"喵";
    return aMd;
}


@end
