//
//  SUIRequest.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/7.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^SUIRequestParserBlock)(id responseObject);
typedef NSArray * (^SUIRequestRefreshTableBlock)(id responseObject);
typedef void (^SUIRequestCompletionBlock)(NSError *error, id responseObject);


@interface SUIRequest : NSObject

@property (nonatomic,weak) NSURLSessionDataTask *currTask;
@property (nonatomic,copy) NSString *identifier;
@property (nonatomic,copy) SUIRequestParserBlock dataParserBlock;
@property (nonatomic,copy) SUIRequestRefreshTableBlock refreshBlock;
@property (nonatomic,weak) UITableView *refreshTableView;
@property (nonatomic,copy) SUIRequestCompletionBlock completionBlock;


+ (instancetype)requestData:(NSDictionary *)parameters;
- (instancetype)identifier:(NSString *)identifier;

- (instancetype)parser:(SUIRequestParserBlock)cb;
- (instancetype)parser:(SUIRequestRefreshTableBlock)cb refreshTable:(UITableView *)cTableView;

- (instancetype)completion:(SUIRequestCompletionBlock)completion;


@end
