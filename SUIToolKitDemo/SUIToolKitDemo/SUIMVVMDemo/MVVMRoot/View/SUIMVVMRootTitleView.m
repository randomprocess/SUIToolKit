//
//  SUIMVVMRootTitleView.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/1/11.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUIMVVMRootTitleView.h"
#import "SUIToolKit.h"
#import "SUIMVVMRootTitleVM.h"

@implementation SUIMVVMRootTitleView


- (void)sui_bindWithViewModel:(__kindof SUIViewModel *)sui_vm
{
    SUIMVVMRootTitleVM *currVM = sui_vm;
    
    RAC(self.lbl01, text) = RACObserve(currVM, text1);
    RAC(self.lbl02, text) = RACObserve(currVM, text2);

    RAC(self.lbl01, textColor) = RACObserve(currVM, textColo1);
    RAC(self.lbl02, textColor) = RACObserve(currVM, textColo2);
    
    self.clickBtn.rac_command = [sui_vm clickCommand];
}


@end
