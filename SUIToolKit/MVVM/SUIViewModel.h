//
//  SUIViewModel.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SUIMacros.h"

@class SUIViewModel;

#define SUIVIEWBIND(__VM_CLASS, __STUFF) { \
uAssert([self.sui_vm isKindOfClass:[__VM_CLASS class]], \
@"check the VM_CLASS in View ⤭ %@ ⤪[;[;", gClassName(self)) \
typeof(__VM_CLASS *) __SUI_VM = self.sui_vm; \
__STUFF \
}

#define SUIVMBIND(__MD_CLASS, __STUFF) ({ \
uAssert([self isKindOfClass:[SUIViewModel class]], \
@"check the superclass in VM ⤭ %@ ⤪[;[;", gClassName(self)) \
BOOL ret = [self.model isKindOfClass:[__MD_CLASS class]]; \
if (ret) { typeof(__MD_CLASS *) __SUI_MD = self.model; __STUFF }; \
ret; \
});

#define SUIVMObserve(__MD_PROPERTY) [RACObserve(__SUI_MD, __MD_PROPERTY) takeUntil:[RACObserve(self, model) skip:1]]
#define SUIVMRAC(__SELF_PROPERTY, __MD_PROPERTY) RAC(self, __SELF_PROPERTY) = SUIVMObserve(__MD_PROPERTY);

#define SUIVIEWObserve(__VM_PROPERTY) ({ \
uAssert(![self isKindOfClass:[UITableViewCell class]], \
@"use SUICELLObserve() instead in Cell ⤭ %@ ⤪[;[;", gClassName(self)) \
RACObserve(__SUI_VM, __VM_PROPERTY); \
})

#define SUICELLObserve(__VM_PROPERTY) ({ \
uAssert([self isKindOfClass:[UITableViewCell class]], \
@"use SUIVIEWObserve() instead in View ⤭ %@ ⤪[;[;", gClassName(self)) \
[RACObserve(__SUI_VM, __VM_PROPERTY) takeUntil:self.rac_prepareForReuseSignal]; \
})

#define SUICOMMAND(__SIGNAL) ({@weakify(self);[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) { \
uWarcUnused(@strongify(self)) \
return __SIGNAL; \
}];})

NS_ASSUME_NONNULL_BEGIN

@protocol SUIViewModelDelagate <NSObject>
@optional

- (void)sui_commonInit;
- (id)sui_modelPassed:(__kindof UIViewController *)cDestVC;

@end


@interface SUIViewModel : NSObject <SUIViewModelDelagate>

@property (nullable,nonatomic,weak) UIViewController *sui_vc;
@property (nullable,nonatomic,weak) UIView *sui_view;

@property (nullable,nonatomic,readonly,strong) id model;

- (instancetype)initWithModel:(nullable id)model;

- (void)bindWithModel:(id)model;


@end

NS_ASSUME_NONNULL_END
