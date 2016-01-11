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

@property (nonatomic,strong) SUIAlbumMD *model;

@end

@implementation SUIMVVMRootCellVM
@dynamic model;


- (void)commonInit
{
    RAC(self, name) = RACObserve(self.model, name);
    RAC(self, aId) = [RACObserve(self.model, aId)
                      map:^id(NSNumber *cNum) {
                          return gFormat(@"id: %@", cNum);
                      }];
    RAC(self, dateText) = RACObserve(self.model, release_date);
    
    RAC(self, cover) = RACObserve(self.model, cover);
}

//- (RACSignal *)bindWithModel
//{
//    [[RACObserve(self, model) map:^id(id value) {
//        return [self bindWithModel];
//    }] switchToLatest];
//    
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [RACObserve(self.model, name) subscribeNext:^(id x) {
//            
//        }];
//    }];
//}


@end
