//
//  UITableView+SUIMVVM.h
//  SUIToolKitDemo
//
//  Created by zzZ on 16/1/5.
//  Copyright © 2016年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUIDBHelper.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SUITableViewCalculateCellHeightBlock)(__kindof UITableViewCell *cCell, NSIndexPath *cIndexPath);
typedef void (^SUITableViewDisplayCellBlock)(__kindof UITableViewCell *cCell, NSIndexPath *cIndexPath);
typedef NSString * __nonnull (^SUITableViewCellIdentifierBlock)(NSIndexPath *cIndexPath, id __nullable model);

/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIMVVM
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@interface UITableView (SUIMVVM)

@property (readonly,copy) NSMutableArray *sui_dataAry;

- (void)sui_willCalculateCellHeight:(SUITableViewCalculateCellHeightBlock)cb;
- (void)sui_willDisplayCell:(SUITableViewDisplayCellBlock)cb;
- (void)sui_cellIdentifier:(SUITableViewCellIdentifierBlock)cb;

- (void)sui_resetDataAry:(NSArray *)newDataAry;
- (void)sui_resetDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection;
- (void)sui_reloadDataAry:(NSArray *)newDataAry;
- (void)sui_reloadDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection;
- (void)sui_addDataAry:(NSArray *)newDataAry;
- (void)sui_addDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection;
- (void)sui_insertData:(id)cModel AtIndex:(NSIndexPath *)cIndexPath;
- (void)sui_deleteDataAtIndex:(NSIndexPath *)cIndexPath;

@property (nullable,readonly,copy) SUITableViewCalculateCellHeightBlock sui_blockForCalculateCellHeight;
@property (nullable,readonly,copy) SUITableViewDisplayCellBlock sui_blockForDisplayCell;
@property (nullable,readonly,copy) SUITableViewCellIdentifierBlock sui_blockForCellIdentifier;

@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIDBHelper
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@interface UITableView (SUIDBHelper) <SUIDBHelperDelegate>

@property (nullable,readonly,copy) SUIDBHelper *sui_DBHelper;

- (void)sui_DBHelperWithClass:(Class)modelClass;
- (void)sui_DBHelperWithClass:(Class)modelClass where:(nullable id)searchTerm;
- (void)sui_DBHelperWithClass:(Class)modelClass where:(nullable id)searchTerm orderBy:(nullable NSString *)orderTerm; // asc desc
- (void)sui_DBHelperWithClass:(Class)modelClass where:(nullable id)searchTerm orderBy:(nullable NSString *)orderTerm offset:(NSInteger)offset count:(NSInteger)count;

@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIDBHelperDelegate
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@protocol SUIVMDBHelperDelegate <NSObject>

@optional
- (void)sui_DBHelperWillChangeContent:(SUIDBHelper *)cHelper tableView:(UITableView *)cTableView;

@optional
- (void)sui_DBHelper:(SUIDBHelper *)cHelper didChangeObject:(__kindof SUIDBEntity *)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(SUIDBHelperChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath tableView:(UITableView *)cTableView;

@optional
- (void)sui_DBHelperDidChangeContent:(SUIDBHelper *)cHelper tableView:(UITableView *)cTableView;

@end

NS_ASSUME_NONNULL_END
