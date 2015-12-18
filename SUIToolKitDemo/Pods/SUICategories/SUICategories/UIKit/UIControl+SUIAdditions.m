//
//  UIControl+SUIAdditions.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/2.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "UIControl+SUIAdditions.h"

@implementation UIControl (SUIAdditions)


- (RACSignal *)sui_signalForClick
{
    return [self rac_signalForControlEvents:UIControlEventTouchUpInside];
}

- (RACSignal *)sui_signalForControlEvents:(UIControlEvents)controlEvents
{
    return [self rac_signalForControlEvents:controlEvents];
}


@end
