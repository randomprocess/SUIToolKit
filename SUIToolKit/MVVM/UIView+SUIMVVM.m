//
//  UIView+SUIMVVM.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/1/11.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "UIView+SUIMVVM.h"
#import "NSObject+SUIAdditions.h"
#import "SUIViewModel.h"

@implementation UIView (SUIMVVM)


- (SUIViewModel *)sui_vm
{
    SUIViewModel *curVM = [self sui_getAssociatedObjectWithKey:@selector(sui_vm)];
    if (curVM) return curVM;
    curVM = [[self sui_classOfViewModel] new];
    self.sui_vm = curVM;
    return curVM;
}

- (void)setSui_vm:(SUIViewModel *)sui_vm
{
    [self sui_setAssociatedObject:sui_vm key:@selector(sui_vm) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    sui_vm.sui_view = self;
    if ([self respondsToSelector:@selector(sui_bindWithViewModel)]) {
        [self performSelectorOnMainThread:@selector(sui_bindWithViewModel) withObject:nil waitUntilDone:NO];
    }
}


@end
