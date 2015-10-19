//
//  SUIRequest.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/7.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIRequest.h"
#import <objc/runtime.h>
#import "SUIToolKitConst.h"
#import "SUIHttpClient.h"
#import "SUITableExten.h"
#import "SUIBaseConfig.h"
#import "ReactiveCocoa.h"

static dispatch_queue_t parser_data_queue() {
    static dispatch_queue_t parser_data_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parser_data_queue = dispatch_queue_create([gFormat(@"com.%@.parserdata", kProjectName) UTF8String], DISPATCH_QUEUE_SERIAL);
    });
    return parser_data_queue;
}

@interface SUIRequest ()

@property (nonatomic,weak) NSURLSessionDataTask *currTask;
@property (nonatomic,weak) NSObject *currObj;
@property (nonatomic,copy) NSString *identifier;
@property (nonatomic,copy) SUIRequestParserBlock dataParserBlock;
@property (nonatomic,copy) SUIRequestRefreshTableBlock refreshBlock;
@property (nonatomic,weak) UITableView *refreshTableView;
@property (nonatomic,copy) SUIRequestCompletionBlock completionBlock;
@property (nonatomic,assign) BOOL cancelTask;

@end


@implementation SUIRequest

- (instancetype)identifier:(NSString *)identifier
{
    if (identifier.length > 0)
    {
        for (SUIRequest *curRequest in self.currObj.requesets)
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
    if (cTableView)
    {
        for (SUIRequest *curRequest in self.currObj.requesets)
        {
            if (curRequest.refreshTableView == cTableView)
            {
                [curRequest cancel];
                break;
            }
        }
    }
    
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
    
    [self.currObj.requesets removeObject:self];
}

@end


@implementation NSObject (SUIRequest)

- (SUIRequest *)requestData:(NSDictionary *)parameters
{
    SUIRequest *curRequest = [SUIRequest new];
    curRequest.currObj = self;
    
    uWeakSelf
    curRequest.currTask =
    [[SUIHttpClient sharedClient]
     requestWithHost:[SUIBaseConfig sharedConfig].httpHost
     httpMethod:[SUIBaseConfig sharedConfig].httpMethod
     parameters:parameters
     completion:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
         
         if (curRequest.cancelTask) return;
         
         if (error == nil)
         {
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
             uLogError("========== error ==========\n%@\n", error);
             
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
         
         [[weakSelf requesets] removeObject:curRequest];
     }];
    
    [[self requesets] addObject:curRequest];
    return curRequest;
}


- (void)setRequesets:(NSMutableArray *)requesets
{
    objc_setAssociatedObject(self, @selector(requesets), requesets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)requesets
{
    NSMutableArray *curRequesets = objc_getAssociatedObject(self, @selector(requesets));
    if (curRequesets) return curRequesets;

    curRequesets = [NSMutableArray array];
    self.requesets = curRequesets;
    
    uWeakSelf
    [[self rac_willDeallocSignal] subscribeCompleted:^{
        for (SUIRequest *curRequest in weakSelf.requesets)
        {
            [curRequest cancel];
        }
    }];
    return curRequesets;
}

@end
