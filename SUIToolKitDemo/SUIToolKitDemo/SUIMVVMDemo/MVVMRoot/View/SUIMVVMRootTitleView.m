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

@interface SUIMVVMRootTitleView ()

@property (nonatomic,strong) SUIMVVMRootTitleVM *sui_vm;

@end

@implementation SUIMVVMRootTitleView
@dynamic sui_vm; // ← ←


- (Class)sui_classOfViewModel
{
    return [SUIMVVMRootTitleVM class];
}

- (void)sui_bindWithViewModel
{
    RAC(self.lbl01, text) = SUIVIEWObserve(text1);
    RAC(self.lbl02, text) = SUIVIEWObserve(text2);
    RAC(self.lbl01, textColor) = SUIVIEWObserve(textColo1);
    RAC(self.lbl02, textColor) = SUIVIEWObserve(textColo2);
    
    self.clickBtn.rac_command = [self.sui_vm clickCommand];
}


@end
