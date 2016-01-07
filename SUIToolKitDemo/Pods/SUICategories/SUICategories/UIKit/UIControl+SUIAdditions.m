//
//  UIControl+SUIAdditions.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/2.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "UIControl+SUIAdditions.h"

@implementation UIControl (SUIAdditions)


- (BOOL)sui_enabled
{
    return self.enabled;
}
- (void)setSui_enabled:(BOOL)sui_enabled
{
    if (self.enabled != sui_enabled) {
        self.enabled = sui_enabled;
    }
}

- (BOOL)sui_selected
{
    return self.selected;
}
- (void)setSui_selected:(BOOL)sui_selected
{
    if (self.selected != sui_selected) {
        self.selected = sui_selected;
    }
}

- (BOOL)sui_highlighted
{
    return self.highlighted;
}
- (void)setSui_highlighted:(BOOL)sui_highlighted
{
    if (self.highlighted != sui_highlighted) {
        self.highlighted = sui_highlighted;
    }
}


- (RACSignal *)sui_signalForClick
{
    return [self rac_signalForControlEvents:UIControlEventTouchUpInside];
}
- (RACSignal *)sui_signalForControlEvents:(UIControlEvents)controlEvents
{
    return [self rac_signalForControlEvents:controlEvents];
}


@end
