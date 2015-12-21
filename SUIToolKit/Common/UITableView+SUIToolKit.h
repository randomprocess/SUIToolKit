//
//  UITableView+SUIToolKit.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/21.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SUITableViewCalculateCellHeightBlock)(__kindof UITableViewCell *cCell, NSIndexPath *cIndexPath);
typedef void (^SUITableViewDisplayCellBlock)(__kindof UITableViewCell *cCell, NSIndexPath *cIndexPath);
typedef NSString * _Nonnull (^SUITableViewCellIdentifierBlock)(NSIndexPath *cIndexPath, id _Nullable model);

@interface UITableView (SUIToolKit)


@property (readonly,copy) NSMutableArray *sui_dataAry;


- (void)sui_willCalculateCellHeight:(SUITableViewCalculateCellHeightBlock)cb;
- (void)sui_willDisplayCell:(SUITableViewDisplayCellBlock)cb;
- (void)sui_cellIdentifier:(SUITableViewCellIdentifierBlock)cb;

- (void)sui_resetDataAry:(NSArray *)newDataAry;
- (void)sui_resetDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection;
- (void)sui_reloadDataAry:(NSArray *)newDataAry;
- (void)sui_reloadDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection;
- (void)sui_addDataAry:(NSArray *)newDataAry;
- (void)sui_addDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection;
- (void)sui_insertData:(id)cModel AtIndex:(NSIndexPath *)cIndexPath;
- (void)sui_deleteDataAtIndex:(NSIndexPath *)cIndexPath;

@property (nullable,readonly,copy) SUITableViewCalculateCellHeightBlock sui_blockForCalculateCellHeight;
@property (nullable,readonly,copy) SUITableViewDisplayCellBlock sui_blockForDisplayCell;
@property (nullable,readonly,copy) SUITableViewCellIdentifierBlock sui_blockForCellIdentifier;


@end

NS_ASSUME_NONNULL_END
