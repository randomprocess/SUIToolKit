//
//  SUIMediaMD.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/13.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SUITrackMD;

@interface SUIMediaMD : NSManagedObject

@property (nonatomic, retain) NSString * p2purl;
@property (nonatomic, retain) NSNumber * attribute;
@property (nonatomic, retain) SUITrackMD *relationship;

@end
