//
//  SUIPopupObject.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/17.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIPopupObject.h"
#import "SUIToolKitConst.h"
#import "SUITool.h"

@implementation SUIPopupObject


- (void)show
{
    if (self.currState == SUIPopupStateDidClose) {
        self.currState = SUIPopupStateWillOpen;
        
        [self addAnimation:YES];
        
        uWeakSelf
        [SUITool delay:self.animalDuration cb:^{
            weakSelf.currState = SUIPopupStateDidOpen;
        }];
    }
}

- (void)dismiss
{
    if (self.currState == SUIPopupStateDidOpen) {
        self.currState = SUIPopupStateWillClose;
        
        [self addAnimation:NO];
        
        uWeakSelf
        [SUITool delay:self.animalDuration cb:^{
            weakSelf.currState = SUIPopupStateDidClose;
        }];
    }
}


- (void)addAnimation:(BOOL)willOpen
{
    uLogError("addAnimation() should be overriden");
}


- (CGFloat)animalDuration
{
    if (_animalDuration == 0) {
        _animalDuration = 0.25;
    }
    return _animalDuration;
}


@end
