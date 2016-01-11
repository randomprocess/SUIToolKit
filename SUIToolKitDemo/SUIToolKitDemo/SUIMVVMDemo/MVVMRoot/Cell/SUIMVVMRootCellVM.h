//
//  SUIMVVMRootCellVM.h
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/1/11.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUIViewModel.h"

@interface SUIMVVMRootCellVM : SUIViewModel

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *aId;
@property (nonatomic,copy) NSString *dateText;


@property (nonatomic,copy) NSString *cover;
@property (nonatomic,strong) UIImage *coverImage;

@end
