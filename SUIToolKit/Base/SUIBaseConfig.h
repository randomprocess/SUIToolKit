//
//  SUIBaseConfig.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SUIBaseProtocol.h"

@interface SUIBaseConfig : NSObject


#pragma mark - Shared

+ (instancetype)sharedConfig;


#pragma mark - Http

/** default is POST (GET, POST) */
@property (nonatomic,copy) NSString *httpMethod;
/** set httpHost before using requestData() */
@property (nonatomic,copy) NSString *httpHost;


#pragma mark - VC

/** default is whiteColor */
@property (nonatomic,strong) UIColor *backgroundColor;
/** default is 20,20,20,1 */
@property (nonatomic,strong) UIColor *separatorColor;
/** default is {0,10,0,0} */
@property (nonatomic,copy) NSString *separatorInset;
/** default is Default ... (None, Blue, Gray) */
@property (nonatomic,copy) NSString *selectionStyle;

/** default is 20 */
@property (nonatomic,assign) NSInteger pageSize;

/** default is nil */
@property (nonatomic,copy) NSString *classNameOfLoadingView;



#pragma mark -

- (void)configureController:(id<SUIBaseProtocol>)curController;

- (void)configureTableView:(UITableView *)curTableView tvc:(BOOL)tvc;


@end
