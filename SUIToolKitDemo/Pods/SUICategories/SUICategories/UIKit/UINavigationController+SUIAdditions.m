//
//  UINavigationController+SUIAdditions.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/2.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "UINavigationController+SUIAdditions.h"
#import "NSObject+SUIAdditions.h"
#import "SUIUtilities.h"
#import "ReactiveCocoa.h"
#import "UIViewController+SUIAdditions.h"

@interface SUINavigationExten : NSObject <UINavigationControllerDelegate>

@property (nonatomic,weak) id<UINavigationControllerDelegate> sui_delegate;

@end

@implementation SUINavigationExten

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.sui_delegate) {
        if ([self.sui_delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
            [self.sui_delegate navigationController:navigationController willShowViewController:viewController animated:animated];
        }
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.sui_delegate) {
        if ([self.sui_delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
            [self.sui_delegate navigationController:navigationController didShowViewController:viewController animated:animated];
        }
    }
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{
    if (self.sui_delegate) {
        if ([self.sui_delegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)]) {
            return [self.sui_delegate navigationControllerSupportedInterfaceOrientations:navigationController];
        }
    }
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController
{
    if (self.sui_delegate) {
        if ([self.sui_delegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]) {
            return [self.sui_delegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
        }
    }
    return UIInterfaceOrientationUnknown;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (self.sui_delegate) {
        if ([self.sui_delegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
            return [self.sui_delegate navigationController:navigationController interactionControllerForAnimationController:animationController];
        }
    }
    return nil;
}
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        toVC.sui_sourceVC = fromVC;
    }
    if (self.sui_delegate) {
        if ([self.sui_delegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
            return [self.sui_delegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
        }
    }
    return nil;
}


@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  UINavigationController
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@implementation UINavigationController (SUIAdditions)


#pragma mark - Setup

- (BOOL)sui_setup
{
    return YES;
}
- (void)setSui_setup:(BOOL)sui_setup
{
    if (sui_setup) {
        @weakify(self)
        [[RACObserve(self, delegate) filter:^BOOL(id value) {
            return ![value isKindOfClass:[SUINavigationExten class]];
        }] subscribeNext:^(id x) {
            @strongify(self)
            self.sui_navigationExten.sui_delegate = x;
            self.delegate = self.sui_navigationExten;
        }];
    }
}

- (SUINavigationExten *)sui_navigationExten
{
    SUINavigationExten *curNavigationExten = [self sui_getAssociatedObjectWithKey:@selector(sui_navigationExten)];
    if (curNavigationExten) return curNavigationExten;
    
    curNavigationExten = [SUINavigationExten new];
    self.sui_navigationExten = curNavigationExten;
    return curNavigationExten;
}
- (void)setSui_navigationExten:(SUINavigationExten *)sui_navigationExten
{
    [self sui_setAssociatedObject:sui_navigationExten key:@selector(sui_navigationExten) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}


#pragma mark - StoryboardLink

- (NSString *)sui_storyboardName
{
    return [self sui_getAssociatedObjectWithKey:@selector(sui_storyboardName)];
}
- (void)setSui_storyboardName:(NSString *)sui_storyboardName
{
    [self sui_setAssociatedObject:sui_storyboardName key:@selector(sui_storyboardName) policy:OBJC_ASSOCIATION_COPY];
    [self performSelectorOnMainThread:@selector(sui_setRootViewController) withObject:nil waitUntilDone:NO];
}

- (NSString *)sui_storyboardID
{
    return [self sui_getAssociatedObjectWithKey:@selector(sui_storyboardID)];
}
- (void)setSui_storyboardID:(NSString *)sui_storyboardID
{
    [self sui_setAssociatedObject:sui_storyboardID key:@selector(sui_storyboardID) policy:OBJC_ASSOCIATION_COPY];
    [self performSelectorOnMainThread:@selector(sui_setRootViewController) withObject:nil waitUntilDone:NO];
}

- (void)sui_setRootViewController
{
    [self sui_performOnce:^{
        UIViewController *curRootVC = nil;
        if (self.sui_storyboardID) {
            curRootVC = gStoryboardInstantiate(self.sui_storyboardName, self.sui_storyboardID);
        } else {
            curRootVC = gStoryboardInitialViewController(self.sui_storyboardName);
        }
        
        uAssert(curRootVC, @"should set Initial View Controller OR set storyboardID")
        [self setViewControllers:@[curRootVC] animated:NO];
        
    } key:NSStringFromSelector(_cmd)];
}


@end
