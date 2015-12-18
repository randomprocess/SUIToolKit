//
//  SUINetworkConfig.h
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/15.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SUINetworkMethod) {
    SUINetworkMethodGet = 0,
    SUINetworkMethodPost
};

@interface SUINetworkConfig : NSObject


+ (instancetype)sharedInstance;


@property (nullable,nonatomic,copy) NSString *baseURL;
@property (nonatomic) SUINetworkMethod networkMethod; // Default to Get.
@property (nonatomic) NSTimeInterval timeoutInterval; // Default to 30.


@end

NS_ASSUME_NONNULL_END
