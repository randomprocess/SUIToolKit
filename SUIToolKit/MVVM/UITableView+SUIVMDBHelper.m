//
//  UITableView+SUIVMDBHelper.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/22.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "UITableView+SUIVMDBHelper.h"
#import "NSObject+SUIAdditions.h"
#import "UIViewController+SUIAdditions.h"
#import "UIViewController+SUIMVVM.h"
#import "SUIViewModel.h"

@implementation UITableView (SUIVMDBHelper)

- (SUIDBHelper *)sui_DBHelper
{
    return [self sui_getAssociatedObjectWithKey:@selector(sui_DBHelper)];
}

- (void)sui_DBHelperWithClass:(Class)modelClass
{
    [self sui_DBHelperWithClass:modelClass where:nil orderBy:nil];
}
- (void)sui_DBHelperWithClass:(Class)modelClass where:(id)searchTerm
{
    [self sui_DBHelperWithClass:modelClass where:searchTerm orderBy:nil];
}
- (void)sui_DBHelperWithClass:(Class)modelClass where:(id)searchTerm orderBy:(NSString *)orderTerm
{
    SUIDBHelper *curHelper = [[SUIDBHelper alloc] initWithClass:modelClass where:searchTerm orderBy:orderTerm delegate:self];
    [self sui_setAssociatedObject:curHelper key:@selector(sui_DBHelper) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  TableView DataSource Delegate
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

#pragma mark - TableView DataSource Delegate


- (void)sui_DBHelperWillChangeContent:(SUIDBHelper *)cHelper
{
    if ([self.sui_vc.sui_vm respondsToSelector:@selector(sui_DBHelperWillChangeContent:tableView:)]) {
        [self.sui_vc.sui_vm sui_DBHelperWillChangeContent:cHelper tableView:self];
    }
}

- (void)sui_DBHelper:(SUIDBHelper *)cHelper didChangeObject:(__kindof SUIDBEntity *)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(SUIDBHelperChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if ([self.sui_vc.sui_vm respondsToSelector:@selector(sui_DBHelper:didChangeObject:atIndexPath:forChangeType:newIndexPath:tableView:)]) {
        [self.sui_vc.sui_vm sui_DBHelper:cHelper didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath tableView:self];
    }
}

- (void)sui_DBHelperDidChangeContent:(SUIDBHelper *)cHelper
{
    if ([self.sui_vc.sui_vm respondsToSelector:@selector(sui_DBHelperDidChangeContent:tableView:)]) {
        [self.sui_vc.sui_vm sui_DBHelperDidChangeContent:cHelper tableView:self];
    }
}


@end
