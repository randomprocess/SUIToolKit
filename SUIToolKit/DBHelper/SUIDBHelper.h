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


@property (nonatomic,readonly,strong) NSMutableArray<__kindof SUIDBEntity *> *sui_objects;

- (instancetype)initWithClass:(Class)modelClass where:(nullable id)searchTerm orderBy:(nullable NSString *)orderTerm delegate:(id<SUIDBHelperDelegate>)delegate;

- (instancetype)initWithClass:(Class)modelClass where:(nullable id)searchTerm orderBy:(nullable NSString *)orderTerm offset:(NSInteger)offset count:(NSInteger)count delegate:(id<SUIDBHelperDelegate>)delegate;


@end


@protocol SUIDBHelperDelegate <NSObject>

typedef NS_ENUM(NSUInteger, SUIDBHelperChangeType) {
    SUIDBHelperChangeInsert = 1,
    SUIDBHelperChangeDelete = 2,
    SUIDBHelperChangeMove = 3,
    SUIDBHelperChangeUpdate = 4,
    SUIDBHelperChangeReload = 9
};

@optional
- (void)sui_DBHelperWillChangeContent:(SUIDBHelper *)cHelper;

@optional
- (void)sui_DBHelper:(SUIDBHelper *)cHelper didChangeObject:(nullable __kindof SUIDBEntity *)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(SUIDBHelperChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath;

@optional
- (void)sui_DBHelperDidChangeContent:(SUIDBHelper *)cHelper;

@end


@interface NSObject (SUIDBHelper)

+ (SUIDBHelper *)sui_DBHelperWithWhere:(NSString *)searchTerm orderBy:(NSString *)orderTerm delegate:(id<SUIDBHelperDelegate>)delegate;

+ (SUIDBHelper *)sui_DBHelperWithWhere:(NSString *)searchTerm orderBy:(NSString *)orderTerm offset:(NSInteger)offset count:(NSInteger)count delegate:(id<SUIDBHelperDelegate>)delegate;

@end


NS_ASSUME_NONNULL_END
