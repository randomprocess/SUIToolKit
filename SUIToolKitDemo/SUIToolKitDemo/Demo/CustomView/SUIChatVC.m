//
//  SUIChatVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/12.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIChatVC.h"
#import "SUIEmojiView.h"

@interface SUIChatVC ()

@property (weak, nonatomic) IBOutlet SUIAdaptTextView *cTextView;
@property (weak, nonatomic) IBOutlet SUIKeyboardFollowView *curKeyboardFollowView;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;

@end

@implementation SUIChatVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    uWeakSelf
    [self.cTextView returnKeyboard:^BOOL(UITextView *textView) {
        uLog(@"currTextView Text ⤭ %@ ⤪", weakSelf.cTextView.text);
        return NO;
    }];
    
    
    [self suiKeyboardWillChange:^(BOOL showKeyborad, CGFloat keyboardHeight, UIViewAnimationOptions options, double duration) {
        if (showKeyborad)
        {
            [weakSelf.emojiView dismiss];
            if (weakSelf.faceBtn.selected) {
                weakSelf.faceBtn.selected = NO;
            }
        }
    }];
    
    
    /***************************************************************************
     *  DropdownTitleMenu
     **************************************************************************/
    
    {
        [self.dropdownTitleMenu titles:^NSArray *{
            return @[@"miao", @"aoao", @"meow"];
        }];
        
        [self.dropdownTitleMenu didSelect:^(NSInteger cIndex) {
            [UIAlertView alertWithTitle:@[@"miao", @"aoao", @"meow"][cIndex]
                                message:nil
                      cancelButtonTitle:@"Cancel"
                       otherButtonTitle:@"Other"
                             clickBlock:^(NSInteger idx) {
                                 uLog(@"%zd", idx);
                             }];
        }];
    }
    
    
    /***************************************************************************
     *  EmojiView
     **************************************************************************/
    
    {
        [self.emojiView sections:^NSArray *{
            SUIEmojiSection *curSection = [SUIEmojiSection new];
            curSection.type = SUIEmojiViewTypeText;
            curSection.numOfRowItems = 6;
            curSection.numOfColItems = 3;
            curSection.title = @"😄";
            NSArray *curItemAry = @[@"😄", @"😃", @"😀", @"😊", @"☺️", @"😉", @"😍", @"😘", @"😚", @"😗", @"😙", @"😜", @"😝", @"😛", @"😳", @"😁", @"😔", @"😌", @"😒", @"😞", @"😣", @"😢", @"😂", @"😭", @"😪", @"😥", @"😰", @"😅", @"😓", @"😩", @"😫", @"😨", @"😱", @"😠", @"😡", @"😤", @"😖", @"😆", @"😋", @"😷", @"😎", @"😴", @"😵", @"😲", @"😟", @"😦", @"😧", @"😈", @"👿", @"😮", @"😬", @"😐", @"😕", @"😯", @"😶", @"😇", @"😏", @"😑", @"😺", @"😸", @"😻", @"😽", @"😼", @"🙀", @"😿", @"😹", @"😾", @"👹", @"👺", @"🙈", @"🙉", @"🙊", @"💀", @"👽", @"💩", @"👍", @"👎", @"👌"];
            
            NSMutableArray *curSectionAry = [NSMutableArray array];
            for (NSString *curEmoji in curItemAry) {
                SUIEmojiItem *curItem =[SUIEmojiItem new];
                curItem.text = curEmoji;
                curItem.remark = curEmoji;
                [curSectionAry addObject:curItem];
            }
            
            curSection.emojiItemAry = curSectionAry;
            return @[curSection];
        }];
        
        [self.emojiView didTapItem:^(SUIEmojiItem *cItem) {
            uLog(@"%@", cItem.remark);
        }];
        
        [self.emojiView didTapDeleteItem:^{
            uLog(@"%@", @"dele dele ~");
        }];
        
        [self.emojiView didTapSendBtn:^{
            uLog(@"%@", @"send send ~");
        }];
    }
    
    
    
    {
        uWeakSelf
        [self.currTableView.tableExten willBeginDragging:^{
            [weakSelf.cTextView dismissKeyboard];
            [weakSelf.emojiView dismiss];
            [weakSelf.curKeyboardFollowView bottomContant:0];
            if (weakSelf.faceBtn.selected) {
                weakSelf.faceBtn.selected = NO;
            }
        }];
    }
}


- (IBAction)doFaceBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self.emojiView show];
        CGFloat curKeyboardBottom = self.curKeyboardFollowView.superview.height - self.curKeyboardFollowView.y - self.curKeyboardFollowView.originHeight;
        [self.cTextView dismissKeyboard];
        [self.curKeyboardFollowView currContantBottom].constant = curKeyboardBottom;
        [self.curKeyboardFollowView.layer removeAllAnimations];
        [self.curKeyboardFollowView layoutIfNeeded];
        [self.curKeyboardFollowView bottomContant:[self.emojiView currHeight]];
    } else {
        [self.emojiView dismiss];
        [self.curKeyboardFollowView bottomContant:0];
    }
}


@end
