//
//  SUIDynamicVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/6.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIDynamicVC.h"
#import "MJExtension.h"
#import "SUIAlbumMD.h"

@interface SUIDynamicVC ()

@end

@implementation SUIDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)handlerMainLoadData:(BOOL)loadMoreData
{
    // kw=喵&pi=1&pz=20
    
    [self requestData: @{
                         @"kw": @"喵"
                         }
              replace:YES
            completed:^NSArray *(NSError *error, id responseObject) {
                
                if (error == nil)
                {
                    uLog(@"%@", responseObject);
                    
                    NSDictionary *curDict = responseObject;
                    NSArray *albumAry = [SUIAlbumMD objectArrayWithKeyValuesArray:curDict[@"albums"]];
                    
                    for (SUIAlbumMD *aMd in albumAry)
                    {
                        uLog(@"%@", aMd.description);
                    }
                    
                    return @[albumAry];
                }
                else
                {
                    uLog(@"%@", error);
                }
                
                return nil;
            }];
}

- (NSArray *)searchResultsWithSearchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    uLog(@"%@", searchBar.text);
    
    
    return nil;
}



@end
