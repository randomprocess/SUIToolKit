//
//  SUIHttpClient.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/29.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SUIHttpCompletionBlock)(NSURLSessionDataTask *task, NSError *error, id responseObject);


@interface SUIHttpClient : NSObject


+ (instancetype)sharedClient;


- (NSURLSessionDataTask *)requestWithHost:(NSString *)httpHost
                               httpMethod:(NSString *)httpMethod
                               parameters:(NSDictionary *)parameters
                               completion:(SUIHttpCompletionBlock)completion;



@end
