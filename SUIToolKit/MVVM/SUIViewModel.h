//
//  SUIViewModel.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UITableView+SUIMVVM.h"

@class SUIViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol SUIViewModelDelagate <NSObject>
@optional

- (void)commonInit;
- (SUIViewModel *)viewModelPassed:(__kindof UIViewController *)cDestVC;

@end


@interface SUIViewModel : NSObject <
    SUIViewModelDelagate,
    UITableViewDataSource,
    UITableViewDelegate,
    SUIVMDBHelperDelegate>

@property (nonatomic,weak) UIViewController *sui_vc;

@property (nullable,nonatomic,readonly,strong) id currModel;

@property (nullable,nonatomic,readonly,strong) NSIndexPath *currIndexPath;

- (instancetype)initWithModel:(nullable id)model;

- (nullable id)currentModelAtIndexPath:(NSIndexPath *)cIndexPath;
- (nullable id)currentModelAtIndexPath:(NSIndexPath *)cIndexPath tableView:(UITableView *)cTableView;

@end

NS_ASSUME_NONNULL_END
