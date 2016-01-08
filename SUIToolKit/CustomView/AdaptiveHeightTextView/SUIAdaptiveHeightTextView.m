//
//  SUIAdaptiveHeightTextView.m
//  SUIToolKitDemo
//
//  Created by zzZ on 16/1/7.
//  Copyright © 2016年 SUIO~. All rights reserved.
//

#import "SUIAdaptiveHeightTextView.h"
#import "SUIUtilities.h"
#import "SUICategories.h"

#define tAdaptTextView_TextInset_TopBottom 0
#define tAdaptTextView_TextInset_LeftRight 2

@interface SUIAdaptiveHeightTextView () <UITextViewDelegate>

@property (nonatomic,strong) UITextView *currTextView;
@property (nonatomic,strong) UILabel *placeholderLbl;
@property (nonatomic,strong) UIImageView *currBackgroundView;

@property (nonatomic) CGFloat minHeight;
@property (nonatomic) CGFloat curHeight;
@property (nonatomic) CGFloat maxHeight;
@property (nonatomic) CGFloat singleTextTopInset;

@property (nonatomic,strong) NSLayoutConstraint *currContantHeight;

@property (nonatomic,copy) SUIAdaptiveHeightTextViewShouldReturnBlock shouldReturnBlock;
@property (nonatomic,copy) SUIAdaptiveHeightTextViewHeightDidChangedBlock heightDidchangedBlock;

@end

@implementation SUIAdaptiveHeightTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit
{
    self.minHeight = self.sui_height;
    self.curHeight = self.sui_height;
    self.maxHeight = [self fitHeightWithNumOfLines:self.maxLines];
    
    self.currTextView.delegate = self;
    
    @weakify(self)
    [[self.currTextView rac_signalForSelector:@selector(setText:)] subscribeNext:^(id x) {
        @strongify(self)
        [self textViewDidChange:self.currTextView];
    }];
    
    RACSignal *bgSignal = [RACObserve(self, backgroundImage) replayLazily];
    
    [[[bgSignal take:1] ignore:nil] subscribeNext:^(id x) {
        @strongify(self)
        self.currBackgroundView.image = [self.backgroundImage
                                         resizableImageWithCapInsets:
                                         UIEdgeInsetsMake(self.backgroundImage.size.height/2-1, self.backgroundImage.size.width/2-1, self.backgroundImage.size.height/2, self.backgroundImage.size.width/2)
                                         resizingMode:UIImageResizingModeStretch];
    }];
    
    [[[bgSignal skip:1] ignore:nil] subscribeNext:^(id x) {
        @strongify(self)
        self.currBackgroundView.image = self.backgroundImage;
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self refreshHeight];
    
    if (self.currTextView.text.length > 0) {
        if (self.placeholder.length > 0) {
            if (!self.placeholderLbl.hidden) {
                self.placeholderLbl.hidden = YES;
            }
        }
    } else {
        if (self.placeholder.length > 0) {
            if (self.placeholderLbl.hidden) {
                self.placeholderLbl.hidden = NO;
            }
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (self.shouldReturnBlock) {
            if (self.shouldReturnBlock()) {
                [textView sui_dismissKeyboard];
            }
            return NO;
        }
    }
    return YES;
}

- (void)refreshHeight
{
    CGFloat newHeight = [self fitHeightWithNumOfLines:0];
    
    if (newHeight < self.minHeight) {
        newHeight = self.minHeight;
    } else if (newHeight > self.maxHeight) {
        newHeight = self.maxHeight;
    }
    
    if (newHeight != self.curHeight)
    {
        if (newHeight == self.minHeight) {
            [self fitTextContainerInsetWithSingleLine:YES];
            self.currContantHeight.constant = newHeight;
        } else {
            [self fitTextContainerInsetWithSingleLine:NO];
            self.currContantHeight.constant = newHeight + tAdaptTextView_TextInset_TopBottom * 2;
        }
        
        [self.superview layoutIfNeeded];
                
        [self.currTextView scrollRangeToVisible:self.currTextView.selectedRange];
        self.curHeight = newHeight;
        
        if (self.heightDidchangedBlock) {
            self.heightDidchangedBlock (newHeight);
        }
    }
}

- (void)shouldReturnKeyboard:(SUIAdaptiveHeightTextViewShouldReturnBlock)cb
{
    self.shouldReturnBlock = cb;
}

- (void)heightDidChanged:(SUIAdaptiveHeightTextViewHeightDidChangedBlock)cb
{
    self.heightDidchangedBlock = cb;
}

- (NSInteger)maxLines
{
    if (_maxLines == 0) {
        _maxLines = 4;
    }
    return _maxLines;
}

- (CGFloat)singleTextTopInset
{
    if (_singleTextTopInset == 0) {
        _singleTextTopInset = (self.sui_height - [self fitHeightWithNumOfLines:1]) / 2;
    }
    return _singleTextTopInset;
}

- (NSLayoutConstraint *)currContantHeight
{
    if (!_currContantHeight)
    {
        _currContantHeight = [self sui_layoutConstraintHeight];
        uAssert(_currContantHeight, @"AdaptiveHeightTextView should add contantHeight");
    }
    return _currContantHeight;
}

- (UITextView *)currTextView
{
    if (!_currTextView) {
        _currTextView = [UITextView new];
        _currTextView.frame = self.bounds;
        _currTextView.backgroundColor = [UIColor clearColor];
        _currTextView.contentInset = UIEdgeInsetsZero;
        _currTextView.font = gFont(14);
        _currTextView.textContainer.lineFragmentPadding = 0;
        _currTextView.returnKeyType = UIReturnKeySend;
        [self fitTextContainerInsetWithSingleLine:YES];
        [self addSubview:_currTextView];
        
        [_currTextView sui_layoutPinnedToSuperview];
    }
    return _currTextView;
}

- (UIImageView *)currBackgroundView
{
    if (!_currBackgroundView) {
        _currBackgroundView = [UIImageView new];
        _currBackgroundView.frame = self.bounds;
        _currBackgroundView.backgroundColor = [UIColor clearColor];
        [self insertSubview:_currBackgroundView belowSubview:self.currTextView];
        
        [_currBackgroundView sui_layoutPinnedToSuperview];
    }
    return _currBackgroundView;
}


- (CGFloat)fitHeightWithNumOfLines:(NSInteger)cLine
{
    NSString *curSizeText = nil;
    if (cLine > 0) {
        NSMutableString *curTmpText = [NSMutableString stringWithString:@"suio~"];
        uRepeat(cLine-1,
                [curTmpText appendFormat:@"\nsuio~"];
                )
        curSizeText = curTmpText;
    } else {
        curSizeText = self.currTextView.text;
    }
    
    CGRect curRect = [curSizeText boundingRectWithSize:CGSizeMake(self.currTextView.sui_width-tAdaptTextView_TextInset_LeftRight*2, FLT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName : self.currTextView.font}
                                               context:nil];
    
    return curRect.size.height;
}

- (void)fitTextContainerInsetWithSingleLine:(BOOL)singleLine
{
    if (singleLine) {
        self.currTextView.textContainerInset = UIEdgeInsetsMake(self.singleTextTopInset, tAdaptTextView_TextInset_LeftRight, tAdaptTextView_TextInset_TopBottom, tAdaptTextView_TextInset_LeftRight);
    } else {
        if (self.currTextView.textContainerInset.top != tAdaptTextView_TextInset_TopBottom) {
            self.currTextView.textContainerInset = UIEdgeInsetsMake(tAdaptTextView_TextInset_TopBottom, tAdaptTextView_TextInset_LeftRight, tAdaptTextView_TextInset_TopBottom, tAdaptTextView_TextInset_LeftRight);
        }
    }
}

@end
