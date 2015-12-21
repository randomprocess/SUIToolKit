//
//  SUIAlbumMD.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/21.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SUIArtistMD;
@interface SUIAlbumMD : NSObject

@property (nonatomic, copy) NSString *release_date;

@property (nonatomic, assign) BOOL available;

@property (nonatomic, assign) NSInteger aId;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, assign) NSInteger num_tracks;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSArray<SUIArtistMD *> *artists;

@property (nonatomic, copy) NSString *name;


// _____________________________________________________________________________

@property (nonatomic, strong) UIImage *coverImage;

@end


@interface SUIArtistMD : NSObject

@property (nonatomic, assign) NSInteger tId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *portrait;

@property (nonatomic, assign) BOOL valid;

@end

