//
//  SUIBaseView.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/2.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBaseView.h"
#import "SUIToolKitConst.h"
#import "UIView+SUIExt.h"
#import "UIViewController+SUIExt.h"

@interface SUIBaseView ()

@property (nonatomic,strong) UIView *mainView;

@end

@implementation SUIBaseView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIView *curMainView = [[NSBundle mainBundle] loadNibNamed:gClassName(self) owner:self options:nil][0];
    uAssert(curMainView != nil, @"> <");
    self.mainView = curMainView;
    [self addSubview:self.mainView];
        
    self.backgroundColor = [UIColor clearColor];
    self.mainView.frame = self.bounds;
    self.mainView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (IBAction)doAction:(id)sender
{
    UIViewController *currVC = self.theVC;
    if (currVC.destDoAction) {
        currVC.destDoAction(sender, nil);
    }
}


@end
