//
//  SUIViewModel.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIViewModel.h"
#import "UIViewController+SUIAdditions.h"
#import "UIViewController+SUIMVVM.h"
#import "UITableViewCell+SUIMVVM.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SUIMacros.h"
#import "SUIDBHelper.h"
#import "UIView+SUIMVVM.h"

@interface SUIViewModel ()

@property (nullable,nonatomic,strong) id model;

@end

@implementation SUIViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self performSelectorOnMainThread:@selector(commonInit) withObject:nil waitUntilDone:NO];
    }
    return self;
}

- (instancetype)initWithModel:(id)model
{
    self = [super init];
    if (self) {
        self.model = model;
        [self performSelectorOnMainThread:@selector(commonInit) withObject:nil waitUntilDone:NO];
    }
    return self;
}

- (void)commonInit {}


@end
