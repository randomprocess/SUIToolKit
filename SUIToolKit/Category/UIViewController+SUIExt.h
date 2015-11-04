//
//  UIViewController+SUIExt.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef id (^SUIModelPassedBlock)(NSString *destIdentifier);
typedef void (^SUIBackRefreshedBlock)(id cModel, NSString *destIdentifier);
typedef void (^SUIDoActionBlock)(id cSender, id cModel);


@interface UIViewController (SUIExt)

@property (nonatomic,weak) UITableView *currTableView;
@property (nonatomic,copy) NSString *currIdentifier;

@end


@interface UIViewController (SUIGeometry)

- (CGFloat)opaqueNavBarHeight;
- (CGFloat)opaqueTabBarHeight;
- (CGFloat)translucentNavBarHeight;
- (CGFloat)translucentTabBarHeight;
- (CGRect)viewRect;

@end


@interface UIViewController (SUIModelPassed)

@property (nonatomic,strong) id srcModel;
@property (nonatomic,strong) id destModel;
@property (nonatomic,weak) UIViewController *srcVC;
@property (nonatomic,copy) SUIBackRefreshedBlock destBackRefreshedBlock;
@property (nonatomic,copy) SUIDoActionBlock destDoAction;

- (void)modelPassed:(SUIModelPassedBlock)cb;
- (void)backRefreshed:(SUIBackRefreshedBlock)cb;
- (void)doAction:(SUIDoActionBlock)cb;

- (void)refreshSrc:(id)cModel;

@end


@interface UIViewController (SUINavBackAction)

- (IBAction)navPopToLast:(id)sender;
- (IBAction)navPopToRoot:(id)sender;
- (IBAction)navDismiss:(id)sender;

@end


@interface UIViewController (SUILoadingView)

@property (nonatomic) IBInspectable BOOL addLoading;
@property (nonatomic,strong) UIView *loadingView;

- (void)loadingViewShow;
- (void)loadingViewDissmiss;

@end


@interface UITableView (SUICurrVC)

@property (nonatomic,weak) UIViewController *currVC;

@end
