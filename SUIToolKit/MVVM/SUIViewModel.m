//
//  SUIViewModel.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIViewModel.h"
#import "ReactiveCocoa.h"

@interface SUIViewModel ()

@property (nullable,nonatomic,strong) id model;

@end

@implementation SUIViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self performSelectorOnMainThread:@selector(observeModel) withObject:nil waitUntilDone:NO];
    }
    return self;
}

- (instancetype)initWithModel:(id)model
{
    self = [super init];
    if (self) {
        self.model = model;
        [self performSelectorOnMainThread:@selector(observeModel) withObject:nil waitUntilDone:NO];
    }
    return self;
}

- (void)observeModel
{
    @weakify(self)
    [[RACObserve(self, model) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self)
        [self sui_commonInit];
    }];
}

- (void)sui_commonInit {}


- (void)bindWithModel:(id)model
{
    if (self.model != model) {
        self.model = model;
    }
}


@end
