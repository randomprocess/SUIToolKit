//
//  SUIBaseView.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/2.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUIBaseView : UIView

@property (nonatomic,weak) IBOutlet id ibDelegate;

@property (nonatomic,weak) id<SUIBaseProtocol> bsDelegate;

@end
