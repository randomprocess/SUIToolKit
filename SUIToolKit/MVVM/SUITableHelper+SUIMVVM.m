//
//  SUITableHelper+SUIMVVM.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/3/17.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUITableHelper+SUIMVVM.h"
#import "UIView+SUIMVVM.h"
#import "SUIViewModel.h"

@implementation SUITableHelper (SUIMVVM)


- (void)sui_configureCell:(UITableViewCell *)cCell atIndexPath:(NSIndexPath *)cIndexPath model:(id)cModel
{
    [cCell.sui_vm bindModel:cModel];
    if ([cCell respondsToSelector:@selector(sui_bindWithViewModel:)]) {
        cCell.sui_indexPath = cIndexPath;
        [cCell sui_bindWithViewModel:cCell.sui_vm];
    }
}


@end
