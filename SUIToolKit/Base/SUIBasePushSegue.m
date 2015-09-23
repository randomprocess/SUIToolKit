//
//  SUIBasePushSegue.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/30.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBasePushSegue.h"
#import "SUIToolKitConst.h"
#import "UIViewController+SUIExt.h"

@implementation SUIBasePushSegue

- (void)perform
{
    UIViewController *srcVC = self.sourceViewController;
    UIViewController *destVC = self.destinationViewController;
    destVC.srcVC = srcVC;
    [srcVC.navigationController pushViewController:destVC animated:YES];
}

@end
