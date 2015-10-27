//
//  SUITimer.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/10/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUITimer : NSObject


+ (instancetype)timeWithTimeInterval:(NSTimeInterval)cTi leeway:(NSUInteger)cLeeway event:(dispatch_block_t)eCb cancel:(dispatch_block_t)cCb;

- (void)stopTimer;

@end
