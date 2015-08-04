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
    
    // 使用requestData()请求数据, 其中http请求使用的传输方法和域名在AppDelegate中设置的
    // 其他请求也可以用SUIHttpClient中的方法
    [self requestData:@{
                        @"kw": @"猫"
                        }
              replace:YES
         refreshTable:^NSArray *(id responseObject) {
             
             NSDictionary *curDict = responseObject;
             NSArray *albumAry = [SUIAlbumMD objectArrayWithKeyValuesArray:curDict[@"albums"]];
             
             for (SUIAlbumMD *aMd in albumAry)
             {
                 uLog(@"%@", aMd);
             }
             
             // 返回的数组格式为 [[model]], 会刷新tableView, 不需要刷新返回nil
             return @[albumAry];
             
         } completed:^(NSError *error, id responseObject) {
             
         }];
}

- (NSArray *)suiSearchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText dataAry:(NSArray *)cDataAry
{
    NSPredicate *albumPredicate = [NSPredicate predicateWithFormat:@"albumId CONTAINS[c] %@", searchBar.text];
    NSArray *result = [cDataAry[0] filteredArrayUsingPredicate:albumPredicate];
    
    uLog(@"%@", result);
    
    // 返回的数组格式为 [[model]], 会刷新tableView, 不需要刷新返回nil
    return @[result];
}


- (NSArray *)suiSwipeTableCell:(SUIBaseCell *)curCell direction:(SUISwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    if (direction == SUISwipeDirectionToLeft)
    {
        UIButton *coneBtn = [UIButton customBtn];
        coneBtn.normalTitle = @"miao";
        coneBtn.backgroundColor = gRandomColo;
        coneBtn.padding = 25.0f;
        coneBtn.clickBlock = ^() {
            uLog(@"miao miao");
        };
        
        UIButton *ctowBtn = [UIButton customBtn];
        ctowBtn.normalTitle = @"aowu";
        ctowBtn.backgroundColor = gRandomColo;
        ctowBtn.padding = 25.0f;
        ctowBtn.clickBlock = ^() {
            uLog(@"aoao aoao");
        };
        
        return @[coneBtn, ctowBtn];
    }
    return nil;
}


- (NSArray *)suiDropdownTitleMenuTitles:(SUIDropdownTitleMenu *)cView
{
    return @[@"miao", @"aoao", @"meow"];
}

- (void)suiDropdownTitleMenuDidSelectAtIndex:(NSInteger)curIndex
{
    uLog(@"%zd", curIndex);
}



@end
