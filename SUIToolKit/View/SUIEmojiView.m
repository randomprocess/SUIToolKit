//
//  SUIEmojiView.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/12.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIEmojiView.h"
#import "SUIToolKitConst.h"
#import "UIView+SUIExt.h"
#import "UIButton+SUIExt.h"
#import "UIScrollView+SUIExt.h"

typedef NS_ENUM(NSInteger, SUIEmojiViewState)
{
    SUIEmojiViewStateWillOpen   = 0,
    SUIEmojiViewStateDidOpen    = 1,
    SUIEmojiViewStateWillClose  = 2,
    SUIEmojiViewStateDidClose   = 3
};


#define tEmoji_Height 216.0f
#define tEmoji_Bottom_Height 40.0f


// _____________________________________________________________________________

@interface SUIEmojiSectionBtn : UIButton

@end

@implementation SUIEmojiSectionBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.normalBackgroundImage = [[self class] imageOfCanvasNormal];
        self.selectedBackgroundImage = [[self class] imageOfCanvasSelect];
    }
    return self;
}

+ (UIImage*)imageOfCanvasSelect;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(6, 10), NO, 0.0f);
    [self drawCanvasSelect];
    UIImage *curImg = [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets: UIEdgeInsetsMake(1, 1, 1, 1) resizingMode: UIImageResizingModeStretch];
    UIGraphicsEndImageContext();
    return curImg;
}

+ (UIImage*)imageOfCanvasNormal;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(6, 10), NO, 0.0f);
    [self drawCanvasNormal];
    UIImage *curImg = [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets: UIEdgeInsetsMake(1, 1, 1, 1) resizingMode: UIImageResizingModeStretch];
    UIGraphicsEndImageContext();
    return curImg;
}

+ (void)drawCanvasSelect
{
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 6, 10)];
    [UIColor.lightGrayColor setFill];
    [rectangle2Path fill];
}

+ (void)drawCanvasNormal
{
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(5.5, 0, 0.5, 10)];
    [UIColor.lightGrayColor setFill];
    [rectangle2Path fill];
}


@end


// _____________________________________________________________________________

@interface SUIEmojiFaceView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,assign) CGPoint currTouch;
@property (nonatomic,assign) BOOL isMoved;
@property (nonatomic,assign) BOOL isTouchEnded;
@property (nonatomic,assign) BOOL isInRect;

@property (nonatomic,weak) SUIEmojiItem *currItem;

@property (nonatomic,copy) SUIDelayTask loopDaley;
@property (nonatomic,strong) UIImageView *loopView;

@property (nonatomic,weak) UIScrollView *currSupScrollView;
@property (nonatomic,strong) UIImage *deleteImage;

@property (nonatomic,strong) SUIEmojiSection *currSection;
- (void)refreshWithSection:(SUIEmojiSection *)cSection;

@property (nonatomic,weak) id<SUIBaseProtocol> currVC;

@end

@implementation SUIEmojiFaceView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIPanGestureRecognizer *curPanGes = [[UIPanGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(paningGestureReceive:)];
    curPanGes.maximumNumberOfTouches = 1;
    curPanGes.delegate = self;
    [self addGestureRecognizer:curPanGes];
}


- (void)refreshWithSection:(SUIEmojiSection *)cSection
{
    self.currSection = cSection;
    self.frame = CGRectMake(0, 0, (self.currSupScrollView.width * self.currSection.numOfPages), self.currSupScrollView.height);
    
    /**
     *  调用setNeedsDisplay()后不执行drawRect()的原因
     *
     *  1. 当view的frame的size为（0,0）的时候，系统是不会执行drawRect()
     *  2. 当这个view没有superview的情况，依然不会执行drawRect()
     */
    [self setNeedsDisplay];
}


- (CGRect)itemRectAtCurPage:(NSInteger)cPage CurRow:(NSInteger)cRow curCol:(NSInteger)cCol
{
    CGRect curRect = (CGRect) {
        {cPage * self.currSupScrollView.width + self.currSection.padding.left + cRow * [self.currSection itemWidth],
            cCol * [self.currSection itemHeight]},
        {[self.currSection itemWidth], [self.currSection itemHeight]}
    };
    return curRect;
}

- (void)fitTextItem:(SUIEmojiItem *)cItem attributes:(NSDictionary *)cAttributes
{
    if (CGRectEqualToRect(cItem.realRect, CGRectZero))
    {
        CGRect curRect =
        [cItem.text boundingRectWithSize:CGSizeMake(cItem.touchRect.size.width, cItem.touchRect.size.height)
                                 options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:cAttributes
                                 context:nil];
        
        [self fitItem:cItem curSize:curRect.size];
    }
}

- (void)fitPngItem:(SUIEmojiItem *)cItem image:(UIImage *)cImage
{
    if (CGRectEqualToRect(cItem.realRect, CGRectZero))
    {
        CGFloat curWidth = MIN(cItem.touchRect.size.width/4*3, MAX(cItem.touchRect.size.width/2, cImage.size.width));
        CGFloat curHeight = MIN(cItem.touchRect.size.height/4*3, MAX(cItem.touchRect.size.height/2, cImage.size.height));
        CGSize curSize = CGSizeMake(curWidth, curHeight);
        
        [self fitItem:cItem curSize:curSize];
    }
}

- (void)fitItem:(SUIEmojiItem *)cItem curSize:(CGSize)cSize
{
    cItem.realRect = (CGRect) {
        {cItem.touchRect.origin.x+(cItem.touchRect.size.width-cSize.width)/2,
            cItem.touchRect.origin.y+(cItem.touchRect.size.height-cSize.height)/2
        },
        {cSize.width, cSize.height}
    };
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    for (NSInteger idx=0; idx<[self.currSection numOfTotalItems]; idx++)
    {
        NSInteger curPage = idx / [self.currSection numOfSinglePageItems];
        SUIEmojiItem *curItem = self.currSection.emojiItemAry[idx];
        
        if (self.currSection.hasDeleteItem && (idx == [self.currSection numOfTotalItems]-1 || (idx % [self.currSection numOfSinglePageItems]) == [self.currSection numOfSinglePageItems] - 1))
        {
            if (CGRectEqualToRect(curItem.touchRect, CGRectZero))
            {
                curItem.touchRect = [self itemRectAtCurPage:curPage CurRow:[self.currSection numOfRowRealItems]-1 curCol:[self.currSection numOfColRealItems]-1];
            }
            
            [self fitPngItem:curItem image:[self deleteImage]];
            [[self deleteImage] drawInRect:curItem.realRect];
        }
        else
        {
            if (CGRectEqualToRect(curItem.touchRect, CGRectZero))
            {
                NSInteger curRow = idx % [self.currSection numOfRowRealItems];
                NSInteger curCol = (idx - curPage * [self.currSection numOfSinglePageItems])  / [self.currSection numOfRowRealItems];
                curItem.touchRect = [self itemRectAtCurPage:curPage CurRow:curRow curCol:curCol];
            }
            
            switch (self.currSection.type) {
                    
                case SUIEmojiViewTypePng:
                {
                    UIImage *curImg = gImageResource(curItem.imageName, @"png");
                    [self fitPngItem:curItem image:curImg];
                    [curImg drawInRect:curItem.realRect];
                }
                    break;
                    
                case SUIEmojiViewTypeText:
                {
                    [self fitTextItem:curItem attributes:curItem.attributes];
                    [curItem.text drawInRect:curItem.realRect withAttributes:curItem.attributes];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *curTouch = [[event allTouches] anyObject];
    self.currTouch = [curTouch locationInView:curTouch.view];
    
    self.isMoved = NO;
    self.isInRect = NO;
    self.isTouchEnded = NO;
    self.currItem = nil;
    [SUITool cancelDelayTask:self.loopDaley];
    
    for (SUIEmojiItem *curItem in self.currSection.emojiItemAry)
    {
        if (CGRectContainsPoint(curItem.touchRect, self.currTouch))
        {
            self.currItem = curItem;
            self.isInRect = YES;
            break;
        }
    }
    
    if (self.isInRect)
    {
        if (!self.currItem.deleteItem)
        {
            uWeakSelf
            self.loopDaley = [SUITool delay:0.6 cb:^{
                if (!weakSelf.isMoved && !weakSelf.isTouchEnded)
                {
                    [weakSelf showLoopView];
                }
            }];
        }
    }
    else
    {
        self.isMoved = YES;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchEnded];
}

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    CGPoint curPoint = [recoginzer locationInView:self];
    
    switch (recoginzer.state) {
            
        case UIGestureRecognizerStateChanged:
        {
            self.currTouch = curPoint;
            CGPoint touchpoint = [recoginzer locationInView:self.currSupScrollView.superview];

            self.isInRect = CGRectContainsPoint(self.currItem.touchRect, touchpoint);
            if (!self.isInRect) {
                self.isMoved = YES;
            }
            
            [self moveLoopView];
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            [self touchEnded];
        }
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            self.currSupScrollView.scrollEnabled = YES;
            self.isMoved = YES;
            
            [self dismissLoopView];
        }
            break;
            
        default:
            break;
    }
}




- (void)touchEnded
{
    if (!self.isTouchEnded)
    {
        self.currSupScrollView.scrollEnabled = YES;
        self.isTouchEnded = YES;
        
        if (self.isInRect)
        {
            [self touchFaceExpression];
        }
        
        [self dismissLoopView];
    }
}

- (void)touchFaceExpression
{
    if (self.currItem) {
        if (self.currItem.deleteItem) {
            if ([self.currVC respondsToSelector:@selector(suiEmojiViewTapDeleteItem)]) {
                [self.currVC suiEmojiViewTapDeleteItem];
            }
        } else {
            if ([self.currVC respondsToSelector:@selector(suiEmojiViewTapItem:)]) {
                [self.currVC suiEmojiViewTapItem:self.currItem];
            }
        }
    }
}



- (void)showLoopView
{
    self.currSupScrollView.scrollEnabled = NO;
    
    
    // TODO: - show loopView
}

- (void)moveLoopView
{
    if (_loopView)
    {
        self.loopView.frame = (CGRect) {
            {self.currTouch.x - self.loopView.width/2, self.currTouch.y - self.loopView.height - 40},
            {self.loopView.width, self.loopView.height}
        };
    }
}

- (void)dismissLoopView
{
    UIImageView *weakLoopView = self.loopView;
    self.loopView = nil;
    [UIView animateWithDuration:0.3
                     animations:^{
                         weakLoopView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [weakLoopView removeFromSuperview];
                     }];
}

- (UIImageView *)loopView
{
    if (!_loopView) {
        _loopView = [[UIImageView alloc] init];
        [self addSubview:_loopView];
    }
    return _loopView;
}


- (void)setIsInRect:(BOOL)isInRect
{
    if (_isInRect == isInRect) {
        return;
    }
    
    _isInRect = isInRect;
    
    if (_isInRect) {
        [self.loopView setBorder:[UIColor colorWithRed:0.27f green:0.85f blue:0.46f alpha:1.0f] width:0.8];
    } else {
        [self.loopView setBorder:[UIColor colorWithRed:1.0f green:0.17f blue:0.34f alpha:1.0f] width:0.8];
    }
}


- (UIImage *)deleteImage
{
    if (!_deleteImage)
    {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(15, 11), NO, 0.0f);
        [[self class] drawCanvas1];
        UIImage *curImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _deleteImage = curImg;
    }
    return _deleteImage;
}

+ (void)drawCanvas1;
{
    //// Group 2
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(6.5, 0.5)];
        [bezierPath addLineToPoint: CGPointMake(0.5, 6.5)];
        [bezierPath addLineToPoint: CGPointMake(6.5, 10.5)];
        [bezierPath addLineToPoint: CGPointMake(14.5, 10.5)];
        [bezierPath addLineToPoint: CGPointMake(14.5, 0.5)];
        [bezierPath addLineToPoint: CGPointMake(6.5, 0.5)];
        [bezierPath closePath];
        [UIColor.blackColor setStroke];
        bezierPath.lineWidth = 1;
        [bezierPath stroke];
        
        
        //// Group
        {
            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
            [bezier2Path moveToPoint: CGPointMake(8.5, 3.5)];
            [bezier2Path addCurveToPoint: CGPointMake(11.5, 7.5) controlPoint1: CGPointMake(11.5, 7.5) controlPoint2: CGPointMake(11.5, 7.5)];
            [UIColor.blackColor setStroke];
            bezier2Path.lineWidth = 0.5;
            [bezier2Path stroke];
            
            
            //// Bezier 3 Drawing
            UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
            [bezier3Path moveToPoint: CGPointMake(11.5, 3.5)];
            [bezier3Path addLineToPoint: CGPointMake(8.5, 7.5)];
            [UIColor.blackColor setStroke];
            bezier3Path.lineWidth = 0.5;
            [bezier3Path stroke];
        }
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
    {
        return NO;
    }
    
    return YES;
}


@end



// _____________________________________________________________________________

@interface SUIEmojiView () <UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *currSectionAry;
@property (nonatomic,strong) NSMutableArray *currSectionBtnAry;

@property (nonatomic,strong) UIView *mainView;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) CALayer *bottomLayer;
@property (nonatomic,strong) UIScrollView *bottomScrollView;
@property (nonatomic,strong) UIButton *sendBtn;

@property (nonatomic,strong) UIPageControl *currPageControl;
@property (nonatomic,strong) UIScrollView *middleScrollView;
@property (nonatomic,strong) SUIEmojiFaceView *faceView;

@property (nonatomic,assign) NSInteger selectIndex;

@property (nonatomic,assign) SUIEmojiViewState currState;
@property (nonatomic,assign) CGFloat supHeight;

@end

@implementation SUIEmojiView


- (void)awakeFromNib
{
    NSAssert(self.currVC, @"should link currVC");
    
    self.currState = SUIEmojiViewStateDidClose;
    self.sectionPadding = 12.0;
    _currHeight = tEmoji_Height;
    
    [self createUI];
}

- (void)createUI
{
    CGFloat spareHeight = tEmoji_Height;
    
    if (!self.hidePrimaryEmoji)
    {
        SUIEmojiSection *primarySection = [SUIEmojiSection primaryEmojiSection];
        primarySection.numOfRowItems = 6;
        primarySection.numOfColItems = (self.showCustomEmoji) ? 3 : 4;
        [self.currSectionAry addObject:primarySection];
    }
    
    if (self.showCustomEmoji)
    {
        NSAssert([self.currVC respondsToSelector:@selector(suiEmojiViewSections)], @"should implement suiEmojiViewSections()");
    
        [self createBottomUI];
        spareHeight -= tEmoji_Bottom_Height;
    }
    
    [self createMiddleUI:spareHeight];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    SUIEmojiSection *curSection = self.currSectionAry[_selectIndex];
    NSInteger numOfPages = [curSection numOfPages];
    
    if (_currSectionBtnAry)
    {
        NSInteger counter = 0;
        for (SUIEmojiSectionBtn *curSectionBtn in _currSectionBtnAry) {
            if (counter == _selectIndex) {
                if (!curSectionBtn.selected) {
                    curSectionBtn.selected = YES;
                }
            } else {
                if (curSectionBtn.selected) {
                    curSectionBtn.selected = NO;
                }
            }
            counter ++;
        }
    }
    
    self.middleScrollView.contentSize = CGSizeMake(self.middleScrollView.width * numOfPages, self.middleScrollView.height);
    [self.faceView refreshWithSection:curSection];
    
    self.currPageControl.numberOfPages = numOfPages;
    self.currPageControl.currentPage = 0;
    [self.middleScrollView setContentOffset:CGPointZero animated:NO];
    
    if (curSection.hasSendBtn)
    {
        if (self.sendBtn.x != self.bottomView.width - self.sendBtn.width) {
            uWeakSelf
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.sendBtn.x = self.bottomView.width - self.sendBtn.width;
            }];
            
            self.bottomScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.sendBtn.width);
        }
    }
    else
    {
        if (self.sendBtn.x != self.bottomView.width) {
            uWeakSelf
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.sendBtn.x = self.bottomView.width;
            }];
        }
    }
}


#pragma mark Middle

- (void)createMiddleUI:(CGFloat)spareHeight
{
    [self.currPageControl sizeToFit];
    self.currPageControl.frame = CGRectMake(0, spareHeight-self.currPageControl.height-10, self.mainView.width, self.currPageControl.height);
    spareHeight = self.currPageControl.y - 10;
    
    self.middleScrollView.frame = CGRectMake(0, 0, self.mainView.width, spareHeight);
    
    self.selectIndex = 0;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger curIndex = fabs(scrollView.contentOffset.x) / scrollView.width;
    if (self.currPageControl.currentPage != curIndex) {
        self.currPageControl.currentPage = curIndex;
    }
}


#pragma mark Bottom

- (void)createBottomUI
{
    NSArray *curCoustomEmojiSections = [self.currVC suiEmojiViewSections];
    [self.currSectionAry addObjectsFromArray:curCoustomEmojiSections];

    uWeakSelf
    CGFloat sectionTotalWidth = 0;
    for (NSInteger idx=0; idx<self.currSectionAry.count; idx++)
    {
        SUIEmojiSectionBtn *curSectionBtn = [SUIEmojiSectionBtn new];
        
        SUIEmojiSection *curSection = self.currSectionAry[idx];
        curSection.currScrollView = self.middleScrollView;
        [curSection numOfPages];
        if (curSection.hasDeleteItem)
        {
            NSMutableArray *curItemAry = [NSMutableArray array];
            for (NSInteger idx=0; idx<curSection.emojiItemAry.count; idx++)
            {
                [curItemAry addObject:curSection.emojiItemAry[idx]];
                
                if (((idx % ([curSection numOfSinglePageItems]-1)) == [curSection numOfSinglePageItems]-2) ||
                    ((idx == curSection.emojiItemAry.count-1) && (curItemAry.count % [curSection numOfSinglePageItems] != 0))) {
                    SUIEmojiItem *deleItem = [SUIEmojiItem new];
                    deleItem.deleteItem = YES;
                    [curItemAry addObject:deleItem];
                }
            }
            curSection.emojiItemAry = curItemAry;
        }
        
        
        if (curSection.image) {
            curSectionBtn.normalImage = curSection.image;
        } else {
            curSectionBtn.normalTitle = curSection.title;
        }

        curSectionBtn.padding = self.sectionPadding;
        curSectionBtn.frame = CGRectMake(sectionTotalWidth, 0, curSectionBtn.width, self.bottomScrollView.height);
        [self.bottomScrollView addSubview:curSectionBtn];
        sectionTotalWidth += curSectionBtn.width;
        
        NSInteger curIdx = idx;
        curSectionBtn.clickBlock = ^() {
            if (weakSelf.selectIndex != curIdx) {
                weakSelf.selectIndex = curIdx;
            }
        };
        
        [self.currSectionBtnAry addObject:curSectionBtn];
    }
    
    [self.bottomScrollView fitContentSize];
}


#pragma mark - Show, Dismiss

- (void)show
{
    if (self.currState == SUIEmojiViewStateDidClose)
    {
        self.currState = SUIEmojiViewStateWillOpen;
        
        [self addEmojiAnimation];
        
        uWeakSelf
        [SUITool delay:[SUITool keyboardAnimationDuration] cb:^{
            weakSelf.currState = SUIEmojiViewStateDidOpen;
        }];
    }
}

- (void)dissmiss
{
    if (self.currState == SUIEmojiViewStateDidOpen)
    {
        self.currState = SUIEmojiViewStateWillClose;
        
        [self addEmojiAnimation];
        
        uWeakSelf
        [SUITool delay:[SUITool keyboardAnimationDuration] cb:^{
            weakSelf.currState = SUIEmojiViewStateDidClose;
        }];
    }
}

- (void)addEmojiAnimation
{
    CGFloat curEmojiViewY = self.supHeight;
    if (self.currState == SUIEmojiViewStateWillOpen || self.currState == SUIEmojiViewStateDidOpen)
    {
        curEmojiViewY -= self.mainView.height;
    }
    
    if (curEmojiViewY != self.mainView.y)
    {
        uWeakSelf
        [UIView animateWithDuration:[SUITool keyboardAnimationDuration]
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             weakSelf.mainView.y = curEmojiViewY;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}


#pragma mark -

- (NSMutableArray *)currSectionAry
{
    if (!_currSectionAry) {
        _currSectionAry = [NSMutableArray array];
    }
    return _currSectionAry;
}

- (NSMutableArray *)currSectionBtnAry
{
    if (!_currSectionBtnAry) {
        _currSectionBtnAry = [NSMutableArray array];
    }
    return _currSectionBtnAry;
}

- (UIView *)mainView
{
    if (!_mainView) {
        _mainView = [UIView new];
        _mainView.backgroundColor = [UIColor whiteColor];
        UIViewController *curVC = (UIViewController *)self.currVC;
        self.supHeight = curVC.view.height;
        _mainView.frame = CGRectMake(0, self.supHeight, kScreenWidth, tEmoji_Height);
        [curVC.view addSubview:_mainView];
    }
    return _mainView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.frame = CGRectMake(0, tEmoji_Height-tEmoji_Bottom_Height, self.mainView.width, tEmoji_Bottom_Height);
        [self.mainView addSubview:_bottomView];
        [self bottomLayer];
    }
    return _bottomView;
}

- (CALayer *)bottomLayer
{
    if (!_bottomLayer) {
        _bottomLayer = [CALayer new];
        _bottomLayer.frame = CGRectMake(0, 0, self.bottomView.width, 0.5);
        _bottomLayer.backgroundColor = [[UIColor lightGrayColor] CGColor];
        [self.bottomView.layer addSublayer:_bottomLayer];
    }
    return _bottomLayer;
}

- (UIScrollView *)bottomScrollView
{
    if (!_bottomScrollView) {
        _bottomScrollView = [UIScrollView new];
        _bottomScrollView.frame = CGRectMake(0, 0, self.bottomView.width, self.bottomView.height);
        _bottomScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.bottomView addSubview:_bottomScrollView];
    }
    return _bottomScrollView;
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton customBtn];
        NSString *curLanguage = kLanguage;
        if ([curLanguage isEqualToString:@"zh-Hans"]) {
            _sendBtn.normalTitle = @"发送";
        } else if ([curLanguage isEqualToString:@"zh-Hant"]) {
            _sendBtn.normalTitle = @"發送";
        } else {
            _sendBtn.normalTitle = @"Send";
        }
        _sendBtn.backgroundColor = gRGB(39, 105, 176);
        _sendBtn.normalTitleColo = [UIColor whiteColor];
        _sendBtn.padding = 16.0f;
        _sendBtn.frame = CGRectMake(self.bottomView.width, 0, _sendBtn.width, self.bottomView.height);
        
        uWeakSelf
        _sendBtn.clickBlock = ^() {
            if ([weakSelf.currVC respondsToSelector:@selector(suiEmojiViewTapSendBtn)]) {
                [weakSelf.currVC suiEmojiViewTapSendBtn];
            }
        };
        
        [self.bottomView addSubview:_sendBtn];
    }
    return _sendBtn;
}

- (UIPageControl *)currPageControl
{
    if (!_currPageControl) {
        _currPageControl = [[UIPageControl alloc] init];
        _currPageControl.hidesForSinglePage = YES;
        _currPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _currPageControl.currentPageIndicatorTintColor = gRGB(39, 105, 176);
        [self.mainView addSubview:_currPageControl];
    }
    return _currPageControl;
}

- (UIScrollView *)middleScrollView
{
    if (!_middleScrollView) {
        _middleScrollView = [UIScrollView new];
        _middleScrollView.frame = CGRectMake(0, 0, self.mainView.width, 0);
        _middleScrollView.pagingEnabled = YES;
        _middleScrollView.showsHorizontalScrollIndicator = NO;
        _middleScrollView.showsVerticalScrollIndicator = NO;
        _middleScrollView.alwaysBounceHorizontal = YES;
        _middleScrollView.delegate = self;
        _middleScrollView.userInteractionEnabled = YES;
        _middleScrollView.backgroundColor = self.mainView.backgroundColor;
        _middleScrollView.clipsToBounds = NO;
        _middleScrollView.canCancelContentTouches = NO;
        _middleScrollView.delaysContentTouches = YES;
        [self.mainView addSubview:_middleScrollView];
    }
    return _middleScrollView;
}

- (SUIEmojiFaceView *)faceView
{
    if (!_faceView) {
        _faceView = [[SUIEmojiFaceView alloc] init];
        _faceView.backgroundColor = [UIColor clearColor];
        _faceView.currSupScrollView = self.middleScrollView;
        _faceView.currVC = self.currVC;
        [self.middleScrollView addSubview:_faceView];
    }
    return _faceView;
}

- (void)setDeleteImage:(UIImage *)deleteImage
{
    _deleteImage = deleteImage;
    self.faceView.deleteImage = _deleteImage;
}


@end


@interface SUIEmojiItem ()

@property (nonatomic,strong) SUIEmojiSection* currSection;

@end

@implementation SUIEmojiItem

- (SUIEmojiSection *)section
{
    return self.currSection;
}

- (NSDictionary *)attributes
{
    if (_attributes == nil) {
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        _attributes = @{NSFontAttributeName : gFont(18),
                        NSForegroundColorAttributeName : [UIColor blackColor],
                        NSParagraphStyleAttributeName : paragraph
                        };
    }
    return _attributes;
}

@end


// _____________________________________________________________________________

@interface SUIEmojiSection ()

@property (nonatomic,assign) NSInteger numOfSinglePageItems;
@property (nonatomic,assign) NSInteger numOfEmojiPageItems;
@property (nonatomic,assign) NSInteger numOfPages;

@property (nonatomic,assign) NSInteger numOfRowRealItems;
@property (nonatomic,assign) NSInteger numOfColRealItems;

@property (nonatomic,assign) CGFloat itemWidth;
@property (nonatomic,assign) CGFloat itemHeight;
@property (nonatomic,assign) CGRect itemRect;

@end

@implementation SUIEmojiSection

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.hasDeleteItem = YES;
        self.hasSendBtn = YES;
    }
    return self;
}

+ (SUIEmojiSection *)primaryEmojiSection
{
    SUIEmojiSection *curSection = [SUIEmojiSection new];
    curSection.type = SUIEmojiViewTypeText;
    curSection.title = @"😄";
    NSArray *curItemAry = @[@"😄", @"😃", @"😀", @"😊", @"☺️", @"😉", @"😍", @"😘", @"😚", @"😗", @"😙", @"😜", @"😝", @"😛", @"😳", @"😁", @"😔", @"😌", @"😒", @"😞", @"😣", @"😢", @"😂", @"😭", @"😪", @"😥", @"😰", @"😅", @"😓", @"😩", @"😫", @"😨", @"😱", @"😠", @"😡", @"😤", @"😖", @"😆", @"😋", @"😷", @"😎", @"😴", @"😵", @"😲", @"😟", @"😦", @"😧", @"😈", @"👿", @"😮", @"😬", @"😐", @"😕", @"😯", @"😶", @"😇", @"😏", @"😑", @"😺", @"😸", @"😻", @"😽", @"😼", @"🙀", @"😿", @"😹", @"😾", @"👹", @"👺", @"🙈", @"🙉", @"🙊", @"💀", @"👽", @"💩", @"👍", @"👎", @"👌",];
    
    NSMutableArray *curSectionAry = [NSMutableArray array];
    for (NSString *curEmoji in curItemAry) {
        SUIEmojiItem *curItem =[SUIEmojiItem new];
        curItem.text = curEmoji;
        curItem.remark = curEmoji;
        curItem.currSection = curSection;
        [curSectionAry addObject:curItem];
    }
    
    curSection.emojiItemAry = curSectionAry;
    return curSection;
}

- (NSInteger)numOfSinglePageItems
{
    if (_numOfSinglePageItems == 0)
    {
        _numOfSinglePageItems = self.numOfRowRealItems * self.numOfColRealItems;
    }
    return _numOfSinglePageItems;
}

- (NSInteger)numOfTotalItems
{
    return self.emojiItemAry.count;
}

- (NSInteger)numOfEmojiPageItems
{
    return (self.hasDeleteItem) ? [self numOfSinglePageItems]-1 : [self numOfSinglePageItems];
}

- (NSInteger)numOfPages
{
    if (_numOfPages == 0)
    {
        NSInteger curPage = 1;
        NSInteger curNumOfItems = self.emojiItemAry.count;
        NSInteger curNumOfPageItems = [self numOfEmojiPageItems];
        while (1)
        {
            if (curNumOfItems <= curNumOfPageItems) {
                break;
            }
            
            curNumOfItems -= curNumOfPageItems;
            curPage ++;
        }
        _numOfPages = curPage;
    }
    return _numOfPages;
}

- (NSInteger)numOfRowRealItems
{
    if (_numOfRowRealItems == 0)
    {
        CGFloat realWidth = self.currScrollView.width - self.padding.left - self.padding.right;
        if (self.currScrollView.width != 320)
        {
            CGFloat referWidth = 320.0 - self.padding.left - self.padding.right;
            CGFloat itemWidth = referWidth / self.numOfRowItems;
            
            _numOfRowRealItems = floor(realWidth / itemWidth);
        }
        else
        {
            _numOfRowRealItems = self.numOfRowItems;
        }
        self.itemWidth = realWidth / _numOfRowRealItems;
    }
    return _numOfRowRealItems;
}

- (NSInteger)numOfColRealItems
{
    return self.numOfColItems;
}

- (CGFloat)itemHeight
{
    if (_itemHeight == 0)
    {
        _itemHeight = (self.currScrollView.height - self.padding.top - self.padding.bottom) / self.numOfColRealItems;
    }
    return _itemHeight;
}

@end
