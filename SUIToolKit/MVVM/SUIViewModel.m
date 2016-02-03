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
#import "UIViewController+SUIMVVM.h"

@interface SUIViewModel ()

@property (nullable,nonatomic,strong) id model;

@end

@implementation SUIViewModel
@synthesize sui_vc = _sui_vc, sui_view = _sui_view;


- (void)observeModel
{
    [self sui_commonInit];
    
    @weakify(self)
    [[RACObserve(self, model) distinctUntilChanged] subscribeNext:^(id cModel) {
        @strongify(self)
        [self sui_bindWithModel:cModel];
    }];
}

- (void)sui_commonInit {}

- (void)sui_bindWithModel:(id)model {}


- (void)bindModel:(id)model
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
- (void)setSui_vc:(UIViewController *)sui_vc
{
    _sui_vc = sui_vc;
    
    @weakify(self)
    [[[RACObserve(sui_vc, sui_sourceVC)
      ignore:nil]
     take:1]
     subscribeNext:^(id x) {
        @strongify(self)
        if ([self.sui_vc.sui_sourceVC respondsToSelector:@selector(sui_classOfViewModel)]) {
            if ([self.sui_vc.sui_sourceVC.sui_vm respondsToSelector:@selector(sui_modelPassed:)]) {
                id curModel = [self.sui_vc.sui_sourceVC.sui_vm sui_modelPassed:self.sui_vc];
                [self bindModel:curModel];
            }
        }
    }];
    
    [self observeModel];
}

- (UIView *)sui_view
{
    if (!_sui_view) {
        _sui_view = self.sui_vc.view;
    }
    return _sui_view;
}
- (void)setSui_view:(UIView *)sui_view
{
    _sui_view = sui_view;
    
    [self observeModel];
}


@end
