//
//  SUIMVVMRootVM.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIViewModel.h"
#import "SUIMVVMRootTitleMD.h"
#import "ReactiveCocoa.h"

@interface SUIMVVMRootVM : SUIViewModel


@property (nonatomic,strong) SUIMVVMRootTitleMD *rootTitleMD;

@property (readonly,strong) RACCommand *rootTitleClickCommand;


@end
