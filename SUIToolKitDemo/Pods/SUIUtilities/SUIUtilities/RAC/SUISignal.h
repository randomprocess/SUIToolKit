//
//  SUISignal.h
//  SUICategoriesDemo
//
//  Created by RandomSuio on 16/1/19.
//  Copyright © 2016年 suio~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUISignal : NSObject


+ (RACSignal *)signal:(void (^)(id<RACSubscriber> subscriber))cb;

+ (RACSignal *)signalCompleted:(void (^)(id<RACSubscriber> subscriber))cb;


@end

NS_ASSUME_NONNULL_END
