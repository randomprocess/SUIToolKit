//
//  SUIEmoticon.m
//  SUIToolKitDemo
//
//  Created by zzZ on 16/1/5.
//  Copyright © 2016年 SUIO~. All rights reserved.
//

#import "SUIEmoticon.h"
#import "SUIUtilities.h"
#import "SUICategories.h"
#import "ReactiveCocoa.h"
#import "UIImage+SUIGIF.h"


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIEmoticonSection
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@interface SUIEmoticonSection ()

@property (nonatomic) NSInteger numOfRowRealItems;
@property (nonatomic) NSInteger numOfSinglePageItems;
@property (nonatomic) NSInteger numOfPages;
@property (nonatomic,strong) NSMutableArray<SUIEmoticonItem *> *emoticonItems;

@end

@implementation SUIEmoticonSection

+ (NSDictionary *)primarySectionDict
{
    return @{
             @"Config" : @{@"sectionTitle" : @"😄",
                           @"numOfRowItems" : @(6),
                           @"numOfColItems" : @(4),
                           @"hasDeleteItem" : @(YES),
                           @"hasSendBtn" : @(YES)
                           },
             @"Items" : @[@{@"text" : @"😄"},@{@"text" : @"😃"},@{@"text" : @"😀"},@{@"text" : @"😊"},@{@"text" : @"☺️"},@{@"text" : @"😉"},@{@"text" : @"😍"},@{@"text" : @"😘"},@{@"text" : @"😚"},@{@"text" : @"😗"},@{@"text" : @"😙"},@{@"text" : @"😜"},@{@"text" : @"😝"},@{@"text" : @"😛"},@{@"text" : @"😳"},@{@"text" : @"😁"},@{@"text" : @"😔"},@{@"text" : @"😌"},@{@"text" : @"😒"},@{@"text" : @"😞"},@{@"text" : @"😣"},@{@"text" : @"😢"},@{@"text" : @"😂"},@{@"text" : @"😭"},@{@"text" : @"😪"},@{@"text" : @"😥"},@{@"text" : @"😰"},@{@"text" : @"😅"},@{@"text" : @"😓"},@{@"text" : @"😩"},@{@"text" : @"😫"},@{@"text" : @"😨"},@{@"text" : @"😱"},@{@"text" : @"😠"},@{@"text" : @"😡"},@{@"text" : @"😤"},@{@"text" : @"😖"},@{@"text" : @"😆"},@{@"text" : @"😋"},@{@"text" : @"😷"},@{@"text" : @"😎"},@{@"text" : @"😴"},@{@"text" : @"😵"},@{@"text" : @"😲"},@{@"text" : @"😟"},@{@"text" : @"😦"},@{@"text" : @"😧"},@{@"text" : @"😈"},@{@"text" : @"👿"},@{@"text" : @"😮"},@{@"text" : @"😬"},@{@"text" : @"😐"},@{@"text" : @"😕"},@{@"text" : @"😯"},@{@"text" : @"😶"},@{@"text" : @"😇"},@{@"text" : @"😏"},@{@"text" : @"😑"},@{@"text" : @"😺"},@{@"text" : @"😸"},@{@"text" : @"😻"},@{@"text" : @"😽"},@{@"text" : @"😼"},@{@"text" : @"🙀"},@{@"text" : @"😿"},@{@"text" : @"😹"},@{@"text" : @"😾"},@{@"text" : @"👹"},@{@"text" : @"👺"},@{@"text" : @"🙈"},@{@"text" : @"🙉"},@{@"text" : @"🙊"},@{@"text" : @"💀"},@{@"text" : @"👽"},@{@"text" : @"💩"},@{@"text" : @"👍"},@{@"text" : @"👎"},@{@"text" : @"👌"}
                 ]
             };
}

- (NSInteger)numOfRowRealItems
{
    if (_numOfRowRealItems) return _numOfRowRealItems;
    
    if (kScreenWidth == 320) {
        _numOfRowRealItems = self.numOfRowItems;
    } else {
        _numOfRowRealItems = floor( kScreenWidth / (320.0/self.numOfRowItems) );
    }
    return _numOfRowRealItems;
}

- (NSInteger)numOfSinglePageItems
{
    if (_numOfSinglePageItems) return _numOfSinglePageItems;

    _numOfSinglePageItems = self.numOfColItems * self.numOfRowRealItems;
    return _numOfSinglePageItems;
}

- (NSInteger)numOfPages
{
    if (_numOfPages) return _numOfPages;

    _numOfPages = ceil( self.emoticonItems.count / (double)[self numOfSinglePageItems] );
    return _numOfPages;
}

- (NSMutableArray<SUIEmoticonItem *> *)emoticonItems
{
    if (!_emoticonItems) {
        _emoticonItems = [NSMutableArray new];
    }
    return _emoticonItems;
}

@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIEmoticonItem
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@interface SUIEmoticonItem ()

@property (nonatomic) CGRect touchRect;
@property (nonatomic) CGRect realRect;

@end

@implementation SUIEmoticonItem

+ (instancetype)deleteItem
{
    SUIEmoticonItem *deleteItem = [SUIEmoticonItem new];
    deleteItem.type = SUIEmoticonItemTypeDelete;
    return deleteItem;
}

+ (NSDictionary *)attributes
{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary * attributes = @{NSFontAttributeName : gFont(18),
                                  NSForegroundColorAttributeName : [UIColor blackColor],
                                  NSParagraphStyleAttributeName : paragraph
                                  };
    return attributes;
}

@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIEmoticonItemView
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@interface SUIEmoticonItemView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic) CGPoint currTouch;
@property (nonatomic) BOOL isMoved;
@property (nonatomic) BOOL isTouchEnded;
@property (nonatomic) BOOL isInRect;

@property (nonatomic,weak) SUIEmoticon *currEmoticon;
@property (nonatomic,weak) UIScrollView *itemScrollView;
@property (nonatomic,weak) SUIEmoticonSection *currSection;

@property (nonatomic,weak) SUIEmoticonItem *currItem;

@property (nonatomic,strong) UIImageView *loopView;

@property (nonatomic,copy) SUIEmoticonDidClickItemBlock didClickItemBlock;

@end

@implementation SUIEmoticonItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self commonInit];
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

- (void)setCurrSection:(SUIEmoticonSection *)currSection
{
    _currSection = currSection;
    self.frame = CGRectMake(0, 0, kScreenWidth * [currSection numOfPages], self.itemScrollView.sui_height);
    
    /**
     *  The reason is not executed drawRect () after calling setNeedsDisplay ()
     *
     *  1. size of view.frame is (0,0)
     *  2. view.superview is nil
     */
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.currSection.emoticonItems enumerateObjectsUsingBlock:^(SUIEmoticonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (CGRectEqualToRect(obj.touchRect, CGRectZero))
        {
            CGFloat itemWidth = kScreenWidth / [self.currSection numOfRowRealItems];
            CGFloat itemHeight = (self.itemScrollView.sui_height - 10.0) / [self.currSection numOfColItems];
            
            NSInteger curPage = idx / [self.currSection numOfSinglePageItems];

            NSInteger curRow = 0;
            NSInteger curCol = 0;
            
            if (idx == self.currSection.emoticonItems.count-1 && obj.type == SUIEmoticonItemTypeDelete) {
                curRow = [self.currSection numOfRowRealItems]-1;
                curCol = [self.currSection numOfColItems]-1;
            } else {
                curRow = idx % [self.currSection numOfRowRealItems];
                curCol = (idx - curPage * [self.currSection numOfSinglePageItems]) / [self.currSection numOfRowRealItems];
            }
            
            obj.touchRect = (CGRect) {
                {curPage * kScreenWidth + curRow * itemWidth, curCol * itemHeight},
                {itemWidth, itemHeight}
            };
        }
        
        switch (obj.type) {
            case SUIEmoticonItemTypePng:
            case SUIEmoticonItemTypeGifAndPng:
            {
                UIImage *curImage = gImageResource(obj.png, @"png");
                [self fitPngItem:obj image:curImage];
                [curImage drawInRect:obj.realRect];
            }
                break;
            case SUIEmoticonItemTypeGif:
            {
                UIImage *curImage = gImageResource(obj.gif, @"gif");
                [self fitPngItem:obj image:curImage];
                [curImage drawInRect:obj.realRect];
            }
                break;
            case SUIEmoticonItemTypeText:
            {
                [self fitTextItem:obj attributes:[SUIEmoticonItem attributes]];
                [obj.text drawInRect:obj.realRect withAttributes:[SUIEmoticonItem attributes]];
            }
                break;
            case SUIEmoticonItemTypeDelete:
            {
                UIImage *deleteImage = self.currEmoticon.deleteImage;
                [self fitPngItem:obj image:deleteImage];
                [deleteImage drawInRect:obj.realRect];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)fitPngItem:(SUIEmoticonItem *)cItem image:(UIImage *)cImage
{
    if (CGRectEqualToRect(cItem.realRect, CGRectZero))
    {
        CGFloat curWidth = MIN(cItem.touchRect.size.width/4*3, MAX(cItem.touchRect.size.width/2, cImage.size.width));
        CGFloat curHeight = MIN(cItem.touchRect.size.height/4*3, MAX(cItem.touchRect.size.height/2, cImage.size.height));
        CGSize curSize = CGSizeMake(curWidth, curHeight);
        [self fitItem:cItem curSize:curSize];
    }
}

- (void)fitItem:(SUIEmoticonItem *)cItem curSize:(CGSize)cSize
{
    cItem.realRect = (CGRect) {
        {cItem.touchRect.origin.x+(cItem.touchRect.size.width-cSize.width)/2,
            cItem.touchRect.origin.y+(cItem.touchRect.size.height-cSize.height)/2
        },
        {cSize.width, cSize.height}
    };
}

- (void)fitTextItem:(SUIEmoticonItem *)cItem attributes:(NSDictionary *)cAttributes
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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *curTouch = [[event allTouches] anyObject];
    self.currTouch = [curTouch locationInView:curTouch.view];
    
    self.isMoved = NO;
    self.isInRect = NO;
    self.isTouchEnded = NO;
    self.currItem = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self.currSection.emoticonItems enumerateObjectsUsingBlock:^(SUIEmoticonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.touchRect, self.currTouch))
        {
            self.currItem = obj;
            self.isInRect = YES;
            *stop = YES;
        }
    }];
    
    if (self.isInRect) {
        if (self.currItem.type == SUIEmoticonItemTypeGif || self.currItem.type == SUIEmoticonItemTypeGifAndPng) {
            [self performSelector:@selector(checkForShowLoopView) withObject:nil afterDelay:0.3];
        }
    } else {
        self.isMoved = YES;
    }
}

- (void)checkForShowLoopView
{
    if (!self.isMoved && !self.isTouchEnded) {
        [self showLoopView];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchEnded];
}

#define tLoopView_Margin                  6.0f
#define tLoopView_SpaceToTouch            46.0f

#define tLoopView_MinImage_Width          24.0f
#define tLoopView_MinImage_Height         24.0f

- (void)showLoopView
{
    self.itemScrollView.scrollEnabled = NO;
    
    NSData *curGifData = [NSData dataWithContentsOfFile:[self.currItem.gif sui_resourcePathForMainBundleOfType:@"gif"]];
    UIImage *gifImage = [UIImage sui_animatedGIFWithData:curGifData];
    
    CGFloat loopWidth = gifImage.size.width;
    CGFloat loopHeight = gifImage.size.height;
    
    if (loopWidth < tLoopView_MinImage_Width)
    {
        loopHeight = loopHeight * tLoopView_MinImage_Width / loopWidth;
        loopWidth = tLoopView_MinImage_Width;
    }
    if (loopHeight < tLoopView_MinImage_Height)
    {
        loopWidth = loopWidth * tLoopView_MinImage_Height / loopHeight;
        loopHeight = tLoopView_MinImage_Height;
    }
    if (gifImage.size.width != loopWidth)
    {
        gifImage = [gifImage sui_animatedImageByScalingAndCroppingToSize:CGSizeMake(loopWidth, loopHeight)];
    }
    
    self.loopView.frame = (CGRect) {
        self.currTouch.x - loopWidth/2 - tLoopView_Margin,
        self.currTouch.y - loopHeight - tLoopView_Margin * 2 - tLoopView_SpaceToTouch,
        loopWidth + tLoopView_Margin * 2,
        loopHeight + tLoopView_Margin * 2
    };
    
    self.loopView.image = gifImage;
    
    self.loopView.transform = CGAffineTransformMakeScale(0.007, 0.007);
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:15
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.loopView.alpha = 1.0;
                         self.loopView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     } completion:^(BOOL finished) {
                         
                     }];
}


- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    CGPoint curPoint = [recoginzer locationInView:self];
    switch (recoginzer.state) {
        case UIGestureRecognizerStateChanged:
        {
            self.currTouch = curPoint;
            CGPoint touchpoint = [recoginzer locationInView:self.itemScrollView.superview];
            
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
            self.itemScrollView.scrollEnabled = YES;
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
        self.itemScrollView.scrollEnabled = YES;
        self.isTouchEnded = YES;
        
        if (self.isInRect) {
            [self touchFaceExpression];
        }
        
        [self dismissLoopView];
    }
}

- (void)touchFaceExpression
{
    if (self.didClickItemBlock) {
        self.didClickItemBlock(self.currSection, self.currItem);
    }
}

- (void)moveLoopView
{
    if (_loopView) {
        self.loopView.frame = (CGRect) {
            {self.currTouch.x - self.loopView.sui_width/2, self.currTouch.y - self.loopView.sui_height - 40},
            {self.loopView.sui_width, self.loopView.sui_height}
        };
    }
}

- (void)dismissLoopView
{
    UIImageView *loopView = self.loopView;
    self.loopView = nil;
    [UIView animateWithDuration:0.3
                     animations:^{
                         loopView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [loopView removeFromSuperview];
                     }];
}

- (UIImageView *)loopView
{
    if (!_loopView) {
        _loopView = [[UIImageView alloc] init];
        _loopView.backgroundColor = gRGBA(255, 255, 255, 0.8);
        _loopView.sui_shadowOpacity = 0.6;
        _loopView.sui_shadowOffset = CGSizeMake(0, 0);
        _loopView.sui_shadowRadius = 3;
        _loopView.sui_cornerRadius = 2;
        _loopView.sui_borderColor = gHex(@"45D975");
        _loopView.sui_borderWidth = 1;
        _loopView.contentMode = UIViewContentModeCenter;
        [self addSubview:_loopView];
    }
    return _loopView;
}

- (void)setIsInRect:(BOOL)isInRect
{
    if (_isInRect == isInRect) return;
    
    _isInRect = isInRect;
    
    if (_isInRect) {
        self.loopView.sui_borderColor = gHex(@"45D975");
    } else {
        self.loopView.sui_borderColor = gHex(@"FF2B57");
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIEmoticonSectionBtn
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@interface SUIEmoticonSectionBtn : UIButton

@end

@implementation SUIEmoticonSectionBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.sui_normalBackgroundImage = [[self class] imageOfCanvasNormal];
        self.sui_selectedBackgroundImage = [[self class] imageOfCanvasSelect];
        self.sui_normalTitleColo = [UIColor lightGrayColor];
        self.sui_selectedTitleColo = [UIColor whiteColor];
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


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIEmoticon
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@interface SUIEmoticon () <UIScrollViewDelegate>

@property (nonatomic,readwrite,strong) UIView *inputView;
@property (nonatomic,readwrite,strong) UIView *inputAccessoryView;

@property (nonatomic,copy) SUIEmoticonDidClickSendBtnBlock didClickSendBtnBlock;

@property (nonatomic,strong) UIScrollView *sectionScrollView;
@property (nonatomic,strong) NSMutableArray<SUIEmoticonSectionBtn *> *sectionBtns;
@property (nonatomic) NSInteger sectionIndex;

@property (nonatomic,strong) UIScrollView *itemScrollView;
@property (nonatomic,strong) UIPageControl *currPageControl;
@property (nonatomic,strong) SUIEmoticonItemView * emoticonItemView;

@property (nonatomic,strong) UIButton *currSendBtn;
@property (nonatomic) BOOL showSendBtn;


@property (nonatomic) BOOL primary;
@property (nonatomic,strong) NSMutableArray<SUIEmoticonSection *> *emoticonSections;

@end

@implementation SUIEmoticon


+ (instancetype)emoticonWithPlistArray:(nullable NSArray<NSString *> *)cArray controller:(UIViewController *)controller primary:(BOOL)primary
{
    return [[self alloc] initWithPlistArray:cArray controller:controller primary:primary];
}

- (instancetype)initWithPlistArray:(NSArray<NSString *> *)cArray controller:(UIViewController *)controller primary:(BOOL)primary
{
    self = [super init];
    if (self) {
        [controller.view addSubview:self];
        [self commonInitWithPlistArray:cArray primary:primary];
    }
    return self;
}

- (void)commonInitWithPlistArray:(NSArray<NSString *> *)cArray primary:(BOOL)primary
{
    self.primary = primary;
    
    if (cArray.count > 0) {
        [cArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *curPlistPath = [obj sui_resourcePathForMainBundleOfType:@"plist"];
            NSDictionary *curPlistDict = [[NSDictionary alloc] initWithContentsOfFile:curPlistPath];
            uAssert(curPlistDict, @"It may be a wrong plist name ⤭ %@ ⤪", obj);
            [self parserPlistDict:curPlistDict];
        }];
    }
    
    [self createUI];
    [self observeSectionIndex];
}

- (void)didClickSendBtn:(SUIEmoticonDidClickSendBtnBlock)cb
{
    self.didClickSendBtnBlock = cb;
}
- (void)didClickItem:(SUIEmoticonDidClickItemBlock)cb
{
    self.emoticonItemView.didClickItemBlock = cb;
}

- (void)parserPlistDict:(NSDictionary *)cDict
{
    NSDictionary *configDict = cDict[@"Config"];
    SUIEmoticonSection *curEmoticonSection = [self parserEmoticonSectionWithConfigDict:configDict];
    [self.emoticonSections addObject:curEmoticonSection];
    
    NSArray<NSDictionary *> *items = cDict[@"Items"];
    [items enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SUIEmoticonItem *curEmoticonItem = [self parserEmoticonItemWithItemDict:obj];
        [curEmoticonSection.emoticonItems addObject:curEmoticonItem];

        if (curEmoticonSection.hasDeleteItem) {
            if ((idx % ([curEmoticonSection numOfSinglePageItems]-1)) == ([curEmoticonSection numOfSinglePageItems]-2)) {
                [curEmoticonSection.emoticonItems addObject:[SUIEmoticonItem deleteItem]];
            } else if (idx == items.count-1) {
                [curEmoticonSection.emoticonItems addObject:[SUIEmoticonItem deleteItem]];
            }
        }
    }];
}

- (SUIEmoticonSection *)parserEmoticonSectionWithConfigDict:(NSDictionary *)cDict
{
    SUIEmoticonSection *curEmoticonSection = [SUIEmoticonSection new];
    curEmoticonSection.numOfRowItems = [cDict[@"numOfRowItems"] integerValue];
    curEmoticonSection.numOfColItems = [cDict[@"numOfColItems"] integerValue];
    curEmoticonSection.title = cDict[@"sectionTitle"];
    curEmoticonSection.image = cDict[@"sectionImage"];
    curEmoticonSection.hasDeleteItem = [cDict[@"hasDeleteItem"] boolValue];
    curEmoticonSection.hasSendBtn = [cDict[@"hasDeleteItem"] boolValue];
    return curEmoticonSection;
}

- (SUIEmoticonItem *)parserEmoticonItemWithItemDict:(NSDictionary *)cDict
{
    SUIEmoticonItem *curEmoticonItem = [SUIEmoticonItem new];
    NSString *curPng = cDict[@"png"];
    if (curPng.sui_isNotEmpty) {
        curEmoticonItem.type = SUIEmoticonItemTypePng;
        curEmoticonItem.png = curPng;
    }
    NSString *curGif = cDict[@"gif"];
    if (curGif.sui_isNotEmpty) {
        if (curEmoticonItem.type == SUIEmoticonItemTypePng) {
            curEmoticonItem.type = SUIEmoticonItemTypeGifAndPng;
        } else {
            curEmoticonItem.type = SUIEmoticonItemTypeGif;
        }
        curEmoticonItem.gif = curGif;
    }
    if (curEmoticonItem.type == 0) {
        NSString *curText = cDict[@"text"];
        if (curText.sui_isNotEmpty) {
            curEmoticonItem.type = SUIEmoticonItemTypeText;
            curEmoticonItem.text = curText;
        }
    }
    uAssert(curEmoticonItem.type > 0, @"unknown emoticon item type ItemDict ⤭ %@ ⤪", cDict);
    curEmoticonItem.remark = cDict[@"remark"];
    return curEmoticonItem;
}

- (void)createUI
{
    if (self.emoticonSections.count == 0) return;
    if (![self hasOnlyPrimarySection]) {
        [self createSectionUI];
    }
    [self createItemUI];
}

- (void)createSectionUI
{
    __block CGFloat curOffsetX = 0;
    [self.emoticonSections enumerateObjectsUsingBlock:^(SUIEmoticonSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SUIEmoticonSectionBtn *curSectionBtn = [SUIEmoticonSectionBtn new];
        if (obj.image.sui_isNotEmpty) {
            curSectionBtn.sui_normalImage = gImageNamed(obj.image);
        } else if (obj.title.sui_isNotEmpty) {
            curSectionBtn.sui_normalTitle = obj.title;
        }
        curSectionBtn.sui_padding = 12.0;
        curSectionBtn.frame = CGRectMake(curOffsetX, 0, curSectionBtn.sui_width, [self sectionHeight]);
        [self.sectionScrollView addSubview:curSectionBtn];
        curOffsetX += curSectionBtn.sui_width;
        
        @weakify(self)
        [curSectionBtn.sui_signalForClick subscribeNext:^(id x) {
            @strongify(self)
            self.sectionIndex = idx;
        }];
        [self.sectionBtns addObject:curSectionBtn];
    }];
    self.sectionScrollView.contentSize = CGSizeMake(curOffsetX, [self sectionHeight]);
}

- (void)createItemUI
{
    CGFloat itemScrollViewHeight = [self hasOnlyPrimarySection] ? [self inputViewHeight] : ([self inputViewHeight] - [self sectionHeight]);
    self.itemScrollView.frame = CGRectMake(0, 0, kScreenWidth, itemScrollViewHeight);

    [self.currPageControl sizeToFit];
    self.currPageControl.frame = CGRectMake(0, itemScrollViewHeight-self.currPageControl.sui_height-10, kScreenWidth, self.currPageControl.sui_height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger curIndex = fabs(scrollView.contentOffset.x) / scrollView.sui_width;
    if (self.currPageControl.currentPage != curIndex) {
        self.currPageControl.currentPage = curIndex;
    }
}

- (void)observeSectionIndex
{
    @weakify(self)
    [RACObserve(self, sectionIndex) subscribeNext:^(id x) {
        @strongify(self)
        if (self.emoticonSections.count == 0) return;
        [self.sectionBtns enumerateObjectsUsingBlock:^(SUIEmoticonSectionBtn * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.sui_selected = (idx == self.sectionIndex);
        }];
        
        SUIEmoticonSection *curEmoticonSection = self.emoticonSections[self.sectionIndex];
        self.itemScrollView.contentSize = CGSizeMake(self.itemScrollView.sui_width * [curEmoticonSection numOfPages], self.itemScrollView.sui_height);
        [self.itemScrollView setContentOffset:CGPointZero animated:NO];
        
        self.currPageControl.numberOfPages = [curEmoticonSection numOfPages];
        self.currPageControl.currentPage = 0;
        
        if (![self hasOnlyPrimarySection]) {
            self.showSendBtn = curEmoticonSection.hasSendBtn;
        }
        self.emoticonItemView.currSection = curEmoticonSection;
    }];
    
    [[RACObserve(self, showSendBtn) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self)
        
        if (self.showSendBtn) {
            if (self.currSendBtn.sui_x != kScreenWidth - self.currSendBtn.sui_width) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.currSendBtn.sui_x = kScreenWidth - self.currSendBtn.sui_width;
                }];
                self.sectionScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.currSendBtn.sui_width);
            }
        } else {
            if (self.currSendBtn.sui_x != kScreenWidth) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.currSendBtn.sui_x = kScreenWidth;
                }];
                self.sectionScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
        }
    }];
}


- (BOOL)hasOnlyPrimarySection
{
    if (self.emoticonSections.count == 1 && self.primary) {
        return YES;
    }
    return NO;
}

- (UIView *)inputView
{
    if (!_inputView) {
        _inputView = [UIView new];
        _inputView.frame = CGRectMake(0, 0, kScreenWidth, [self inputViewHeight]);
        _inputView.backgroundColor = [UIColor colorWithWhite:0.941 alpha:1.000];
    }
    return _inputView;
}

- (CGFloat)inputViewHeight
{
    return 216.0;
}

- (CGFloat)sectionHeight
{
    return 36.0;
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

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)show
{
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}

- (void)dismiss
{
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    }
}

- (void)setPrimary:(BOOL)primary
{
    if (primary)
    {
        _primary = primary;
        [self parserPlistDict:[SUIEmoticonSection primarySectionDict]];
    }
}

- (UIScrollView *)sectionScrollView
{
    if (!_sectionScrollView) {
        _sectionScrollView = [UIScrollView new];
        _sectionScrollView.frame = CGRectMake(0, [self inputViewHeight]-[self sectionHeight], kScreenWidth, [self sectionHeight]);
        _sectionScrollView.showsHorizontalScrollIndicator = NO;
        [self.inputView addSubview:_sectionScrollView];
        [self.inputView.layer addSublayer:[self bottomLayer]];
    }
    return _sectionScrollView;
}

- (CALayer *)bottomLayer
{
    CALayer *bottomLayer = [CALayer new];
    bottomLayer.frame = CGRectMake(0, [self inputViewHeight]-[self sectionHeight], kScreenWidth, 0.5);
    bottomLayer.backgroundColor = [[UIColor lightGrayColor] CGColor];
    return bottomLayer;
}

- (NSMutableArray<SUIEmoticonSectionBtn *> *)sectionBtns
{
    if (!_sectionBtns) {
        _sectionBtns = [NSMutableArray new];
    }
    return _sectionBtns;
}

- (UIScrollView *)itemScrollView
{
    if (!_itemScrollView) {
        _itemScrollView = [UIScrollView new];
        _itemScrollView.pagingEnabled = YES;
        _itemScrollView.showsHorizontalScrollIndicator = NO;
        _itemScrollView.showsVerticalScrollIndicator = NO;
        _itemScrollView.alwaysBounceHorizontal = YES;
        _itemScrollView.delegate = self;
        _itemScrollView.userInteractionEnabled = YES;
        _itemScrollView.backgroundColor = [UIColor clearColor];
        _itemScrollView.clipsToBounds = NO;
        _itemScrollView.canCancelContentTouches = NO;
        _itemScrollView.delaysContentTouches = YES;
        [self.inputView addSubview:_itemScrollView];
    }
    return _itemScrollView;
}

- (UIPageControl *)currPageControl
{
    if (!_currPageControl) {
        _currPageControl = [[UIPageControl alloc] init];
        _currPageControl.hidesForSinglePage = YES;
        _currPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _currPageControl.currentPageIndicatorTintColor = gRGB(39, 105, 176);
        [self.inputView addSubview:_currPageControl];
    }
    return _currPageControl;
}

- (SUIEmoticonItemView *)emoticonItemView
{
    if (!_emoticonItemView) {
        _emoticonItemView = [SUIEmoticonItemView new];
        _emoticonItemView.backgroundColor = [UIColor clearColor];
        _emoticonItemView.currEmoticon = self;
        _emoticonItemView.itemScrollView = self.itemScrollView;
        [self.itemScrollView addSubview:_emoticonItemView];
    }
    return _emoticonItemView;
}

- (UIButton *)currSendBtn
{
    if (!_currSendBtn) {
        _currSendBtn = [UIButton new];
        if (kHans) {
            _currSendBtn.sui_normalTitle = @"发送";
        } else if (kHant) {
            _currSendBtn.sui_normalTitle = @"發送";
        } else {
            _currSendBtn.sui_normalTitle = @"Send";
        }
        _currSendBtn.backgroundColor = gRGB(39, 105, 176);
        _currSendBtn.sui_normalTitleColo = [UIColor whiteColor];
        _currSendBtn.sui_padding = 16.0f;
        _currSendBtn.frame = CGRectMake(kScreenWidth, [self inputViewHeight]-[self sectionHeight], _currSendBtn.sui_width, [self sectionHeight]);
        @weakify(self)
        [_currSendBtn.sui_signalForClick subscribeNext:^(id x) {
            @strongify(self)
            self.didClickSendBtnBlock();
        }];
        [self.inputView addSubview:_currSendBtn];
    }
    return _currSendBtn;
}


- (NSMutableArray<SUIEmoticonSection *> *)emoticonSections
{
    if (!_emoticonSections) {
        _emoticonSections = [NSMutableArray new];
    }
    return _emoticonSections;
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

@end


@implementation UIViewController (SUIEmoticon)

- (SUIEmoticon *)emoticonWithPlistArray:(nullable NSArray<NSString *> *)cArray primary:(BOOL)primary
{
    return [SUIEmoticon emoticonWithPlistArray:cArray controller:self primary:primary];
}

@end
