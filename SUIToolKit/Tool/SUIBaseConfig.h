//
//  SUIBaseConfig.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SUIBaseConfig : NSObject


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Shared
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

+ (instancetype)sharedConfig;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Http
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@property (nonatomic,copy) NSString *httpMethod; // default is POST (GET, POST)
@property (nonatomic,copy) NSString *httpHost; // set httpHost before using SUIRequest


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  VC
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@property (nonatomic,strong) UIColor *backgroundColor; // default is whiteColor
@property (nonatomic,strong) UIColor *separatorColor; // default is 20,20,20,1
@property (nonatomic,copy) NSString *separatorInset; // default is {0,10,0,0}
@property (nonatomic,assign) UITableViewCellSelectionStyle selectionStyle; // default is UITableViewCellSelectionStyleNone

@property (nonatomic,assign) NSInteger pageSize; // default is 20

@property (nonatomic,copy) NSString *classNameOfLoadingView;
@property (nonatomic,copy) NSString *classNameOfEmptyDataSetView;


@end
