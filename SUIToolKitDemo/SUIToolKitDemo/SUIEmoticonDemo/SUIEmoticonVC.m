//
//  SUIEmoticonVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 16/1/5.
//  Copyright © 2016年 SUIO~. All rights reserved.
//

#import "SUIEmoticonVC.h"
#import "SUIToolKit.h"
#import "SUIEmoticon.h"

@interface SUIEmoticonVC ()

@property (weak, nonatomic) IBOutlet UITextField *currTextField;

@property (nonatomic,strong) SUIEmoticon *curEmoticon;

@end

@implementation SUIEmoticonVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.curEmoticon = [self emoticonWithPlistArray:@[@"SUIEmoticonDemo"] primary:YES];
    
    [self.curEmoticon didClickItem:^(SUIEmoticonSection * _Nonnull cSection, SUIEmoticonItem * _Nonnull cItem) {
        uObj(cItem.remark);
    }];
    
    [self.curEmoticon didClickSendBtn:^{
        uLog(@"didClickSendBtn");
    }];
    
    [self.sui_keyboardWillChangeSignal subscribeNext:^(id x) {
        uObj(x);
    }];
}

- (IBAction)doInputBtn:(id)sender
{
    [self.currTextField sui_dismissKeyboard];
}

- (IBAction)doShowBtn:(id)sender
{
    [self.curEmoticon show];
}

- (IBAction)doDismissBtn:(id)sender
{
    [self.curEmoticon dismiss];
}


@end
