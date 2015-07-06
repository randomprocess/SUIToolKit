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
                    
                    [SUIAlbumMD setupReplacedKeyFromPropertyName121:^NSString *(NSString *propertyName) {
                        
                        if ([propertyName isEqualToString:@"id"])
                        {
                            return @"albumId";
                        }
                        return propertyName;
                    }];
                    
                    [SUIArtistMD setupReplacedKeyFromPropertyName121:^NSString *(NSString *propertyName) {
                        
                        if ([propertyName isEqualToString:@"id"])
                        {
                            return @"artistId";
                        }
                        return propertyName;
                    }];
                    
                    NSDictionary *curDict = responseObject;
                    NSArray *albumAry = [SUIAlbumMD objectArrayWithKeyValuesArray:curDict[@"albums"]];
                    
                    for (SUIAlbumMD *aMd in albumAry)
                    {
                        uLog(@"albumId:%zd name:%@", aMd.albumId, aMd.name);
                    }
                }
                else
                {
                    uLog(@"%@", error);
                }
                
                return nil;
            }];
}



@end
