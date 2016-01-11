//
//  SUIMVVMRootVM.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIViewModel.h"
#import "SUIMVVMRootTitleVM.h"

@interface SUIMVVMRootVM : SUIViewModel


@property (readonly,strong) SUIMVVMRootTitleVM *rootTitleVM;

@property (nonatomic,strong) RACSignal *rootTitleClickSignal;


@end
