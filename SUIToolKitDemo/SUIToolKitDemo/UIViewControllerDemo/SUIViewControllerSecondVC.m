//
//  SUIViewControllerSecondVC.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/11.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "SUIViewControllerSecondVC.h"
#import "UIViewController+SUIAdditions.h"
#import "SUIUtilities.h"

@interface SUIViewControllerSecondVC ()

@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;

@end

@implementation SUIViewControllerSecondVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.sui_sourceSignal subscribeNext:^(RACTuple *cTuple) {
        self.lbl1.text = cTuple.first;
        self.lbl2.text = cTuple.second;
    } completed:^{
        uFun;
    }];
}

@end
