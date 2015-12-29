//
//  UIViewController+SUIMVVM.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "UIViewController+SUIMVVM.h"
#import "UIViewController+SUIAdditions.h"
#import "NSObject+SUIAdditions.h"
#import "SUIViewModel.h"
#import "SUIMacros.h"

@implementation UIViewController (SUIMVVM)

- (SUIViewModel *)sui_vm
{
    SUIViewModel *curVM = [self sui_getAssociatedObjectWithKey:@selector(sui_vm)];
    if (curVM) return curVM;
    
    if (self.sui_sourceVC) {
        if ([self.sui_sourceVC.sui_vm respondsToSelector:@selector(viewModelPassed:)]) {
            curVM = [self.sui_sourceVC.sui_vm viewModelPassed:self];
            curVM.sui_vc = self;
        }
    }
    
    if (!curVM) {
        NSString *classNameOfVM = gFormat(@"SUI%@VM", self.sui_identifier);
        curVM = [[NSClassFromString(classNameOfVM) alloc] init];
    }
    uAssert(curVM, @"className should prefix with 'SUI' and suffix with 'VM'");
    self.sui_vm = curVM;
    
    return curVM;
}

- (void)setSui_vm:(SUIViewModel *)sui_vm
{
    sui_vm.sui_vc = self;
    if (self.sui_tableView) {
        self.sui_tableView.delegate = sui_vm;
        self.sui_tableView.dataSource = sui_vm;
    }
    [sui_vm commonInit];
    [self sui_setAssociatedObject:sui_vm key:@selector(sui_vm) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}


@end
