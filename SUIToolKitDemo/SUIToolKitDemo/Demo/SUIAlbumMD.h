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

@property (nonatomic, copy) NSString *albumId;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, assign) NSInteger num_tracks;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSArray *artists;

@property (nonatomic, copy) NSString *name;

@end

@interface SUIArtistMD : NSObject

@property (nonatomic, copy) NSString *artistId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *portrait;

@property (nonatomic, assign) BOOL valid;

@property (nonatomic, assign) NSInteger num_albums;

@property (nonatomic, assign) NSInteger num_tracks;

@end

//@interface SUIMediaMD : NSObject
//
//@property (nonatomic, assign) NSInteger bitrate;
//
//@property (nonatomic, copy) NSString *p2purl;
//
//@end
//
//@interface SUITrackMD : NSObject
//
//@property (nonatomic, copy) NSString *dlyric;
//
//@property (nonatomic, strong) NSArray *medias;
//
//@property (nonatomic, copy) NSString *availability;
//
//@property (nonatomic, assign) NSInteger trackId;
//
//@property (nonatomic, copy) NSString *slyric;
//
//@property (nonatomic, copy) NSString *title;
//
//@property (nonatomic, copy) NSString *isdown;
//
//@property (nonatomic, assign) NSInteger mv;
//
//@property (nonatomic, strong) SUIAlbumMD *album;
//
//@property (nonatomic, copy) NSString *isplay;
//
//@property (nonatomic, strong) NSArray *artists;
//
//@end
