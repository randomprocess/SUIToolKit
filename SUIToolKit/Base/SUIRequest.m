//
//  SUIRequest.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/7.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIRequest.h"
#import "SUIToolKitConst.h"
#import "SUIHttpClient.h"
#import "SUIBaseConfig.h"
#import "SUITableExten.h"

static dispatch_queue_t parser_data_queue() {
    static dispatch_queue_t parser_data_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parser_data_queue = dispatch_queue_create([gFormat(@"com.%@.parserdata", kProjectName) UTF8String], DISPATCH_QUEUE_SERIAL);
    });
    return parser_data_queue;
}

@interface SUIRequest ()

@property (nonatomic,assign,getter=isCancelTask) BOOL cancelTask;

@end


@implementation SUIRequest

+ (instancetype)requestData:(NSDictionary *)parameters
{
    SUIRequest *curRequest = [SUIRequest new];
    
    curRequest.currTask =
    [[SUIHttpClient sharedClient]
     requestWithHost:[SUIBaseConfig sharedConfig].httpHost
     httpMethod:[SUIBaseConfig sharedConfig].httpMethod
     parameters:parameters
     completion:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
         
         if (curRequest.cancelTask) {
             return;
         }
         
         if (error == nil) {
             uLogInfo("========== response ==========\n%@\n", responseObject);
             
             if (curRequest.dataParserBlock)
             {
                 dispatch_async(parser_data_queue(), ^{
                     curRequest.dataParserBlock(responseObject);
                     uMainQueue(
                                if (curRequest.completionBlock)
                                {
                                    curRequest.completionBlock(error, responseObject);
                                }
                     )
                 });
             }
             else if (curRequest.refreshBlock && curRequest.refreshTableView)
             {
                 dispatch_async(parser_data_queue(), ^{
                     NSArray *newDataAry = curRequest.refreshBlock(responseObject);
                     uMainQueue(
                                if (curRequest.refreshTableView)
                                {
                                    [curRequest.refreshTableView headerRefreshStop];
                                    [curRequest.refreshTableView footerRefreshStop];
                                    
                                    [curRequest.refreshTableView refreshTable:newDataAry];
                                }
                                
                                if (curRequest.completionBlock)
                                {
                                    curRequest.completionBlock(error, responseObject);
                                }
                     )
                 });
             }
             else if (curRequest.completionBlock)
             {
                 curRequest.completionBlock(error, responseObject);
             }
         }
         else
         {
             uLogError("========== error ==========\n%@\n", error)
             
             if (curRequest.refreshBlock && curRequest.refreshTableView)
             {
                 [curRequest.refreshTableView headerRefreshStop];
                 [curRequest.refreshTableView footerRefreshStop];
             }
             
             if (curRequest.completionBlock)
             {
                 curRequest.completionBlock(error, responseObject);
             }
         }
     }];
    
    [[[SUIBaseConfig sharedConfig] requesets] addObject:curRequest];
    return curRequest;
}

- (instancetype)identifier:(NSString *)identifier
{
    if (identifier.length > 0)
    {
        NSMutableArray *curRequests = [[SUIBaseConfig sharedConfig] requesets];
        for (SUIRequest *curRequest in curRequests)
        {
            if ([curRequest.identifier isEqualToString:identifier])
            {
                [curRequest cancel];
                break;
            }
        }
    }
    
    self.identifier = identifier;
    
    return self;
}

- (instancetype)parser:(SUIRequestParserBlock)cb
{
    self.dataParserBlock = cb;
    return self;
}

- (instancetype)parser:(SUIRequestRefreshTableBlock)cb refreshTable:(UITableView *)cTableView;
{
    self.refreshBlock = cb;
    self.refreshTableView = cTableView;
    return self;
}

- (instancetype)completion:(SUIRequestCompletionBlock)completion
{
    self.completionBlock = completion;
    return self;
}


- (void)cancel
{
    self.cancelTask = YES;
    [self.currTask cancel];
    
    NSMutableArray *curRequests = [[SUIBaseConfig sharedConfig] requesets];
    [curRequests removeObject:self];
}

@end
