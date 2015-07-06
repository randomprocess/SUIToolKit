//
//  SUIAlbumMD.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/6.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SUIArtistMD;
@interface SUIAlbumMD : NSObject

@property (nonatomic, copy) NSString *release_date;

@property (nonatomic, assign) BOOL available;

@property (nonatomic, assign) NSInteger albumId;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, assign) NSInteger num_tracks;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSArray *artists;

@property (nonatomic, copy) NSString *name;

@end

@interface SUIArtistMD : NSObject

@property (nonatomic, assign) NSInteger artistId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *portrait;

@property (nonatomic, assign) BOOL valid;


@end
