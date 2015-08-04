//
//  SUIDropdownTitleMenu.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/4.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIDropdownTitleMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "SUIToolKitConst.h"
#import "SUIBaseProtocol.h"
#import "SUITool.h"
#import "UIView+SUIExt.h"
#import "UIImage+SUIExt.h"

typedef NS_ENUM(NSInteger, SUIDropdownTitleMenuState)
{
    SUIDropdownTitleMenuStateWillOpen   = 0,
    SUIDropdownTitleMenuStateDidOpen    = 1,
    SUIDropdownTitleMenuStateWillClose  = 2,
    SUIDropdownTitleMenuStateDidClose   = 3
};

#define tAnimationDuration 0.8
#define tBlackMaskAlpha 0.8
#define tMenuHeight 50.0
#define tMenuView_MaxHeight 30.0

// _____________________________________________________________________________

@interface SUIDropdownMenuItemCell: UITableViewCell

@property (nonatomic,strong) UIImageView *menuView;
@property (nonatomic,strong) UIImageView *selectImgView;

@end


@implementation SUIDropdownMenuItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.menuView];
        [self.contentView addSubview:self.selectImgView];
    }
    return self;
}

- (UIImageView *)menuView
{
    if (!_menuView) {
        _menuView = [[UIImageView alloc] init];
        _menuView.contentMode = UIViewContentModeCenter;
        _menuView.frame = self.contentView.bounds;
        _menuView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _menuView;
}


- (UIImageView *)selectImgView
{
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 13)];
        _selectImgView.center = CGPointMake(self.contentView.width / 4 * 3, self.contentView.height / 2);
        _selectImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _selectImgView.image = [self imageIfCamvas];
    }
    return _selectImgView;
}

- (UIImage *)imageIfCamvas
{
    UIImage *curImage;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 13), NO, 0.0f);
    [self drawCanvas];
    curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return curImage;
}

- (void)drawCanvas
{
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(2.56, 4.81)];
    [bezierPath addLineToPoint: CGPointMake(8.21, 10.11)];
    [bezierPath addLineToPoint: CGPointMake(16.92, 0)];
    [bezierPath addLineToPoint: CGPointMake(20.0, 2.41)];
    [bezierPath addLineToPoint: CGPointMake(8.21, 13.1)];
    [bezierPath addLineToPoint: CGPointMake(0, 7.32)];
    [bezierPath addLineToPoint: CGPointMake(2.56, 4.81)];
    [bezierPath closePath];
    [UIColor.whiteColor setFill];
    [bezierPath fill];
    [UIColor.blackColor setStroke];
    bezierPath.lineWidth = 0.5;
    [bezierPath stroke];
}

@end


// _____________________________________________________________________________

@interface SUIDropdownTitleMenu () <UITableViewDataSource, UITableViewDelegate, SUIBaseProtocol>

@property (nonatomic,assign) NSInteger currIndex;
@property (nonatomic,strong) NSArray *currTitles;

@property (nonatomic,strong) UIButton *currTitleBtn;
@property (nonatomic,strong) UIImageView *arrowView;

@property (nonatomic,strong) UITableView *menuTableView;
@property (nonatomic,strong) UIView *menuView;
@property (nonatomic,strong) UIScrollView *mainView;
@property (nonatomic,strong) UIButton *backgroundButton;

@property (nonatomic,assign) SUIDropdownTitleMenuState currState;
@property (nonatomic,assign) CGFloat currNavBarHeight;

@end

@implementation SUIDropdownTitleMenu

- (void)awakeFromNib
{
    NSAssert(self.currVC, @"should link currVC");
    
    self.currVC.navigationItem.titleView = self.currTitleBtn;
    self.currIndex = 0;
    self.currState = SUIDropdownTitleMenuStateDidClose;
    
    uWeakSelf
    [SUITool delay:0.1 cb:^{
        UINavigationBar *curNavigationBar = self.currVC.navigationController.navigationBar;
        if (curNavigationBar.translucent)
        {
            weakSelf.currNavBarHeight = curNavigationBar.bounds.size.height;
            if (![UIApplication sharedApplication].statusBarHidden)
            {
                weakSelf.currNavBarHeight += [UIApplication sharedApplication].statusBarFrame.size.height;
            }
        }
    }];
}


#pragma mark - Show, Dismiss

- (void)doTitleBtn
{
    if ([self isShowing]) {
        [self dismiss];
    } else {
        [self show];
    }
}

- (void)doBackgroundButton
{
    [self dismiss];
}

- (BOOL)isShowing
{
    return self.currState == SUIDropdownTitleMenuStateDidOpen;
}

- (void)show
{
    if (self.currState == SUIDropdownTitleMenuStateDidClose)
    {
        self.currState = SUIDropdownTitleMenuStateWillOpen;
        
        [self setupMenu];
        [self addMenuAnimation];
        
        uWeakSelf
        [SUITool delay:tAnimationDuration cb:^{
            weakSelf.currState = SUIDropdownTitleMenuStateDidOpen;
        }];
    }
}

- (void)dismiss
{
    if (self.currState == SUIDropdownTitleMenuStateDidOpen)
    {
        self.currState = SUIDropdownTitleMenuStateWillClose;
        
        [self addMenuAnimation];
        
        uWeakSelf
        [UIView animateWithDuration:tAnimationDuration
                         animations:^{
                             weakSelf.backgroundButton.alpha = 0;
                         } completion:^(BOOL finished) {
                             [weakSelf.menuView removeFromSuperview];
                             [weakSelf.backgroundButton removeFromSuperview];
                             [weakSelf.menuTableView removeFromSuperview];
                             [weakSelf.mainView removeFromSuperview];
                             weakSelf.currState = SUIDropdownTitleMenuStateDidClose;
                         }];
    }
}


- (void)setupMenu
{
    self.mainView.frame = self.currVC.view.bounds;
    [self.currVC.view addSubview:self.mainView];
    
    self.backgroundButton.frame = CGRectMake(0, 0, self.mainView.width, self.mainView.height);
    self.backgroundButton.alpha = 1.0;
    [self.mainView addSubview:self.backgroundButton];
    
    self.menuView.frame = CGRectMake(0, -self.mainView.height, self.mainView.width, self.mainView.height);
    [self.mainView addSubview:self.menuView];
    
    CGFloat menuHeight = self.currTitles.count * tMenuHeight;
    self.menuTableView.frame = CGRectMake(0, self.menuView.height - menuHeight, kScreenWidth, menuHeight);
    [self.menuTableView reloadData];
    [self.menuView addSubview:self.menuTableView];
}


#pragma mark - Animation

- (void)addMenuAnimation
{
    CATransform3D rotationTransform = CATransform3DMakeRotation(0, 0, 0, 0);
    
    CGFloat curMenuViewY = - self.mainView.height;
    if (self.currState == SUIDropdownTitleMenuStateWillOpen || self.currState == SUIDropdownTitleMenuStateDidOpen)
    {
        curMenuViewY += (self.menuTableView.height + self.currNavBarHeight);
        
        if (gRandomInRange(0, 1)) {
            rotationTransform = CATransform3DMakeRotation(gDegree(180), 1, 0, 0);
        } else {
            rotationTransform = CATransform3DMakeRotation(gDegree(180), 0, 0, 1);
        }
    }
    
    if (curMenuViewY != self.menuView.frame.origin.y)
    {
        uWeakSelf
        [UIView animateWithDuration:tAnimationDuration
                              delay:0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             weakSelf.menuView.y = curMenuViewY;
                             weakSelf.arrowView.layer.transform = rotationTransform;
                         } completion:^(BOOL finished) {
                         }];
    }
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SUIDropdownMenuItemCell";
    SUIDropdownMenuItemCell *curCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (curCell == nil)
    {
        curCell = [[SUIDropdownMenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    curCell.menuView.image = self.currTitles[indexPath.row];
    curCell.selectImgView.hidden = (indexPath.row != self.currIndex);
    return curCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismiss];
    
    if (indexPath.row != self.currIndex)
    {
        NSIndexPath *everIndexPath = [NSIndexPath indexPathForRow:self.currIndex inSection:0];
        SUIDropdownMenuItemCell *everCell = (SUIDropdownMenuItemCell *)[tableView cellForRowAtIndexPath:everIndexPath];
        everCell.selectImgView.hidden = YES;
        
        SUIDropdownMenuItemCell *currCell = (SUIDropdownMenuItemCell *)[tableView cellForRowAtIndexPath:indexPath];
        currCell.selectImgView.hidden = NO;
        
        if ([self.currVC respondsToSelector:@selector(suiDropdownTitleMenuDidSelectAtIndex:)])
        {
            [(id<SUIBaseProtocol>)self.currVC suiDropdownTitleMenuDidSelectAtIndex:indexPath.row];
        }
    }
    
    self.currIndex = indexPath.row;
}


#pragma mark -

- (void)setCurrIndex:(NSInteger)currIndex
{
    _currIndex = currIndex;
    
    UIImage *curImage = self.currTitles[_currIndex];
    [self.currTitleBtn setImage:curImage forState:UIControlStateNormal];
}

- (NSArray *)currTitles
{
    if (!_currTitles)
    {
        NSMutableArray *titleAry = [NSMutableArray array];
        for (UIView *curView in [self currMenuViews])
        {
            UIImage *curImage = [curView snapshot];
            if (curImage.size.height > tMenuView_MaxHeight) {
                [titleAry addObject:[curImage toFitHeight:tMenuView_MaxHeight]];
            } else {
                [titleAry addObject:curImage];
            }
        }
        _currTitles = titleAry;
    }
    return _currTitles;
}

- (NSArray *)currMenuViews
{
    NSArray *menuViews = nil;
    if ([self.currVC respondsToSelector:@selector(suiDropdownTitleMenuViews:)])
    {
        menuViews = [(id<SUIBaseProtocol>)self.currVC suiDropdownTitleMenuViews:self];
    }
    else if ([self.currVC respondsToSelector:@selector(suiDropdownTitleMenuTitles:)])
    {
        NSArray *menuTitles = [(id<SUIBaseProtocol>)self.currVC suiDropdownTitleMenuTitles:self];
        NSMutableArray *titleAry = [NSMutableArray array];
        for (NSString *curTitle in menuTitles)
        {
            UILabel *titleLbl = [[UILabel alloc] init];
            titleLbl.backgroundColor = [UIColor clearColor];
            titleLbl.tintColor = self.titleColo ? self.titleColo : [UIColor blackColor];
            titleLbl.font = gFont(16);
            titleLbl.text = curTitle;
            [titleLbl sizeToFit];
            [titleAry addObject:titleLbl];
        }
        menuViews = titleAry;
    }
    NSAssert(menuViews.count > 0, @"menuViews.count MUST > 0");
    return menuViews;
}

- (UIButton *)currTitleBtn
{
    if (!_currTitleBtn)
    {
        _currTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _currTitleBtn.backgroundColor = [UIColor clearColor];
        _currTitleBtn.frame = CGRectMake(0, 0, gAdapt(150), 44);
        [_currTitleBtn addTarget:self action:@selector(doTitleBtn) forControlEvents:UIControlEventTouchUpInside];
        _currTitleBtn.contentMode = UIViewContentModeCenter;
        
        [_currTitleBtn addSubview:self.arrowView];
        self.arrowView.frame = (CGRect) {
            {(_currTitleBtn.width-self.arrowView.width)/2,
                _currTitleBtn.height-self.arrowView.height-5},
            {self.arrowView.width, self.arrowView.height}
        };
        self.arrowView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _currTitleBtn;
}

- (UIImageView *)arrowView
{
    if (!_arrowView)
    {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = [self imageOfArrow];
        [_arrowView sizeToFit];
    }
    return _arrowView;
}

- (UIImage *)imageOfArrow
{
    UIImage *curImage;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(12, 4), NO, 0.0f);
    [self drawCanvas];
    curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return curImage;
}

- (void)drawCanvas
{
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.096 green: 0.38 blue: 0.673 alpha: 0.617];
    UIColor* color2 = [UIColor colorWithRed: 0.118 green: 0.852 blue: 0.118 alpha: 1];
    
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
    [bezier3Path moveToPoint: CGPointMake(0, 0)];
    [bezier3Path addLineToPoint: CGPointMake(0.83, 0)];
    [bezier3Path addLineToPoint: CGPointMake(6, 3.68)];
    [bezier3Path addLineToPoint: CGPointMake(6, 4)];
    [bezier3Path addLineToPoint: CGPointMake(0, 0)];
    [bezier3Path closePath];
    [bezier3Path moveToPoint: CGPointMake(12, 0)];
    [bezier3Path addLineToPoint: CGPointMake(11.17, 0)];
    [bezier3Path addLineToPoint: CGPointMake(6, 3.68)];
    [bezier3Path addLineToPoint: CGPointMake(6, 4)];
    [bezier3Path addLineToPoint: CGPointMake(12, 0)];
    [bezier3Path closePath];
    [color2 setFill];
    [bezier3Path fill];
    [color setStroke];
    bezier3Path.lineWidth = 0.5;
    [bezier3Path stroke];
}

- (UITableView *)menuTableView
{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] init];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.rowHeight = tMenuHeight;
        _menuTableView.backgroundColor = [UIColor clearColor];
    }
    return _menuTableView;
}

- (UIView *)menuView
{
    if (!_menuView) {
        _menuView = [UIView new];
        _menuView.backgroundColor = self.backgroundColo ? self.backgroundColo : gRGB(40, 196, 80);
    }
    return _menuView;
}

- (UIScrollView *)mainView
{
    if (!_mainView) {
        _mainView = [UIScrollView new];
        _mainView.backgroundColor = [UIColor clearColor];
    }
    return _mainView;
}

- (UIButton *)backgroundButton
{
    if (!_backgroundButton) {
        _backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundButton.backgroundColor = gRGBA(0, 0, 0, tBlackMaskAlpha);
        [_backgroundButton addTarget:self action:@selector(doBackgroundButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundButton;
}


@end
