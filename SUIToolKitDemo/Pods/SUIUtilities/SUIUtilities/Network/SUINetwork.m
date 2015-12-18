//
//  SUINetwork.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/15.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "SUINetwork.h"
#import "AFNetworking.h"
#import "SUIMacros.h"

static AFHTTPSessionManager *sui_request_manager() {
    static AFHTTPSessionManager * sui_request_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *curSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        curSessionConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        curSessionConfiguration.allowsCellularAccess = YES; //（2G/3G/4G ...）
        curSessionConfiguration.HTTPMaximumConnectionsPerHost = 4;
        curSessionConfiguration.timeoutIntervalForRequest = [SUINetworkConfig sharedInstance].timeoutInterval;
        
        sui_request_manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:curSessionConfiguration];
        sui_request_manager.responseSerializer = [AFJSONResponseSerializer serializer];
        sui_request_manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", @"text/javascript", nil];
    });
    return sui_request_manager;
}

@interface SUINetwork ()

@property (readonly,copy) AFHTTPSessionManager *sui_requestManager;
@property (nonatomic,strong) RACSignal *sui_requestSignal;
@property (nonatomic,strong) id sui_parameters;
@property (nonatomic,strong) NSURLSessionDataTask *sui_Task;

@end

@implementation SUINetwork


+ (AFURLSessionManager *)downloadManager
{
    NSURLSessionConfiguration *curSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    curSessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    curSessionConfiguration.allowsCellularAccess = YES; //（2G/3G/4G ...）
    curSessionConfiguration.HTTPMaximumConnectionsPerHost = 4;
    curSessionConfiguration.timeoutIntervalForRequest = [SUINetworkConfig sharedInstance].timeoutInterval;
    
    AFURLSessionManager *curManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:curSessionConfiguration];
    return curManager;
}

+ (RACSignal *)downloadToFileWithURLRequest:(NSURLRequest *)cURLRequest filePath:(NSString *)cPath
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDownloadTask *curTask =
        [[SUINetwork downloadManager] downloadTaskWithRequest:cURLRequest progress:^(NSProgress * _Nonnull downloadProgress) {
            [subscriber sendNext:downloadProgress];
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:cPath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                uLogError(@"download to File Error ⤭ %@ ⤪ [;[; URLRequest ⤭ %@ ⤪  filePath ⤭ %@ ⤪[;[;", error, cURLRequest, cPath);
                [subscriber sendError:error];
            } else {
                [subscriber sendCompleted];
            }
        }];
        
        [curTask resume];
        return [RACDisposable disposableWithBlock:^{
            [curTask cancel];
        }];
    }];
}

- (AFHTTPSessionManager *)sui_requestManager
{
    return sui_request_manager();
}

+ (instancetype)requestWithParameters:(id)parameters
{
    SUINetwork *curNetwork = [SUINetwork new];
    curNetwork.baseURL = [SUINetworkConfig sharedInstance].baseURL;
    curNetwork.networkMethod = [SUINetworkConfig sharedInstance].networkMethod;
    curNetwork.sui_parameters = parameters;
    return curNetwork;
}

- (RACSignal *)requestSignal
{
    NSURLRequest *curRequest = [self.sui_requestManager.requestSerializer
                                requestWithMethod:[self sui_method]
                                URLString:self.baseURL
                                parameters:self.sui_parameters
                                error:nil];
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        self.sui_Task =
        [self.sui_requestManager dataTaskWithRequest:curRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                uLogError(@"request Error ⤭ %@ ⤪ [;[; curRequest ⤭ %@ ⤪  responseObject ⤭ %@ ⤪[;[;", error, curRequest, responseObject);
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [self.sui_Task resume];
        return [RACDisposable disposableWithBlock:^{
            [self.sui_Task cancel];
        }];
        
    }] replayLazily];
}

- (void)resume
{
    if (self.sui_Task) {
        [self.sui_Task resume];
    } else {
        [self.requestSignal subscribeNext:^(id x) {
        }];
    }
}
- (void)suspend
{
    if (self.sui_Task) [self.sui_Task suspend];
}
- (void)cancel
{
    if (self.sui_Task) [self.sui_Task cancel];
}

- (NSString *)sui_method
{
    switch (self.networkMethod) {
        case SUINetworkMethodGet:
            return @"GET";
            break;
        case SUINetworkMethodPost:
            return @"POST";
            break;
        default:
            uLogError(@"O_O");
            break;
    }
    return @"GET";
}


@end
