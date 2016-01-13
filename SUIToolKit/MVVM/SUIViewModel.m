//
//  SUIViewModel.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIViewModel.h"
#import "ReactiveCocoa.h"
#import "SUICategories.h"

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

- (UIViewController *)sui_vc
{
    if (!_sui_vc) {
        _sui_vc = self.sui_view.sui_currentVC;
    }
    return _sui_vc;
}

- (UIView *)sui_view
{
    if (!_sui_view) {
        _sui_view = self.sui_vc.view;
    }
    return _sui_view;
}


@end
