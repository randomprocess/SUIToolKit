//
//  SUIToolbar.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/31.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "SUIToolbar.h"
#import "ReactiveCocoa.h"
#import "NSObject+SUIAdditions.h"
#import "SUIMacros.h"
#import "UIView+SUIAdditions.h"

@interface SUIToolbar ()

@property (nonatomic) CGFloat keyboardBottomValue;
@property (nonatomic) CGFloat keyboardAnimationDuration;
@property (nonatomic) CGFloat viewsBottomValue;
@property (nonatomic,strong) NSLayoutConstraint *bottomConstraint;

@end

@implementation SUIToolbar


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit
{
    @weakify(self)
    [[[[[RACSignal combineLatest:@[
                                   RACObserve(self, keyboardBottomValue),
                                   RACObserve(self, viewsBottomValue)
                                   ]
                          reduce:^id(NSNumber *kValue, NSNumber *vValue) {
                              @strongify(self)
                              if (NSOrderedAscending == [kValue compare:vValue]) {
                                  return RACTuplePack(vValue, @(self.viewsAnimationDuration));
                              } else {
                                  return RACTuplePack(kValue, @(self.keyboardAnimationDuration));
                              }
                          }]
        distinctUntilChanged]
       skip:1]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(RACTuple *cTuple) {
         @strongify(self)
         RACTupleUnpack(NSNumber *cValue, NSNumber *cDuration) = cTuple;
         
         CGFloat curBottomValue = [cValue doubleValue];
         NSTimeInterval animateDuration = cDuration.doubleValue;
         
         [UIView animateWithDuration:animateDuration
                               delay:0
                             options:UIViewAnimationOptionBeginFromCurrentState
                          animations:^{
                              self.bottomConstraint.constant = curBottomValue;
                              [self layoutIfNeeded];
                          } completion:^(BOOL finished) {
                          }];
     }];
    
    
    [[[[[RACObserve(self, onTopOfKeyboard)
         map:^id(NSNumber *cRet) {
             @strongify(self)
             if (cRet.boolValue) {
                 return self.sui_keyboardWillChangeSignal;
             }
             return nil;
         }]
        switchToLatest]
       ignore:nil]
      doNext:^(SUIKeyboardInfo *cInfo) {
          @strongify(self)
          if (!cInfo.show) {
              [self updateWithTopOfView];
          }
      }]
     subscribeNext:^(SUIKeyboardInfo *cInfo) {
         @strongify(self)
         CGFloat curBottomValue = (cInfo.show) ? cInfo.keyboardHeight : 0;
         if (curBottomValue != self.keyboardBottomValue) {
             self.keyboardAnimationDuration = cInfo.duration;
             self.keyboardBottomValue = curBottomValue;
         }
     }];
    
    
    [[RACObserve(self, topOfView) skip:1] subscribeNext:^(UIView *cTopOfView) {
        @strongify(self)
        [self updateWithTopOfView];
    }];
}

- (void)updateWithTopOfView
{
    if (self.topOfView)
    {
        CGFloat curBottomValue = 0;
        CGRect curRect = [self.topOfView.superview convertRect:self.topOfView.frame toView:gWindow];
        curBottomValue = MAX(curBottomValue, kScreenHeight-curRect.origin.y);
        if (curBottomValue != self.viewsBottomValue) {
            self.viewsBottomValue = curBottomValue;
        }
    }
}

- (NSLayoutConstraint *)bottomConstraint
{
    if (!_bottomConstraint) {
        _bottomConstraint = [self sui_layoutConstraintBottom];
        if (!_bottomConstraint) {
            _bottomConstraint = [self sui_layoutConstraintTop];
        }
        uAssert(_bottomConstraint, @"SUIToolbar need to add contantBottom");
    }
    return _bottomConstraint;
}


@end
