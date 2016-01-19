//
//  SUISignal.m
//  SUICategoriesDemo
//
//  Created by RandomSuio on 16/1/19.
//  Copyright © 2016年 suio~. All rights reserved.
//

#import "SUISignal.h"

@implementation SUISignal


+ (RACSignal *)signal:(void (^)(id<RACSubscriber> subscriber))cb
{
    RACSignal *curSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        cb(subscriber);
        return nil;
    }];
    return curSignal;
}

+ (RACSignal *)signalCompleted:(void (^)(id<RACSubscriber> subscriber))cb
{
    RACSignal *curSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        cb(subscriber);
        [subscriber sendCompleted];
        return nil;
    }];
    return curSignal;
}


@end
