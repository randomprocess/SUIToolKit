//
//  SUIViewModel.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SUIUtils.h"
#import "ReactiveCocoa.h"

@class SUIViewModel, RACSignal;

#define SUIViewModelInit \
- (void)awakeFromNib { \
[super awakeFromNib]; \
[self sui_commonVMInit]; \
} \
- (instancetype)init { \
self = [super init]; \
if (self) { \
[self sui_commonVMInit]; \
} \
return self; \
} \
- (void)sui_commonVMInit { \
[self sui_vm]; \
}

#define SUIClassOfViewModel(__VM_CLASS) \
SUIViewModelInit \
- (Class)sui_classOfViewModel { \
return [__VM_CLASS class]; \
}

#define SUIVMObserve(__MD_PROPERTY) (model ? [RACObserve(model, __MD_PROPERTY) takeUntil:[RACObserve(self, model) skip:1]] : nil)
#define SUIVMRAC(__SELF_PROPERTY, __MD_PROPERTY) RAC(self, __SELF_PROPERTY) = SUIVMObserve(__MD_PROPERTY);

#define SUIVIEWObserve(__VM_PROPERTY) ({ \
SUIAssert(![self isKindOfClass:[UITableViewCell class]], \
@"use SUICELLObserve() instead in Cell ⤭ %@ ⤪[;[;", gClassName(self)) \
RACObserve(sui_vm, __VM_PROPERTY); \
})

#define SUICELLObserve(__VM_PROPERTY) ({ \
SUIAssert([self isKindOfClass:[UITableViewCell class]], \
@"use SUIVIEWObserve() instead in View ⤭ %@ ⤪[;[;", gClassName(self)) \
[RACObserve(sui_vm, __VM_PROPERTY) takeUntil:self.rac_prepareForReuseSignal]; \
})

#define SUIVIEWRAC(__SELF_TARGET, __TARGET_PROPERTY, __VM_PROPERTY) RAC(__SELF_TARGET, __TARGET_PROPERTY) = SUIVIEWObserve(__VM_PROPERTY);
#define SUICELLRAC(__SELF_TARGET, __TARGET_PROPERTY, __VM_PROPERTY) RAC(__SELF_TARGET, __TARGET_PROPERTY) = SUICELLObserve(__VM_PROPERTY);

NS_ASSUME_NONNULL_BEGIN

@protocol SUIViewModelDelagate <NSObject>
@optional

- (void)sui_commonInit;
- (void)sui_bindWithModel:(id)model;
- (id)sui_modelPassed:(__kindof UIViewController *)cDestVC;
- (RACSignal *)sui_signalPassed;

@end


@interface SUIViewModel : NSObject <SUIViewModelDelagate>

@property (nullable,nonatomic,weak) UIViewController *sui_vc;
@property (nullable,nonatomic,weak) UIView *sui_view;

@property (nullable,nonatomic,readonly,strong) id model;

- (void)bindModel:(id)model;


@end

NS_ASSUME_NONNULL_END
