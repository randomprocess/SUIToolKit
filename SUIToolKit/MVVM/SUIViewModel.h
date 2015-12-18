//
//  SUIViewModel.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SUIViewModel;
@protocol SUIViewModelCellProtocal;

NS_ASSUME_NONNULL_BEGIN

@protocol SUIViewModelProtocol <NSObject>
@optional

- (SUIViewModel *)viewModelPassed:(__kindof UIViewController *)cDestVC;

@end


@interface SUIViewModel : NSObject <SUIViewModelProtocol, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,weak) UIViewController<SUIViewModelCellProtocal> *sui_vc;

@property (nonatomic,readonly,strong) id model;

- (instancetype)initWithModel:(id)model;

- (nullable id)currentModelAtIndex:(NSIndexPath *)cIndexPath;

@end

NS_ASSUME_NONNULL_END
