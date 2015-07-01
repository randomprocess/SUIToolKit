//
//  SUIDataSource.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/6/26.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HandlerBlock)(NSURLSessionDataTask *task, NSError *error, id responseObject);

@interface SUIDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, weak) id<SUIBaseProtocol> dataSourceDelegate;


- (void)requestData:(NSDictionary *)parameters
            replace:(BOOL)replace
          completed:(HandlerBlock)completedBlock;

- (void)resetDataAry:(NSArray *)newDataAry;

- (void)addDataAry:(NSArray *)newDataAry;

- (id)modelPassed;


@end
