//
//  SUITimer.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/10/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUITimer : NSObject


+ (instancetype _Nonnull)timeWithTimeInterval:(NSTimeInterval)cTi leeway:(NSUInteger)cLeeway event:(dispatch_block_t _Nonnull)eCb cancel:(dispatch_block_t _Nullable)cCb;

- (void)stopTimer;

@end
