//
//  SUIDropdownTitleView.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/3.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIDropdownTitleView.h"
#import "SUIToolKitConst.h"
#import "SUIBaseProtocol.h"
#import "SUITool.h"

typedef NS_ENUM(NSInteger, SUIDropdownTitleViewState)
{
    SUIDropdownTitleViewStateWillOpen   = 0,
    SUIDropdownTitleViewStateDidOpen    = 1,
    SUIDropdownTitleViewStateWillClose  = 2,
    SUIDropdownTitleViewStateDidClose   = 3
};

#define tBackgroundColor gRGB(40, 196, 80)
#define tAnimationDuration 0.8
#define tBlurRadius 5.0
#define tBlackMaskAlpha 0.8
#define tMenuHeight 50.0


// _____________________________________________________________________________

@interface SUIDropdownMenuItemCell: UITableViewCell

@property (nonatomic,strong) UILabel *menuLbl;
@property (nonatomic,strong) UIImageView *selectImgView;

@end


@implementation SUIDropdownMenuItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.frame = CGRectMake(0, 0, kScreenWidth, tMenuHeight-1);
        [self.contentView addSubview:self.menuLbl];
        [self.contentView addSubview:self.selectImgView];
    }
    return self;
}

- (UILabel *)menuLbl
{
    if (!_menuLbl) {
        _menuLbl = [[UILabel alloc] init];
        _menuLbl.backgroundColor = [UIColor clearColor];
        _menuLbl.textColor = [UIColor blackColor];
        _menuLbl.font = [UIFont systemFontOfSize:16.0f];
        _menuLbl.textAlignment = NSTextAlignmentCenter;
        _menuLbl.frame = self.contentView.bounds;
        _menuLbl.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _menuLbl;
}

- (UIImageView *)selectImgView
{
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 13)];
        _selectImgView.center = CGPointMake(self.contentView.frame.size.width / 4 * 3, self.contentView.frame.size.height / 2);
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

@interface SUIDropdownTitleView () <UITableViewDataSource, UITableViewDelegate, SUIBaseProtocol>

@property (nonatomic,assign) NSInteger currIndex;
@property (nonatomic,strong) NSArray *currTitles;

@property (nonatomic,strong) UIButton *currTitleBtn;
@property (nonatomic,strong) UITableView *menuTableView;
@property (nonatomic,strong) UIView *menuView;
@property (nonatomic,strong) UIScrollView *mainView;
@property (nonatomic,strong) UIButton *backgroundButton;

@property (nonatomic,assign) SUIDropdownTitleViewState currState;
@property (nonatomic,assign) CGFloat currNavBarHeight;

@end

@implementation SUIDropdownTitleView

- (void)awakeFromNib
{
    NSAssert(self.currVC, @"should link currVC");
    
    self.currVC.navigationItem.titleView = self.currTitleBtn;
    self.currIndex = 0;
    self.currState = SUIDropdownTitleViewStateDidClose;
    
    
    [SUITool delay:0.1 cb:^{
        UINavigationBar *curNavigationBar = self.currVC.navigationController.navigationBar;
        if (curNavigationBar.translucent)
        {
            self.currNavBarHeight = curNavigationBar.bounds.size.height;
            if (![UIApplication sharedApplication].statusBarHidden)
            {
                self.currNavBarHeight += [UIApplication sharedApplication].statusBarFrame.size.height;
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
    return self.currState == SUIDropdownTitleViewStateDidOpen;
}

- (void)show
{
    if (self.currState == SUIDropdownTitleViewStateDidClose)
    {
        self.currState = SUIDropdownTitleViewStateWillOpen;
        
        [self setupMenu];
        [self addMenuAnimation];
        
        uWeakSelf
        [SUITool delay:tAnimationDuration cb:^{
            weakSelf.currState = SUIDropdownTitleViewStateDidOpen;
        }];
    }
}

- (void)dismiss
{
    if (self.currState == SUIDropdownTitleViewStateDidOpen)
    {
        self.currState = SUIDropdownTitleViewStateWillClose;
        
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
                             weakSelf.currState = SUIDropdownTitleViewStateDidClose;
                         }];
    }
}


- (void)setupMenu
{
    self.mainView.frame = self.currVC.view.bounds;
    [self.currVC.view addSubview:self.mainView];
    
    self.backgroundButton.frame = CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height);
    self.backgroundButton.alpha = 1.0;
    [self.mainView addSubview:self.backgroundButton];
    
    self.menuView.frame = CGRectMake(0, -self.mainView.frame.size.height, self.mainView.frame.size.width, self.mainView.frame.size.height);
    [self.mainView addSubview:self.menuView];
    
    CGFloat menuHeight = self.currTitles.count * tMenuHeight;
    self.menuTableView.frame = CGRectMake(0, self.menuView.frame.size.height - menuHeight, kScreenWidth, menuHeight);
    [self.menuTableView reloadData];
    [self.menuView addSubview:self.menuTableView];
}


#pragma mark - Keyframe Animation

- (void)addMenuAnimation
{
    CGFloat curMenuViewY = - self.mainView.height;
    if (self.currState == SUIDropdownTitleViewStateWillOpen || self.currState == SUIDropdownTitleViewStateDidOpen)
    {
        curMenuViewY += (self.menuTableView.frame.size.height + self.currNavBarHeight);
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
                             CGRect curMenuRect = weakSelf.menuView.frame;
                             curMenuRect.origin.y = curMenuViewY;
                             weakSelf.menuView.frame = curMenuRect;
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
    
    curCell.menuLbl.text = self.currTitles[indexPath.row];
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
        
        if ([self.currVC respondsToSelector:@selector(suiDropdownTitleDidSelectAtIndex:)])
        {
            [(id<SUIBaseProtocol>)self.currVC suiDropdownTitleDidSelectAtIndex:indexPath.row];
        }
    }
    
    self.currIndex = indexPath.row;
}


#pragma mark -

- (void)setCurrIndex:(NSInteger)currIndex
{
    _currIndex = currIndex;
    
    if ([self.currVC respondsToSelector:@selector(suiDropdownTitleMenu)])
    {
        self.currTitles = [(id<SUIBaseProtocol>)self.currVC suiDropdownTitleMenu];
    }
    
    NSAssert(_currIndex < self.currTitles.count, @"currIndex MUST < suiDropdownTitleMenu().count");
    
    [self.currTitleBtn setNormalTitle:self.currTitles[currIndex]];
}

- (UIButton *)currTitleBtn
{
    if (!_currTitleBtn)
    {
        _currTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _currTitleBtn.backgroundColor = [UIColor clearColor];
        _currTitleBtn.frame = CGRectMake(0, 0, gAdapt(150), 44);
        UIColor *curTitleColo = self.titleColo ? self.titleColo : [UIColor blackColor];
        [_currTitleBtn setTitleColor:curTitleColo forState:UIControlStateNormal];
        [_currTitleBtn setBackgroundImage:[self imageIfCamvas] forState:UIControlStateNormal];
        [_currTitleBtn addTarget:self action:@selector(doTitleBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _currTitleBtn;
}


- (UIImage *)imageIfCamvas
{
    UIImage *curImage;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(150, 44), NO, 0.0f);
    [self drawCanvas];
    curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return curImage;
}

- (void)drawCanvas
{
    UIColor* color = [UIColor colorWithRed:0.04f green:0.83f blue:0.09f alpha:0.5f];
    UIColor* color2 = [UIColor colorWithRed:0.53f green:0.99f blue:0.44f alpha:0.5f];
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(79, 34)];
    [bezierPath addCurveToPoint: CGPointMake(71, 34) controlPoint1: CGPointMake(71, 34) controlPoint2: CGPointMake(71, 34)];
    [bezierPath addLineToPoint: CGPointMake(75, 39)];
    [bezierPath addLineToPoint: CGPointMake(79, 34)];
    [color setFill];
    [bezierPath fill];
    [color2 setStroke];
    bezierPath.lineWidth = 1.0;
    [bezierPath stroke];
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
        _menuView.backgroundColor = tBackgroundColor;
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
