//
//  UIControl+SUIAdditions.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/2.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveCocoa.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (SUIAdditions)


@property (nonatomic) BOOL sui_enabled;
@property (nonatomic) BOOL sui_selected;
@property (nonatomic) BOOL sui_highlighted;

- (RACSignal *)sui_signalForClick;
- (RACSignal *)sui_signalForControlEvents:(UIControlEvents)controlEvents;


@end

NS_ASSUME_NONNULL_END
