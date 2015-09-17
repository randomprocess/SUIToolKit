//
//  SUIChatVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/12.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIChatVC.h"

@interface SUIChatVC ()

@property (weak, nonatomic) IBOutlet SUIAdaptTextView *cTextView;
@property (weak, nonatomic) IBOutlet SUIKeyboardFollowView *curKeyboardFollowView;
@property (strong, nonatomic) IBOutlet SUIEmojiView *cEmojiView;
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
    
    [SUITool keyboardWillChange:self cb:^(BOOL showKeyborad, CGFloat keyboardHeight, UIViewAnimationOptions options, double duration) {
        if (showKeyborad)
        {
            [weakSelf.cEmojiView dismiss];
            if (weakSelf.faceBtn.selected) {
                weakSelf.faceBtn.selected = NO;
            }
        }
    }];
    
    
    
    /**
     *  DropdownTitleMenu
     */
    
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
}


#define mark - EmojiView

- (NSArray *)suiEmojiViewSections
{
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
}

- (void)suiEmojiViewTapItem:(SUIEmojiItem *)cItem
{
    uLog(@"%@", cItem.remark);
}

- (void)suiEmojiViewTapDeleteItem
{
    uLog(@"%@", @"dele dele ~");
}

- (void)suiEmojiViewTapSendBtn
{
    uLog(@"%@", @"send send ~");
}

- (IBAction)doFaceBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self.cEmojiView show];
        if (self.cTextView) {
            [self.cTextView dissmissKeyboard];
        }
        [self.curKeyboardFollowView bottomContant:[self.cEmojiView currHeight]];
    } else {
        [self.cEmojiView dismiss];
        [self.curKeyboardFollowView bottomContant:0];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.cTextView dissmissKeyboard];
    [self.cEmojiView dismiss];
    [self.curKeyboardFollowView bottomContant:0];
    if (self.faceBtn.selected) {
        self.faceBtn.selected = NO;
    }
}

@end
