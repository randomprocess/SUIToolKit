//
//  SUIMVVMRootTitleVM.h
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/1/11.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUIViewModel.h"
#import "ReactiveCocoa.h"

@interface SUIMVVMRootTitleVM : SUIViewModel

@property (nonatomic,copy) NSString *text1;
@property (nonatomic,copy) NSString *text2;

@property (nonatomic,strong) UIColor *textColo1;
@property (nonatomic,strong) UIColor *textColo2;

@property (nonatomic,strong) RACCommand *clickCommand;

@end
