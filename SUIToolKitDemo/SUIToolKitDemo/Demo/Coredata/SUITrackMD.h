//
//  SUITrackMD.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/13.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface SUITrackMD : NSManagedObject

@property (nonatomic, retain) NSString * dlyric;
@property (nonatomic, retain) NSString * availability;
@property (nonatomic, retain) NSNumber * trackId;
@property (nonatomic, retain) NSString * slyric;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * isdown;
@property (nonatomic, retain) NSNumber * mv;
@property (nonatomic, retain) NSString * isplay;
@property (nonatomic, retain) NSSet *medias;
@end

@interface SUITrackMD (CoreDataGeneratedAccessors)

- (void)addMediasObject:(NSManagedObject *)value;
- (void)removeMediasObject:(NSManagedObject *)value;
- (void)addMedias:(NSSet *)values;
- (void)removeMedias:(NSSet *)values;

@end
