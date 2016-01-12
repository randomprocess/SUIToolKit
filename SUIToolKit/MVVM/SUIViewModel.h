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

#define SUIVMObserve(__MD_PROPERTY) [RACObserve(self.model, __MD_PROPERTY) takeUntil:[RACObserve(self, model) skip:1]]
#define SUIVMRAC(__SELF_PROPERTY, __MD_PROPERTY) RAC(self, __SELF_PROPERTY) = SUIVMObserve(__MD_PROPERTY);

//#define SUIVIEWObserve(__VM_TYPE, __VM_PROPERTY) ({typeof(__VM_TYPE *) __VM = self.sui_vm; \
RACObserve(__VM, __VM_PROPERTY);})
#define SUIVIEWObserve(__VM_PROPERTY) RACObserve(self.sui_vm, __VM_PROPERTY)
#define SUICELLObserve(__VM_PROPERTY) [RACObserve(self.sui_vm, __VM_PROPERTY) takeUntil:self.rac_prepareForReuseSignal]

#define SUICOMMAND(__SIGNAL) ({@weakify(self);[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) { \
uWarcUnused(@strongify(self)) \
return __SIGNAL; \
}];}) \

NS_ASSUME_NONNULL_BEGIN

@protocol SUIViewModelDelagate <NSObject>
@optional

- (void)sui_commonInit;
- (id)sui_modelPassed:(__kindof UIViewController *)cDestVC;

@end


@interface SUIViewModel : NSObject <SUIViewModelDelagate>

@property (nonatomic,weak) UIViewController *sui_vc;

@property (nullable,nonatomic,readonly,strong) id model;

- (instancetype)initWithModel:(nullable id)model;

- (void)bindWithModel:(id)model;


@end

NS_ASSUME_NONNULL_END
