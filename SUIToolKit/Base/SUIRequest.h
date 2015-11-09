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
typedef void (^SUIRequestCompletionBlock)(NSError *cError, id cResponseObject);


@interface SUIRequest : NSObject

- (instancetype)identifier:(NSString *)identifier;

- (instancetype)parser:(SUIRequestParserBlock)cb;

- (instancetype)completion:(SUIRequestCompletionBlock)completion;

- (void)cancel;

@end


@interface NSObject (SUIRequest)

- (SUIRequest *)requestData:(NSDictionary *)parameters;

@property (nonatomic,strong) NSMutableArray<SUIRequest *> *requesets;

@end
