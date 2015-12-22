//
//  SUIDBEntity.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/22.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"

@class SUIDBHelper;
@protocol SUIDBHelperDelegate;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kSUIDBHelperObjectChangeNotifications = @"SUIDBHelperObjectChangeNotifications";

@interface SUIDBEntity : NSObject


@property (nonatomic,readonly) BOOL sui_inserted;
@property (nonatomic,readonly) BOOL sui_updated;
@property (nonatomic,readonly) BOOL sui_deleted;


@end

NS_ASSUME_NONNULL_END
