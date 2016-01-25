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

@end

@implementation SUIMVVMRootTitleView


/**
 VM是懒加载, 推荐带上这句
 */
SUIVIEWVMInit


/**
 偷懒用的宏, 展开等同于 :
 - (Class)sui_classOfViewModel
 {
 return [SUIMVVMRootTitleVM class];
 }
 */
SUIVIEWClassOfViewModel(SUIMVVMRootTitleVM)


/**
 SUIVIEWBIND宏改为下方这种写法
 直接将参数中的SUIViewModel替换成对应的VM类名
 */
- (void)sui_bindWithViewModel:(SUIMVVMRootTitleVM *)sui_vm
{
    RAC(self.lbl01, text) = SUIVIEWObserve(text1);
    RAC(self.lbl02, text) = SUIVIEWObserve(text2);
    RAC(self.lbl01, textColor) = SUIVIEWObserve(textColo1);
    RAC(self.lbl02, textColor) = SUIVIEWObserve(textColo2);
    
    self.clickBtn.rac_command = [sui_vm clickCommand];
}


@end
