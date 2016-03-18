//
//  SUIMVVMRootCell.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/3/17.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUIMVVMRootCell.h"
#import "SUIToolKit.h"
#import "SUIMVVMRootCellVM.h"
#import "SUIMVVMRootMD.h"
#import "SUIUtils.h"

@interface SUIMVVMRootCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet UIButton *pushBtn;

@end


@implementation SUIMVVMRootCell


SUIClassOfViewModel(SUIMVVMRootCellVM)

- (void)sui_bindWithViewModel:(SUIMVVMRootCellVM *)sui_vm
{
    SUICELLRAC(self.titleLbl, text, titleText)
    SUICELLRAC(self.numLbl, text, numText)
    self.pushBtn.rac_command = [self pushCommand];
}


- (RACCommand *)pushCommand
{
    @weakify(self)
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        self.sui_tableView.sui_tableHelper.sui_indexPath = self.sui_indexPath;
        [self.sui_currentVC sui_storyboardInstantiate:@"SUIMVVMSecondVC"];
        return [RACSignal empty];
    }];
}



@end
