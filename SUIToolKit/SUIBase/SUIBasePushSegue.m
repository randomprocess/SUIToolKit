//
//  SUIBasePushSegue.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/30.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBasePushSegue.h"
#import "SUIToolKitConst.h"

@implementation SUIBasePushSegue

- (void)perform
{
    UIViewController *srcVC = self.sourceViewController;
    UIViewController *destVC = self.destinationViewController;
    uWarcPerformSelector(
                         [destVC performSelector:@selector(setCurrDelegate:) withObject:srcVC];
    )
    [srcVC.navigationController pushViewController:destVC animated:YES];
}

@end
