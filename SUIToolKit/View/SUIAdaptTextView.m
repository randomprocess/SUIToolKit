//
//  SUIAdaptTextView.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/11.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIAdaptTextView.h"
#import "SUIToolKitConst.h"
#import "UIView+SUIExt.h"


#define tAdaptTextView_TextInset_TopBottom 1
#define tAdaptTextView_TextInset_LeftRight 3

@interface SUIAdaptTextView () <UITextViewDelegate>

@property (nonatomic,strong) UITextView *currTextView;
@property (nonatomic,strong) UILabel *placeholderLbl;

@property (nonatomic,assign) CGFloat minHeight;
@property (nonatomic,assign) CGFloat curHeight;
@property (nonatomic,assign) CGFloat maxHeight;
@property (nonatomic,assign) CGFloat singleTextTopInset;

@property (nonatomic,strong) NSLayoutConstraint *currContantHeight;

@property (nonatomic,copy) SUIAdaptTextViewReturnBlock returnBlock;

@end

@implementation SUIAdaptTextView


- (void)awakeFromNib
{
    self.minHeight = self.height;
    self.curHeight = self.height;

    self.maxHeight = [self fitHeightWithNumOfLines:self.maxLines];
    
    self.currTextView.delegate = self;
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
    if ([text isEqualToString:@"\n"])
    {
        if (self.returnBlock)
        {
            if (self.returnBlock(textView))
            {
                [textView resignFirstResponder];
            }
            return NO;
        }
    }
    return YES;
}


- (void)refreshHeight
{
    CGFloat newHeight = [self fitHeightWithNumOfLines:0];
    
    if (newHeight < self.minHeight)
    {
        newHeight = self.minHeight;
    }
    
    if (newHeight != self.curHeight)
    {
        if (newHeight == self.minHeight)
        {
            [self fitTextContainerInsetWithSingleLine:YES];
            
            self.currContantHeight.constant = newHeight;
        }
        else
        {
            [self fitTextContainerInsetWithSingleLine:NO];
            
            if (newHeight > self.maxHeight)
            {
                [self.currTextView flashScrollIndicators];
                newHeight = self.maxHeight;
            }
            
            self.currContantHeight.constant = newHeight + tAdaptTextView_TextInset_TopBottom * 2;
        }
        
        [self layoutIfNeeded];
        
        [self.currTextView scrollRangeToVisible:self.currTextView.selectedRange];
        self.curHeight = newHeight;
        
        if ([self.bsDelegate respondsToSelector:@selector(handlerAction:cModel:)])
        {
            [self.bsDelegate handlerAction:self.currTextView cModel:nil];
        }
    }
}

- (NSLayoutConstraint *)currContantHeight
{
    if (!_currContantHeight)
    {
        _currContantHeight = [self contantHeight];
        NSAssert(_currContantHeight != nil, @"should add contantHeight");
    }
    return _currContantHeight;
}


- (CGFloat)fitHeightWithNumOfLines:(NSInteger)cLine
{
    NSString *curSizeText = nil;
    if (cLine > 0)
    {
        NSMutableString *curTmpText = [NSMutableString stringWithString:@"suio~"];
        uRepeat(cLine-1,
                [curTmpText appendFormat:@"\nsuio~"];
                )
        curSizeText = curTmpText;
    }
    else
    {
        curSizeText = self.currTextView.text;
    }
    
    CGRect curRect = [curSizeText boundingRectWithSize:CGSizeMake(self.currTextView.width-tAdaptTextView_TextInset_LeftRight*2, FLT_MAX)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : self.currTextView.font}
                              context:nil];
    
    return curRect.size.height;
}

- (void)fitTextContainerInsetWithSingleLine:(BOOL)singleLine
{
    if (singleLine)
    {
        self.currTextView.textContainerInset = UIEdgeInsetsMake(self.singleTextTopInset, tAdaptTextView_TextInset_LeftRight, tAdaptTextView_TextInset_TopBottom, tAdaptTextView_TextInset_LeftRight);
    }
    else
    {
        if (self.currTextView.textContainerInset.top != tAdaptTextView_TextInset_TopBottom)
        {
            self.currTextView.textContainerInset = UIEdgeInsetsMake(tAdaptTextView_TextInset_TopBottom, tAdaptTextView_TextInset_LeftRight, tAdaptTextView_TextInset_TopBottom, tAdaptTextView_TextInset_LeftRight);
        }
    }
}


- (void)showKeyboard
{
    if (![self.currTextView isFirstResponder]) {
        [self.currTextView becomeFirstResponder];
    }
}

- (void)dissmissKeyboard
{
    if ([self.currTextView isFirstResponder]) {
        [self.currTextView resignFirstResponder];
    }
}

- (void)returnKeyboard:(SUIAdaptTextViewReturnBlock)returnBlock
{
    self.returnBlock = returnBlock;
}


#pragma mark - Lazy

- (UITextView *)currTextView
{
    if (!_currTextView)
    {
        _currTextView = [UITextView new];
        _currTextView.frame = self.bounds;
        _currTextView.contentInset = UIEdgeInsetsZero;
        _currTextView.font = gFont(14);
        _currTextView.textContainer.lineFragmentPadding = 0;
        _currTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self fitTextContainerInsetWithSingleLine:YES];
        [self addSubview:_currTextView];
    }
    return _currTextView;
}

- (UILabel *)placeholderLbl
{
    if (!_placeholderLbl)
    {
        _placeholderLbl = [UILabel new];
        _placeholderLbl.font = self.currTextView.font;
        _placeholderLbl.textColor = [UIColor lightGrayColor];
        _placeholderLbl.frame = CGRectMake(tAdaptTextView_TextInset_LeftRight, self.singleTextTopInset, 0, 0);
        _placeholderLbl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self insertSubview:_placeholderLbl aboveSubview:self.currTextView];
    }
    return _placeholderLbl;
}

- (NSInteger)maxLines
{
    if (_maxLines == 0)
    {
        _maxLines = 4;
    }
    return _maxLines;
}

- (CGFloat)singleTextTopInset
{
    if (_singleTextTopInset == 0)
    {
        _singleTextTopInset = (self.height - [self fitHeightWithNumOfLines:1]) / 2;
    }
    return _singleTextTopInset;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder.length > 0)
    {
        self.placeholderLbl.text = placeholder;
        [self.placeholderLbl sizeToFit];
        self.placeholderLbl.hidden = self.currTextView.text.length > 0;
    }
    else
    {
        if (_placeholderLbl) {
            [_placeholderLbl removeFromSuperview];
            _placeholderLbl = nil;
        }
    }
}

- (NSString *)placeholder
{
    return _placeholderLbl.text;
}


- (NSString *)text
{
    return self.currTextView.text;
}
- (void)setText:(NSString *)text
{
    self.currTextView.text = text;
}


@end
