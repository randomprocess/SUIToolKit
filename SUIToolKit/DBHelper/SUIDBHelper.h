//
//  SUIDBHelper.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/22.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SUIDBEntity;
@protocol SUIDBHelperDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface SUIDBHelper : NSObject


@property (nonatomic,readonly,strong) NSMutableArray <__kindof SUIDBEntity *>*sui_objects; // 当前不支持分组.

- (instancetype)initWithClass:(Class)modelClass where:(nullable id)searchTerm orderBy:(nullable NSString *)orderTerm delegate:(id<SUIDBHelperDelegate>)delegate;


@end


@protocol SUIDBHelperDelegate <NSObject>

typedef NS_ENUM(NSUInteger, SUIDBHelperChangeType) {
    SUIDBHelperChangeInsert = 1,
    SUIDBHelperChangeDelete = 2,
    SUIDBHelperChangeMove = 3,
    SUIDBHelperChangeUpdate = 4
};

@optional
- (void)sui_DBHelperWillChangeContent:(SUIDBHelper *)cHelper;

@optional
- (void)sui_DBHelper:(SUIDBHelper *)cHelper didChangeObject:(__kindof SUIDBEntity *)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(SUIDBHelperChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath;

@optional
- (void)sui_DBHelperDidChangeContent:(SUIDBHelper *)cHelper;

@end

NS_ASSUME_NONNULL_END
