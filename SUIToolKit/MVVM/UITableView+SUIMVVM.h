//
//  UITableView+SUIMVVM.h
//  SUIToolKitDemo
//
//  Created by zzZ on 16/1/5.
//  Copyright © 2016年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (SUIMVVM)

@property (nonatomic) IBInspectable BOOL sui_calculateCellHeight;

- (void)sui_resetDataAry:(NSArray *)newDataAry;
- (void)sui_resetDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection;
- (void)sui_reloadDataAry:(NSArray *)newDataAry;
- (void)sui_reloadDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection;
- (void)sui_addDataAry:(NSArray *)newDataAry;
- (void)sui_addDataAry:(NSArray *)newDataAry forSection:(NSInteger)cSection;
- (void)sui_insertData:(id)cModel AtIndex:(NSIndexPath *)cIndexPath;
- (void)sui_deleteDataAtIndex:(NSIndexPath *)cIndexPath;

@end

NS_ASSUME_NONNULL_END
