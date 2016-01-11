//
//  UITableViewCell+SUIMVVM.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SUIViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol SUIMVVMCellProtocol <NSObject>
@optional

- (void)sui_willCalculateHeightWithViewModel:(nullable __kindof SUIViewModel *)sui_vm;
- (void)sui_willDisplayWithViewModel:(nullable __kindof SUIViewModel *)sui_vm;

@end

@interface UITableViewCell (SUIMVVM) <SUIMVVMCellProtocol>


@property (nonatomic,weak) UITableView *sui_tableView;


@end

NS_ASSUME_NONNULL_END
