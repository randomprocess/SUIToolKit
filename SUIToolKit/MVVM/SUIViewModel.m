//
//  SUIViewModel.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/18.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIViewModel.h"
#import "UIViewController+SUIAdditions.h"
#import "UIViewController+SUIMVVM.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UITableViewCell+SUIMVVM.h"
#import "SUIMacros.h"

@interface SUIViewModel ()

@property (nonatomic,strong) NSMutableArray *currDataAry;
@property (nonatomic,strong) NSString *currCellIdentifier;


@end

@implementation SUIViewModel

- (instancetype)initWithModel:(id)model
{
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  TableView DataSource Delegate
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - TableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.currDataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currDataAry.count > section) {
        NSMutableArray *subDataAry = self.currDataAry[section];
        return subDataAry.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *curCell = nil;
    curCell = [tableView dequeueReusableCellWithIdentifier:self.currCellIdentifier];
    uAssert(curCell, @"cell if nil Identifier ⤭ %@ ⤪", self.currCellIdentifier);
    
    [self sui_configureCell:curCell tableView:tableView atIndexPath:indexPath];
    if ([self.sui_vc respondsToSelector:@selector(sui_tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.sui_vc sui_tableView:tableView willDisplayCell:curCell forRowAtIndexPath:indexPath];
    }
    return curCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    uWeakSelf
    return [tableView fd_heightForCellWithIdentifier:self.currCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [weakSelf sui_configureCell:cell tableView:tableView atIndexPath:indexPath];
    }];
}

- (void)sui_configureCell:(UITableViewCell *)cCell tableView:(UITableView *)cTableView atIndexPath:(NSIndexPath *)cIndexPath
{
    id curModel = [self currentModelAtIndex:cIndexPath tableView:cTableView];
    cCell.sui_md = curModel;
    cCell.sui_tableView = cTableView;
    cCell.sui_vm = self;
    
    if ([self.sui_vc respondsToSelector:@selector(sui_tableView:willCalculateHeightForCell:forRowAtIndexPath:)]) {
        [self.sui_vc sui_tableView:cTableView willCalculateHeightForCell:cCell forRowAtIndexPath:cIndexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (id)currentModelAtIndex:(NSIndexPath *)cIndexPath
{
    return [self currentModelAtIndex:cIndexPath tableView:self.sui_vc.sui_tableView];
}

- (id)currentModelAtIndex:(NSIndexPath *)cIndexPath tableView:(UITableView *)cTableView
{
    if (cTableView) {
        if (self.currDataAry.count > cIndexPath.section) {
            NSMutableArray *subDataAry = self.currDataAry[cIndexPath.section];
            if (subDataAry.count > cIndexPath.row) {
                id curModel = subDataAry[cIndexPath.row];
                return curModel;
            }
        }
    }
    return nil;
}


#pragma mark Lazily instantiate

- (NSMutableArray *)currDataAry
{
    if (!_currDataAry) {
        _currDataAry = [NSMutableArray array];
    }
    return _currDataAry;
}

- (NSString *)currCellIdentifier
{
    if (!_currCellIdentifier) {
        _currCellIdentifier = gFormat(@"SUI%@Cell", self.sui_vc.sui_identifier);
    }
    return _currCellIdentifier;
}

@end
