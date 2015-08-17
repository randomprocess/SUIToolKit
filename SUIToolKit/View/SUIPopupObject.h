//
//  SUIPopupObject.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/17.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SUIPopupState)
{
    SUIPopupStateDidClose   = 0,
    SUIPopupStateWillOpen   = 1,
    SUIPopupStateDidOpen    = 2,
    SUIPopupStateWillClose  = 3
};

@interface SUIPopupObject : NSObject

@property (nonatomic,assign) SUIPopupState currState;

@property (nonatomic,assign) CGFloat animalDuration;


- (void)show;

- (void)dismiss;

- (void)addAnimation:(BOOL)willOpen;


@end
