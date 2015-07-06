//
//  SUIDataSource.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSArray * (^SUIDataSourceBlock)(NSError *error, id responseObject);

@interface SUIDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<SUIBaseProtocol> dataSourceDelegate;

- (void)searchButtonAction;

- (void)requestData:(NSDictionary *)parameters
            replace:(BOOL)replace
          completed:(SUIDataSourceBlock)completed;

- (id)modelPassed;

@end
