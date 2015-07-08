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

+ (instancetype)sharedConfig;

/** VC和TVC的背景颜色, 默认whiteColor */
@property (nonatomic,strong) UIColor *backgroundColor;
/** tableView分割线颜色, 默认20,20,20,1 */
@property (nonatomic,strong) UIColor *separatorColor;
/** tableView分割线缩进, 默认@"{0,10,0,0}" */
@property (nonatomic,copy) NSString *separatorInset;
/** tableView选中的风格 (None, Blue, Gray) 默认不统一设置 */
@property (nonatomic,copy) NSString *selectionStyle;

/** http数据传输方法 (GET, POST) 默认POST */
@property (nonatomic,copy) NSString *httpMethod;
/** http域名 */
@property (nonatomic,copy) NSString *httpHost;


// _____________________________________________________________________________

- (void)configureController:(id<SUIBaseProtocol>)curController;

- (void)configureTableView:(UITableView *)curTableView tvc:(BOOL)tvc;


@end
