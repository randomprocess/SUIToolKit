//
//  UIViewController+SUIMVVM.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "UIViewController+SUIMVVM.h"
#import "NSObject+SUIAdditions.h"
#import "UIViewController+SUIAdditions.h"
#import "SUIViewModel.h"

@implementation UIViewController (SUIMVVM)


- (SUIViewModel *)sui_vm
{
    SUIViewModel *curVM = [self sui_getAssociatedObjectWithKey:@selector(sui_vm)];
    if (curVM) return curVM;
    
    if (self.sui_sourceVC) {
        if ([self.sui_sourceVC.sui_vm respondsToSelector:@selector(sui_modelPassed:)]) {
            id curModel = [self.sui_sourceVC.sui_vm sui_modelPassed:self];
            curVM = [[[self sui_classOfViewModel] alloc] initWithModel:curModel];
        }
    } else {
        curVM = [[self sui_classOfViewModel] new];
    }
    self.sui_vm = curVM;
    return curVM;
}

- (void)setSui_vm:(SUIViewModel *)sui_vm
{
    [self sui_setAssociatedObject:sui_vm key:@selector(sui_vm) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    sui_vm.sui_vc = self;
    if ([self respondsToSelector:@selector(sui_bindWithViewModel)]) {
        [self performSelectorOnMainThread:@selector(sui_bindWithViewModel) withObject:nil waitUntilDone:NO];
    }
}


@end
