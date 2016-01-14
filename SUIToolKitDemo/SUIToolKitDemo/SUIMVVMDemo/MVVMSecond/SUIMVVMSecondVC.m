//
//  SUIMVVMSecondVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/23.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIMVVMSecondVC.h"
#import "SUIToolKit.h"
#import "SUIMVVMSecondVM.h"
#import "UIImageView+AFNetworking.h"

@interface SUIMVVMSecondVC ()

@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *idLbl;

@end

@implementation SUIMVVMSecondVC

- (Class)sui_classOfViewModel
{
    return [SUIMVVMSecondVM class];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SUIVIEWBIND(SUIMVVMSecondVM,
                
                @weakify(self)
                [[SUIVIEWObserve(cover) ignore:nil]
                 subscribeNext:^(NSString *cCover) {
                     @strongify(self)
                     [self.coverView setImageWithURL:cCover.sui_toURL];
                 }];
                
                RAC(self.idLbl, text) = SUIVIEWObserve(aId);
                
                )
}


@end
