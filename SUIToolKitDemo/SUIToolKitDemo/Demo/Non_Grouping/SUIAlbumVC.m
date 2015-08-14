//
//  SUIAlbumVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/8.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

/**
 *  继承于SUIBaseVC的类, 命名必须以SUI开头VC结尾
 *  不继承SUIBaseVC参考SUIBaseVC的.h和.m, 命名依然要以SUI开头VC结尾
 *
 *  需要添加上拉和下拉, 只需要在IB的属性检查器中选择
 *  或者用代码设置, 具体在SUIBaseProtocol
 *  当有上拉和下拉操作时会调用handlerMainLoadData(), 参考这个类下方的方法
 *
 */

#import "SUIAlbumVC.h"
#import "SUIAlbumMD.h"
#import "UIViewController+SUIExt.h"
#import "SUIDropdownTitleMenu.h"

@interface SUIAlbumVC ()

@end

@implementation SUIAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)handlerMainRequest:(BOOL)loadMoreData
{
    // kw=喵&pi=1&pz=20
    
    // 使用requestData()请求数据, 其中http请求使用的传输方法和域名在AppDelegate中设置
    // 其他请求也可以用SUIHttpClient中的方法
    SUIRequest *curRequest = [SUIRequest requestData:@{
                                                       @"kw": @"猫"
                                                       }];
    
    [curRequest parser:^NSArray *(id responseObject) {
        NSDictionary *curDict = responseObject;
        NSArray *albumAry = [SUIAlbumMD objectArrayWithKeyValuesArray:curDict[@"albums"]];
        
        for (SUIAlbumMD *aMd in albumAry)
        {
            uLog(@"%@", aMd);
        }
        return @[albumAry];
    } refreshTable:self.currTableView];
    
    [curRequest identifier:@"SUIAlbumVC"];
}


@end
