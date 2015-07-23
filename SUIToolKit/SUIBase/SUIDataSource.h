//
//  SUIDataSource.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SUIBaseProtocol.h"

typedef void (^SUIDataSourceCompletionBlock)(NSError *error, id responseObject);
typedef NSArray * (^SUIDataSourceRefreshTableBlock)(id responseObject);


@interface SUIDataSource : NSObject <
    UITableViewDataSource,
    UITableViewDelegate,
    NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) id<SUIBaseProtocol> dataSourceDelegate;


- (void)requestData:(NSDictionary *)parameters
            replace:(BOOL)replace
       refreshTable:(SUIDataSourceRefreshTableBlock)refreshTable
          completed:(SUIDataSourceCompletionBlock)completed;

- (id)modelPassed;

@end
