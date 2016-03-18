//
//  SUIMVVMSecondVC.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/3/18.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUIMVVMSecondVC.h"
#import "SUIMVVMSecondVM.h"
#import "SUIToolKit.h"

@interface SUIMVVMSecondVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;

@end

@implementation SUIMVVMSecondVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SUILogLine
}


SUIClassOfViewModel(SUIMVVMSecondVM)

- (void)sui_bindWithViewModel:(SUIMVVMSecondVM *)sui_vm
{
    
    SUILogObj(sui_vm);
    RAC(self.titleLbl,text) = [RACObserve(sui_vm, titleText) doNext:^(id x) {
        SUILogObj(x);
    }];
    
//    SUIVIEWRAC(self.titleLbl, text, titleText);
    SUIVIEWRAC(self.numLbl, text, numText);
}


@end
