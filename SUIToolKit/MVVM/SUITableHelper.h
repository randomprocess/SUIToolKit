//
//  SUITableHelper.h
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/1/11.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SUIDBHelper.h"

@class SUIViewModel;

NS_ASSUME_NONNULL_BEGIN

typedef NSString * __nonnull (^SUITableHelperCellIdentifierBlock)(NSIndexPath *cIndexPath, id model);

@interface SUITableHelper : NSObject <
    UITableViewDataSource,
    UITableViewDelegate,
    SUIDBHelperDelegate>

- (void)cellIdentifier:(SUITableHelperCellIdentifierBlock)cb;

@property (nonatomic,weak) UITableView *sui_tableView;
@property (nonatomic,strong) NSIndexPath *sui_indexPath;

- (void)resetDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection;
- (void)reloadDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection;
- (void)addDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection;
- (void)insertData:(id)cModel AtIndex:(NSIndexPath *)cIndexPath;
- (void)deleteDataAtIndex:(NSIndexPath *)cIndexPath;

- (id)currentModel;
- (id)currentModelAtIndexPath:(NSIndexPath *)cIndexPath;

@end


@interface UITableView (SUITableExten)

@property (null_resettable,strong) SUITableHelper *sui_tableHelper;

@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIDBHelper
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@interface SUITableHelper (SUIDBHelper)

@property (nullable,readonly,copy) SUIDBHelper *sui_DBHelper;

- (void)sui_DBHelperWithClass:(Class)modelClass;
- (void)sui_DBHelperWithClass:(Class)modelClass where:(nullable id)searchTerm;
- (void)sui_DBHelperWithClass:(Class)modelClass where:(nullable id)searchTerm orderBy:(nullable NSString *)orderTerm; // asc desc
- (void)sui_DBHelperWithClass:(Class)modelClass where:(nullable id)searchTerm orderBy:(nullable NSString *)orderTerm offset:(NSInteger)offset count:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
