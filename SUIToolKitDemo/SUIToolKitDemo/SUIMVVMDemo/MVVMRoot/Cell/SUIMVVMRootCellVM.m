//
//  SUIMVVMRootCellVM.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/1/11.
//  Copyright © 2016年 RandomSuio. All rights reserved.
//

#import "SUIMVVMRootCellVM.h"
#import "SUIToolKit.h"
#import "SUIAlbumMD.h"

@interface SUIMVVMRootCellVM ()

@end

@implementation SUIMVVMRootCellVM


- (void)sui_commonInit
{
    SUIVMMDTYPE(SUIAlbumMD,
                
                SUIVMRAC(name, name);
                RAC(self, aId) = [SUIVMObserve(aId)
                                  map:^id(NSNumber *cNum) {
                                      return gFormat(@"id: %@", cNum);
                                  }];
                
                SUIVMRAC(dateText, release_date);
                SUIVMRAC(cover, cover);
                
                )
//    
//#define keypath3(PATH) (((void)(NO && ((void)((SUIAlbumMD *)self.model).PATH, NO)), # PATH))
//
//    keypath3(release_date);
//    
//    typeof(SUIAlbumMD *)model = self.model;
//
//    NSString *versionPath = @keypath(((SUIAlbumMD *)self.model), name);
//    
//[RACObserve((typeof(SUIAlbumMD *)self.model), name) takeUntil:[RACObserve(self, model) skip:1]]
//        
//        
//    }
//    
}


@end
