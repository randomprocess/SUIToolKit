//
//  SUIHttpClient.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/29.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIHttpClient.h"
#import "AFNetworking.h"

@interface SUIHttpClient ()

@property (nonatomic, strong) AFHTTPSessionManager *ignoringCacheManager;

@end

@implementation SUIHttpClient

+ (instancetype)sharedClient
{
    static SUIHttpClient *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[self alloc] init];
    });
    
    return sharedSingleton;
}

- (NSURLSessionDataTask *)requestWithHost:(NSString *)httpHost
                               httpMethod:(NSString *)httpMethod
                               parameters:(NSDictionary *)parameters
                               completion:(SUIHttpCompletionBlock)completion;
{
    NSURLSessionDataTask *currTask = nil;
    NSString *curHttpMethod = [httpMethod uppercaseString];
    if ([curHttpMethod isEqualToString:@"POST"])
    {
        currTask =
        [self.ignoringCacheManager POST:httpHost
                             parameters:parameters
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    completion(task, nil, responseObject);
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    completion(task, error, nil);
                                }];
    }
    else if ([curHttpMethod isEqualToString:@"GET"])
    {
        currTask =
        [self.ignoringCacheManager GET:httpHost
                            parameters:parameters
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   completion(task, nil, responseObject);
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   completion(task, error, nil);
                               }];
    }
    return currTask;
}

- (AFHTTPSessionManager *)ignoringCacheManager
{
    if (_ignoringCacheManager == nil)
    {
        NSURLSessionConfiguration *ignoringCacheConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        ignoringCacheConfig.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        [ignoringCacheConfig setURLCache:cache];
        ignoringCacheConfig.HTTPShouldSetCookies = YES;
        
        _ignoringCacheManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:ignoringCacheConfig];
        _ignoringCacheManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _ignoringCacheManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
    }
    return _ignoringCacheManager;
}

@end
