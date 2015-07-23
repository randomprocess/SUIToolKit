//
//  SUIBaseView.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/2.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIBaseView.h"
#import "SUIToolKitConst.h"

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
    NSAssert(curMainView != nil, @"> <");
    self.mainView = curMainView;
    [self addSubview:self.mainView];
    
    self.backgroundColor = [UIColor clearColor];
    self.mainView.frame = self.bounds;
    self.mainView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    if (_ibDelegate != nil) {
        self.bsDelegate = _ibDelegate;
    }
}

- (IBAction)doAction:(id)sender
{
    if ([self.bsDelegate respondsToSelector:@selector(handlerAction:cModel:)])
    {
        [self.bsDelegate handlerAction:sender cModel:nil];
    }
}

@end
