//
//  SUITimer.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/10/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUITimer.h"
#import "SUIToolKitConst.h"

@interface SUITimer ()

@property (nonatomic,strong) dispatch_source_t currTimer;
@property (nonatomic,copy) void(^reservoir)(void);

@property (nonatomic,copy) dispatch_block_t eventBlock;
@property (nonatomic,copy) dispatch_block_t cancelBlock;

@end


@implementation SUITimer

- (instancetype)initWithTimeInterval:(NSTimeInterval)cTi leeway:(NSUInteger)cLeeway event:(dispatch_block_t _Nonnull)eCb cancel:(dispatch_block_t _Nullable)cCb
{
    self = [super init];
    if (self)
    {
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.currTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
        if (eCb) {
            self.eventBlock = eCb;
            dispatch_source_set_event_handler(self.currTimer, ^{
                uMainQueue(
                           eCb();
                           )
            });
        }
        if (cCb) {
            self.cancelBlock = cCb;
            dispatch_source_set_cancel_handler(self.currTimer, ^{
                uMainQueue(
                           cCb();
                           )
            });
        }
        
        __block SUITimer *bSelf = self;
        self.reservoir = ^{
            dispatch_source_cancel(bSelf.currTimer);
        };
        
        dispatch_source_set_timer(self.currTimer, dispatch_time(DISPATCH_TIME_NOW, cTi*NSEC_PER_SEC), cTi*NSEC_PER_SEC, cLeeway*NSEC_PER_SEC);
        [self resumeTimer];
    }
    return self;
}

+ (instancetype _Nonnull)timeWithTimeInterval:(NSTimeInterval)cTi leeway:(NSUInteger)cLeeway event:(dispatch_block_t _Nonnull)eCb cancel:(dispatch_block_t _Nullable)cCb
{
    SUITimer *curTimer = [[SUITimer alloc] initWithTimeInterval:cTi leeway:cLeeway event:eCb cancel:cCb];
    return curTimer;
}

- (void)resumeTimer
{
    dispatch_resume(self.currTimer);
}

- (void)suspendTimer
{
    dispatch_suspend(self.currTimer);
}

- (void)stopTimer
{
    self.reservoir();
    self.reservoir = nil;
    self.eventBlock = nil;
    self.cancelBlock = nil;
}

@end
