//
//  SUINetwork.h
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/15.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "SUINetworkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUINetwork : NSObject


+ (RACSignal *)downloadToFileWithURLRequest:(NSURLRequest *)cURLRequest filePath:(NSString *)cPath;

+ (instancetype)requestWithParameters:(id)parameters;


@property (nonatomic,copy) NSString *baseURL;
@property (nonatomic) SUINetworkMethod networkMethod;

@property (readonly,copy) RACSignal *requestSignal;

- (void)resume;
- (void)suspend;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
