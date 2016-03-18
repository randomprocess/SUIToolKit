//
//  SUIMVVMRootTitleView.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/3/18.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUIMVVMRootTitleView.h"
#import "SUIMVVMRootTitleViewVM.h"
#import "SUIToolKit.h"


@interface SUIMVVMRootTitleView ()

@property (strong, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation SUIMVVMRootTitleView


SUIClassOfViewModel(SUIMVVMRootTitleViewVM)

- (void)sui_bindWithViewModel:(SUIMVVMRootTitleViewVM *)sui_vm
{
    SUIVIEWRAC(self.titleLbl, text, titleText)
}


@end
