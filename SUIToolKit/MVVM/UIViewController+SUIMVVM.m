//
//  UIViewController+SUIMVVM.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "UIViewController+SUIMVVM.h"
#import "SUIUtils.h"
#import "SUIViewModel.h"

@implementation UIViewController (SUIMVVM)


- (SUIViewModel *)sui_vm
{
    SUIViewModel *curVM = [self sui_getAssociatedObjectWithKey:@selector(sui_vm)];
    if (curVM) return curVM;
    
    SUIAssert([self respondsToSelector:@selector(sui_classOfViewModel)], @"you forgot to add sui_classOfViewModel() in VC ⤭ %@ ⤪[;", gClassName(self));
    curVM = [[[self sui_classOfViewModel] alloc] init];
    
    SUIAssert([curVM isKindOfClass:[SUIViewModel class]] , @"return value of sui_classOfViewModel() is not Inherited from SUIViewModel ⤭ %@ ⤪[;", gClassName(curVM));
    self.sui_vm = curVM;
    
    return curVM;
}

- (void)setSui_vm:(SUIViewModel *)sui_vm
{
    [self sui_setAssociatedRetainObject:sui_vm key:@selector(sui_vm)];
    sui_vm.sui_vc = self;
    
    if ([self respondsToSelector:@selector(sui_bindWithViewModel:)]) {
        [self view];
        [self performSelectorOnMainThread:@selector(sui_bindWithViewModel:) withObject:sui_vm waitUntilDone:NO];
    }
}


@end
