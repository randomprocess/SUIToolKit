//
//  UIViewController+SUIAdditions.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/11/25.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveCocoa.h"

@class SUIAlertController;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SUIAlertActionStyle) {
    SUIAlertActionDefault = 0,
    SUIAlertActionCancel,
    SUIAlertActionDestructive
};

typedef NS_ENUM(NSInteger, SUIAlertStyle) {
    SUIAlertStyleActionSheet = 0,
    SUIAlertStyleAlert
};

typedef NS_ENUM(NSInteger, SUISegueType) {
    SUISegueTypePush = 0,
    SUISegueTypeModal
};

@interface UIViewController (SUIAdditions)


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Common
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Common

@property (null_resettable,copy) NSString *sui_identifier;
@property (nullable,nonatomic,strong) UITableView *sui_tableView;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Geometry
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - Geometry

@property (readonly) CGFloat sui_opaqueNavBarHeight;
@property (readonly) CGFloat sui_translucentNavBarHeight;
@property (readonly) CGFloat sui_opaqueTabBarHeight;
@property (readonly) CGFloat sui_translucentTabBarHeight;
@property (readonly) CGRect sui_viewFrame;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  NavBack
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - NavBack

- (IBAction)sui_backToLast;
- (IBAction)sui_backToRoot;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  ModelPassed
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - ModelPassed

@property (nullable,nonatomic,weak) UIViewController *sui_sourceVC;
@property (nullable,nonatomic,strong) RACSignal *sui_sourceSignal;

- (void)sui_signalPassed:(RACSignal *(^)(__kindof UIViewController *cDestVC))cb;


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  StoryboardLink
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - StoryboardLink

- (void)sui_storyboardSegueWithIdentifier:(NSString *)cIdentifier;

- (void)sui_storyboardCurrentInstantiateWithStoryboardID:(NSString *)cStoryboardID;
- (void)sui_storyboardCurrentInstantiateWithStoryboardID:(NSString *)cStoryboardID segueType:(SUISegueType)cType;
- (void)sui_storyboardInstantiate:(NSString *)cName storyboardID:(nullable NSString *)cStoryboardID;
- (void)sui_storyboardInstantiate:(NSString *)cName storyboardID:(nullable NSString *)cStoryboardID segueType:(SUISegueType)cType;
- (void)sui_storyboardInstantiateWithStoryboard:(UIStoryboard *)cStoryboard storyboardID:(nullable NSString *)cStoryboardID segueType:(SUISegueType)cType;

@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  Alert & ActionSheet
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - *** Alert & ActionSheet ***

@interface SUIAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)cTitle
                          style:(SUIAlertActionStyle)cStyle
                        handler:(void (^ __nullable)(SUIAlertAction *cAction))cHandler;

@property (nonatomic,readonly) SUIAlertActionStyle style;
@property (nullable,nonatomic,readonly) NSString *title;
@property (nonatomic) BOOL enabled;

@end


@interface SUIAlertController : NSObject

- (void)addAction:(SUIAlertAction *)cAction;
- (SUIAlertAction *)addTitle:(nullable NSString *)cTitle
                       style:(SUIAlertActionStyle)cStyle
                     handler:(void (^ __nullable)(SUIAlertAction *cAction))cHandler;

@property (nonatomic,readonly) NSArray<SUIAlertAction *> *actions;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;

@property (nonatomic, readonly) SUIAlertStyle style;



- (void)show;

@end


@interface UIViewController (SUIAlertController)

- (SUIAlertController *)sui_showAlertWithTitle:(nullable NSString *)cTitle
                                       message:(nullable NSString *)cMessage
                                         style:(SUIAlertStyle)cStyle;

@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  UITableView
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - *** UITableView ***

@interface UITableView (SUIViewController)

@property (nullable,nonatomic,weak) UIViewController *sui_vc;

@end

NS_ASSUME_NONNULL_END
