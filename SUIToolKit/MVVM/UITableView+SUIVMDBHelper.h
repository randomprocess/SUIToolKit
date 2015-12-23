//
//  UITableView+SUIVMDBHelper.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/22.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUIDBHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (SUIVMDBHelper) <SUIDBHelperDelegate>


@property (nullable,readonly,copy) SUIDBHelper *sui_DBHelper;

- (void)sui_DBHelperWithClass:(Class)modelClass;
- (void)sui_DBHelperWithClass:(Class)modelClass where:(nullable id)searchTerm;
- (void)sui_DBHelperWithClass:(Class)modelClass where:(nullable id)searchTerm orderBy:(nullable NSString *)orderTerm; // asc desc


@end


@protocol SUIVMDBHelperDelegate <NSObject>

@optional
- (void)sui_DBHelperWillChangeContent:(SUIDBHelper *)cHelper tableView:(UITableView *)cTableView;

@optional
- (void)sui_DBHelper:(SUIDBHelper *)cHelper didChangeObject:(__kindof SUIDBEntity *)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(SUIDBHelperChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath tableView:(UITableView *)cTableView;

@optional
- (void)sui_DBHelperDidChangeContent:(SUIDBHelper *)cHelper tableView:(UITableView *)cTableView;

@end


NS_ASSUME_NONNULL_END
