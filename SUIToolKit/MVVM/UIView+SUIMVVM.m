//
//  UIView+SUIMVVM.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/1/11.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "UIView+SUIMVVM.h"
#import "SUIUtils.h"
#import "SUIViewModel.h"

@implementation UIView (SUIMVVM)


- (SUIViewModel *)sui_vm
{
    SUIViewModel *curVM = [self sui_getAssociatedObjectWithKey:@selector(sui_vm)];
    if (curVM) return curVM;
    
    SUIAssert([self respondsToSelector:@selector(sui_classOfViewModel)], @"you forgot to add sui_classOfViewModel() in View ⤭ %@ ⤪[;", gClassName(self));
    curVM = [[[self sui_classOfViewModel] alloc] init];
    
    SUIAssert([curVM isKindOfClass:[SUIViewModel class]] , @"return value of sui_classOfViewModel() is not Inherited from SUIViewModel ⤭ %@ ⤪[;", gClassName(curVM));
    self.sui_vm = curVM;
    
    return curVM;
}

- (void)setSui_vm:(SUIViewModel *)sui_vm
{
    [self sui_setAssociatedRetainObject:sui_vm key:@selector(sui_vm)];
    sui_vm.sui_view = self;
    
    if (![self isKindOfClass:[UITableViewCell class]]) {
        if ([self respondsToSelector:@selector(sui_bindWithViewModel:)]) {
            [self performSelectorOnMainThread:@selector(sui_bindWithViewModel:) withObject:sui_vm waitUntilDone:NO];
        }
    }
}


@end
