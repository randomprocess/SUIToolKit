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
#import "SUIMacros.h"

@implementation UIViewController (SUIMVVM)


- (SUIViewModel *)sui_vm
{
    SUIViewModel *curVM = [self sui_getAssociatedObjectWithKey:@selector(sui_vm)];
    if (curVM) return curVM;
    uAssert([self respondsToSelector:@selector(sui_classOfViewModel)], @"you forgot to add sui_classOfViewModel() in VC ⤭ %@ ⤪[;", gClassName(self));
    
    curVM = [[[self sui_classOfViewModel] alloc] init];
    uAssert([curVM isKindOfClass:[SUIViewModel class]] , @"return value of sui_classOfViewModel() is not Inherited from SUIViewModel ⤭ %@ ⤪[;", gClassName(curVM));
    self.sui_vm = curVM;
    return curVM;
}

- (void)setSui_vm:(SUIViewModel *)sui_vm
{
    [self sui_setAssociatedObject:sui_vm key:@selector(sui_vm) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    sui_vm.sui_vc = self;
    
    if ([self respondsToSelector:@selector(sui_bindWithViewModel:)]) {
        [self performSelectorOnMainThread:@selector(sui_bindWithViewModel:) withObject:sui_vm waitUntilDone:NO];
    }
}


@end
