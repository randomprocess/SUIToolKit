                                                                                 //
//  UIViewController+SUIAdditions.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/11/25.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "UIViewController+SUIAdditions.h"
#import "NSObject+SUIAdditions.h"
#import "NSString+SUIAdditions.h"
#import "SUIUtilities.h"
#import "UIView+SUIAdditions.h"
#import "RACDelegateProxy.h"

@implementation UIViewController (SUIAdditions)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Common
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Common

- (NSString *)sui_identifier
{
    NSString *curIdentifier = [self sui_getAssociatedObjectWithKey:@selector(sui_identifier)];
    if (curIdentifier) return curIdentifier;
    
    NSString *curClassName = NSStringFromClass([self class]);
    curIdentifier = [curClassName sui_regex:@"(?<=^SUI)\\S+(?=VC$)"];
    uAssert(curIdentifier, @"className should prefix with 'SUI' and suffix with 'VC'");
    
    self.sui_identifier = curIdentifier;
    return curIdentifier;
}
- (void)setSui_identifier:(NSString *)sui_identifier
{
    [self sui_setAssociatedObject:sui_identifier key:@selector(sui_identifier) policy:OBJC_ASSOCIATION_COPY_NONATOMIC];
}

- (UITableView *)sui_tableView
{
    UITableView *curTableView = [self sui_getAssociatedObjectWithKey:@selector(sui_tableView)];
    if (curTableView) return curTableView;

    if ([self isKindOfClass:[UITableViewController class]]) {
        curTableView = (UITableView *)self.view;
    } else {
        curTableView = [self.view sui_firstSubviewOfClass:[UITableView class]];
    }
    
    if (curTableView) self.sui_tableView = curTableView;
    return curTableView;
}
- (void)setSui_tableView:(UITableView *)sui_tableView
{
    sui_tableView.sui_vc = self;
    [self sui_setAssociatedObject:sui_tableView key:@selector(sui_tableView) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Geometry
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Geometry

- (CGFloat)sui_opaqueNavBarHeight
{
    CGFloat curNavBarHeight = 0;
    UINavigationBar *curNavigationBar = self.navigationController.navigationBar;
    if (!curNavigationBar.translucent) {
        curNavBarHeight += curNavigationBar.bounds.size.height;
        if (![self prefersStatusBarHidden]) {
            curNavBarHeight += [UIApplication sharedApplication].statusBarFrame.size.height;
        }
    }
    return curNavBarHeight;
}
- (CGFloat)sui_translucentNavBarHeight
{
    CGFloat curNavBarHeight = 0;
    UINavigationBar *curNavigationBar = self.navigationController.navigationBar;
    if (curNavigationBar.translucent) {
        curNavBarHeight += curNavigationBar.bounds.size.height;
        if (![self prefersStatusBarHidden]) {
            curNavBarHeight += [UIApplication sharedApplication].statusBarFrame.size.height;
        }
    }
    return curNavBarHeight;
}

- (CGFloat)sui_opaqueTabBarHeight
{
    UITabBar *curTabBar = self.navigationController.tabBarController.tabBar;
    if (!curTabBar.translucent && ![self hidesBottomBarWhenPushed]) {
        return curTabBar.bounds.size.height;
    }
    return 0;
}
- (CGFloat)sui_translucentTabBarHeight
{
    UITabBar *curTabBar = self.navigationController.tabBarController.tabBar;
    if (curTabBar.translucent && ![self hidesBottomBarWhenPushed]) {
        return curTabBar.bounds.size.height;
    }
    return 0;
}

- (CGRect)sui_viewFrame
{
    return CGRectMake(0, 0, self.view.sui_width, kScreenHeight-self.sui_opaqueNavBarHeight-self.sui_opaqueTabBarHeight);
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  NavBack
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - NavBack

- (IBAction)sui_popToLastVC:(UIStoryboardSegue *)unwindSegue {}

- (IBAction)sui_backToLast
{
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
            }];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (IBAction)sui_backToRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  ModelPassed
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - ModelPassed

- (UIViewController *)sui_sourceVC
{
    return [self sui_getAssociatedObjectWithKey:@selector(sui_sourceVC)];
}
- (void)setSui_sourceVC:(UIViewController *)sui_sourceVC
{
    [self sui_setAssociatedObject:sui_sourceVC key:@selector(sui_sourceVC) policy:OBJC_ASSOCIATION_ASSIGN];
}

- (id)sui_sourceSignal
{
    RACSignal *curSrcSignal = [self sui_getAssociatedObjectWithKey:@selector(sui_sourceSignal)];
    if (curSrcSignal) return curSrcSignal;
    
    if (self.sui_sourceVC.sui_destSignalPassed) {
        curSrcSignal = [self.sui_sourceVC.sui_destSignalPassed(self) replayLazily];
    }
    
    if (curSrcSignal) self.sui_sourceSignal = curSrcSignal;
    return curSrcSignal;
}
- (void)setSui_sourceSignal:(id)sui_sourceSignal
{
    [self sui_setAssociatedObject:sui_sourceSignal key:@selector(sui_sourceSignal) policy:OBJC_ASSOCIATION_ASSIGN];
}

- (RACSignal *(^)(__kindof UIViewController *destVC))sui_destSignalPassed
{
    return [self sui_getAssociatedObjectWithKey:@selector(sui_destSignalPassed)];
}
- (void)sui_signalPassed:(RACSignal *(^)(__kindof UIViewController *cDestVC))cb
{
    [self sui_setAssociatedObject:cb key:@selector(sui_destSignalPassed) policy:OBJC_ASSOCIATION_COPY_NONATOMIC];
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  StoryboardLink
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - StoryboardLink

- (void)sui_storyboardSegueWithIdentifier:(NSString *)cIdentifier
{
    [self performSegueWithIdentifier:cIdentifier sender:self];
}

- (void)sui_storyboardCurrentInstantiateWithStoryboardID:(NSString *)cStoryboardID
{
    [self sui_storyboardCurrentInstantiateWithStoryboardID:cStoryboardID segueType:SUISegueTypePush];
}
- (void)sui_storyboardCurrentInstantiateWithStoryboardID:(NSString *)cStoryboardID segueType:(SUISegueType)cType
{
    UIStoryboard *curStoryboard = self.storyboard;
    [self sui_storyboardInstantiateWithStoryboard:curStoryboard storyboardID:cStoryboardID segueType:cType];
}

- (void)sui_storyboardInstantiate:(NSString *)cName storyboardID:(NSString *)cStoryboardID
{
    [self sui_storyboardInstantiate:cName storyboardID:cStoryboardID segueType:SUISegueTypePush];
}
- (void)sui_storyboardInstantiate:(NSString *)cName storyboardID:(NSString *)cStoryboardID segueType:(SUISegueType)cType
{
    UIStoryboard *curStoryboard = gStoryboardNamed(cName);
    [self sui_storyboardInstantiateWithStoryboard:curStoryboard storyboardID:cStoryboardID segueType:cType];
}

- (void)sui_storyboardInstantiateWithStoryboard:(UIStoryboard *)cStoryboard storyboardID:(NSString *)cStoryboardID segueType:(SUISegueType)cType
{
    UIViewController *curVC = nil;
    if (cStoryboardID) {
        curVC = [cStoryboard instantiateViewControllerWithIdentifier:cStoryboardID];
    } else {
        curVC = cStoryboard.instantiateInitialViewController;
    }
    
    if ([curVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *curNav = (UINavigationController *)curVC;
        curNav.topViewController.sui_sourceVC = self;
        [self presentViewController:curVC animated:YES completion:nil];
    } else {
        if (cType == SUISegueTypePush) {
            [self.navigationController pushViewController:curVC animated:YES];
        } else {
            curVC.sui_sourceVC = self;
            [self presentViewController:curVC animated:YES completion:nil];
        }
    }
}


@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Alert & ActionSheet
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - *** Alert & ActionSheet ***

@interface SUIAlertAction ()

@property (nonatomic,copy) void (^sui_handler)(SUIAlertAction *cAction);

@end

@implementation SUIAlertAction

+ (instancetype)actionWithTitle:(NSString *)cTitle style:(SUIAlertActionStyle)cStyle handler:(void (^)(SUIAlertAction *))cHandler
{
    SUIAlertAction *curAlertAction = [SUIAlertAction new];
    [curAlertAction sui_actionWithTitle:cTitle style:cStyle handler:cHandler];
    return curAlertAction;
}

- (void)sui_actionWithTitle:(NSString *)cTitle style:(SUIAlertActionStyle)cStyle handler:(void (^)(SUIAlertAction *))cHandler
{
    _enabled = YES;
    _style = cStyle;
    _title = cTitle;
    self.sui_handler = cHandler;
}

@end


@interface SUIAlertController () <UIActionSheetDelegate, UIAlertViewDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

@property (nonatomic,strong) NSMutableArray<SUIAlertAction *> *sui_actions;

// iOS7
@property (nonatomic,weak) UIAlertView *sui_alertView;
@property (nonatomic,weak) UIActionSheet *sui_actionSheet;

#pragma clang diagnostic pop

// iOS8 +
@property (nonatomic,weak) UIViewController *sui_vc;
@property (nonatomic,weak) UIAlertController *sui_alertController;

@end

@implementation SUIAlertController

- (void)sui_showAlertWithTitle:(NSString *)cTitle
                       message:(NSString *)cMessage
                         style:(SUIAlertStyle)cStyle
{
    self.title = cTitle;
    self.message = cMessage;
    _style = cStyle;
}

- (void)addAction:(SUIAlertAction *)cAction
{
    [self.sui_actions addObject:cAction];
}

- (SUIAlertAction *)addTitle:(nullable NSString *)cTitle
           style:(SUIAlertActionStyle)cStyle
         handler:(void (^)(SUIAlertAction *cAction))cHandler
{
    SUIAlertAction *curAlertAction = [SUIAlertAction actionWithTitle:cTitle style:cStyle handler:cHandler];
    [self addAction:curAlertAction];
    return curAlertAction;
}

- (void)show
{
    [self sui_showAlertController];
}

- (void)sui_showAlertController
{
    if (kAboveIOS8)
    {
        UIAlertController *curAlertController = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:(UIAlertControllerStyle)self.style];
        self.sui_alertController = curAlertController;
        [curAlertController sui_setAssociatedObject:self key:_cmd policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
        
        for (SUIAlertAction *cAction in self.sui_actions) {
            
            @weakify(cAction)
            UIAlertAction *curAction = [UIAlertAction actionWithTitle:cAction.title style:(UIAlertActionStyle)cAction.style handler:^(UIAlertAction * _Nonnull action) {
                @strongify(cAction)
                if (cAction.sui_handler) {
                    cAction.sui_handler(cAction);
                }
            }];
            [self.sui_alertController addAction:curAction];
            
            RAC(curAction, enabled) = RACObserve(cAction, enabled);
        }
        [self.sui_vc presentViewController:self.sui_alertController animated:YES completion:nil];
    }
    else
    {
        {
            __block SUIAlertAction *cancelAlertAction = nil;
            __block NSInteger curIndex = 0;
            [self.sui_actions enumerateObjectsUsingBlock:^(SUIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.style == SUIAlertActionCancel) {
                    cancelAlertAction = obj;
                    curIndex = idx;
                    *stop = YES;
                }
            }];
            
            if (cancelAlertAction && curIndex > 0)
            {
                [self.sui_actions removeObject:cancelAlertAction];
                [self.sui_actions insertObject:cancelAlertAction atIndex:0];
            }
            
            
            if (self.style == SUIAlertStyleActionSheet)
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                UIActionSheet *curActionSheet = [[UIActionSheet alloc] initWithTitle:self.title
                                                                            delegate:nil
                                                                   cancelButtonTitle:cancelAlertAction.title
                                                              destructiveButtonTitle:nil
                                                                   otherButtonTitles:nil, nil];
#pragma clang diagnostic pop
                self.sui_actionSheet = curActionSheet;
                [curActionSheet sui_setAssociatedObject:self key:_cmd policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];

                [self.sui_actions enumerateObjectsUsingBlock:^(SUIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (cancelAlertAction != obj) {
                        [curActionSheet addButtonWithTitle:obj.title];
                        if (obj.style == SUIAlertActionDestructive) {
                            curActionSheet.destructiveButtonIndex = idx;
                        }
                    }
                }];
                
                @weakify(self)
                [[curActionSheet rac_buttonClickedSignal] subscribeNext:^(NSNumber *cIndex) {
                    @strongify(self)
                    SUIAlertAction *curAlertAction = self.sui_actions[cIndex.integerValue];
                    if (curAlertAction.sui_handler) curAlertAction.sui_handler(curAlertAction);
                }];
                [self.sui_actionSheet showInView:gWindow];
            }
            else if (self.style == SUIAlertStyleAlert)
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                UIAlertView *curAlertView = [[UIAlertView alloc] initWithTitle:self.title
                                                                       message:self.message
                                                                      delegate:self
                                                             cancelButtonTitle:cancelAlertAction.title
                                                             otherButtonTitles:nil, nil];
#pragma clang diagnostic pop
                self.sui_alertView = curAlertView;
                [curAlertView sui_setAssociatedObject:self key:_cmd policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
                
                for (SUIAlertAction *cAction in self.sui_actions)
                {
                    if (cancelAlertAction == cAction) continue;
                    [curAlertView addButtonWithTitle:cAction.title];
                }
                [curAlertView show];
            }
        }

    }
    
    {
        @weakify(self)
        [[RACObserve(self, title) skip:1] subscribeNext:^(id x) {
            @strongify(self)
            if (kAboveIOS8) {
                self.sui_alertController.title = x;
            } else if (self.style == SUIAlertStyleActionSheet) {
                self.sui_actionSheet.title = x;
            } else if (self.style == SUIAlertStyleAlert) {
                self.sui_alertView.title = x;
            }
        }];
        
        [[RACObserve(self, message) skip:1] subscribeNext:^(id x) {
            @strongify(self)
            if (kAboveIOS8) {
                self.sui_alertController.message = x;
            } else if (self.style == SUIAlertStyleActionSheet) {
                //
            } else if (self.style == SUIAlertStyleAlert) {
                self.sui_alertView.message = x;
            }
        }];
    }
}

- (NSArray<SUIAlertAction *> *)actions
{
    return self.sui_actions;
}

- (NSMutableArray<SUIAlertAction *> *)sui_actions
{
    if (!_sui_actions) {
        _sui_actions = [NSMutableArray array];
    }
    return _sui_actions;
}

// UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SUIAlertAction *curAlertAction = self.sui_actions[buttonIndex];
    if (curAlertAction.sui_handler) curAlertAction.sui_handler(curAlertAction);
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (self.sui_alertView.firstOtherButtonIndex > -1)
    {
        SUIAlertAction *curAlertAction = self.sui_actions[self.sui_alertView.firstOtherButtonIndex];
        return curAlertAction.enabled;
    }
    return YES;
}

@end


@implementation UIViewController (SUIAlertController)

- (SUIAlertController *)sui_showAlertWithTitle:(NSString *)cTitle
                                       message:(NSString *)cMessage
                                         style:(SUIAlertStyle)cStyle
{
    SUIAlertController *aAlertController = [SUIAlertController new];
    aAlertController.sui_vc = self;
    [aAlertController sui_showAlertWithTitle:cTitle message:cMessage style:cStyle];
    return aAlertController;
}

@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  UITableView
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - *** UITableView ***

@implementation UITableView (SUIViewController)

- (UIViewController *)sui_vc
{
    UIViewController *curVC = [self sui_getAssociatedObjectWithKey:@selector(sui_vc)];
    if (curVC) return curVC;
    
    curVC = [self sui_currentVC];
    if (curVC) {
        self.sui_vc = curVC;
    }
    return curVC;
}

- (void)setSui_vc:(UIViewController *)sui_vc
{
    [self sui_setAssociatedObject:sui_vc key:@selector(sui_vc) policy:OBJC_ASSOCIATION_ASSIGN];
}

@end
