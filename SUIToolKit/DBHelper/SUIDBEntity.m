//
//  SUIDBEntity.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/22.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIDBEntity.h"
#import "SUIDBHelper.h"
#import "SUIMacros.h"

@interface SUIDBEntity ()

@property (nonatomic) BOOL sui_inserted;
@property (nonatomic) BOOL sui_updated;
@property (nonatomic) BOOL sui_deleted;

@end

@implementation SUIDBEntity

/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  LKDBHelper_Delegate
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - LKDBHelper_Delegate

+ (void)dbDidCreateTable:(LKDBHelper*)helper tableName:(NSString*)tableName {}
+ (void)dbDidAlterTable:(LKDBHelper*)helper tableName:(NSString*)tableName addColumns:(NSArray*)columns {}

+ (void)dbDidInserted:(NSObject*)entity result:(BOOL)result
{
    if (result) {
        SUIDBEntity *curEntity = (SUIDBEntity *)entity;
        curEntity.sui_inserted = YES;
        gNotiCenterPost(kSUIDBHelperObjectChangeNotifications, entity);
        curEntity.sui_inserted = NO;
    }
}
+ (void)dbDidDeleted:(NSObject*)entity result:(BOOL)result
{
    if (result) {
        SUIDBEntity *curEntity = (SUIDBEntity *)entity;
        curEntity.sui_deleted = YES;
        gNotiCenterPost(kSUIDBHelperObjectChangeNotifications, entity);
        curEntity.sui_deleted = NO;
    }
}
+ (void)dbDidUpdated:(NSObject*)entity result:(BOOL)result
{
    if (result) {
        SUIDBEntity *curEntity = (SUIDBEntity *)entity;
        curEntity.sui_updated = YES;
        gNotiCenterPost(kSUIDBHelperObjectChangeNotifications, entity);
        curEntity.sui_updated = NO;
    }
}

+ (void)dbDidSeleted:(NSObject*)entity {}

+ (BOOL)dbWillDelete:(NSObject*)entity
{
    return YES;
}
+ (BOOL)dbWillInsert:(NSObject*)entity
{
    return YES;
}
+ (BOOL)dbWillUpdate:(NSObject*)entity
{
    return YES;
}


@end
