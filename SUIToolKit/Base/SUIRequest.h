//
//  SUIRequest.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/7.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^SUIRequestParserBlock)(id cResponseObject);
typedef NSArray * (^SUIRequestRefreshTableBlock)(id cResponseObject);
typedef void (^SUIRequestCompletionBlock)(NSError *cError, id cResponseObject);


@interface SUIRequest : NSObject


+ (instancetype)requestData:(NSDictionary *)parameters;
- (instancetype)identifier:(NSString *)identifier;

- (instancetype)parser:(SUIRequestParserBlock)cb;
- (instancetype)parser:(SUIRequestRefreshTableBlock)cb refreshTable:(UITableView *)cTableView;

- (instancetype)completion:(SUIRequestCompletionBlock)completion;

- (void)cancel;


@end
