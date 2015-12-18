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

@protocol SUIViewModelCellProtocal <NSObject>
@optional

- (void)sui_tableView:(UITableView *)cTableView willCalculateHeightForCell:(__kindof UITableViewCell *)cCell forRowAtIndexPath:(NSIndexPath *)cIndexPath;

- (void)sui_tableView:(UITableView *)cTableView willDisplayCell:(__kindof UITableViewCell *)cCell forRowAtIndexPath:(NSIndexPath *)cIndexPath;

@end

@interface UITableViewCell (SUIMVVM)


@property (nonatomic,weak) id sui_md;
@property (nonatomic,weak) UITableView *sui_tableView;
@property (nonatomic,weak) __kindof SUIViewModel *sui_vm;


@end

NS_ASSUME_NONNULL_END
