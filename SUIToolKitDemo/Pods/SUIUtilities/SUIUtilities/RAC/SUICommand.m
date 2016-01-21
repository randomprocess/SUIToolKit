//
//  SUICommand.m
//  SUICategoriesDemo
//
//  Created by RandomSuio on 16/1/19.
//  Copyright © 2016年 suio~. All rights reserved.
//

#import "SUICommand.h"

@implementation SUICommand


+ (RACCommand *)command:(RACSignal * _Nonnull (^)(void))cb
{
    return [self commandEnabled:nil signalBlock:cb];
}

+ (RACCommand *)commandEnabled:(RACSignal *)enabledSignal signalBlock:(RACSignal * _Nonnull (^)(void))cb
{
    RACCommand *curCommand = [[RACCommand alloc]
                              initWithEnabled:enabledSignal
                              signalBlock:^RACSignal *(id input) {
                                  RACSignal *curSignal = cb();
                                  if (curSignal) {
                                      return curSignal;
                                  } else {
                                      return [RACSignal empty];
                                  }
                              }];
    return curCommand;
}


+ (RACCommand *)inputCommand:(RACSignal * _Nonnull (^)(id _Nonnull))cb
{
    return [self inputCommandEnabled:nil signalBlock:cb];
}

+ (RACCommand *)inputCommandEnabled:(RACSignal *)enabledSignal signalBlock:(RACSignal * _Nonnull (^)(id _Nonnull))cb
{
    RACCommand *curCommand = [[RACCommand alloc]
                              initWithEnabled:enabledSignal
                              signalBlock:^RACSignal *(id input) {
                                  RACSignal *curSignal = cb(input);
                                  if (curSignal) {
                                      return curSignal;
                                  } else {
                                      return [RACSignal empty];
                                  }
                              }];
    return curCommand;
}


@end
