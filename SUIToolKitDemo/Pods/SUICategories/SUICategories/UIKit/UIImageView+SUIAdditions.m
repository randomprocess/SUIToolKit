//
//  UIImageView+SUIAdditions.m
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/1/22.
//  Copyright © 2016年 suio~. All rights reserved.
//

#import "UIImageView+SUIAdditions.h"

@implementation UIImageView (SUIAdditions)


- (BOOL)sui_resizableImage
{
    self.sui_resizableImage = YES;
    return YES;
}
- (void)setSui_resizableImage:(BOOL)sui_resizableImage
{
    if (sui_resizableImage) {
        UIEdgeInsets curInsets = UIEdgeInsetsMake(self.image.size.height/2-1,
                                                  self.image.size.width/2-1,
                                                  self.image.size.height/2,
                                                  self.image.size.width/2);
        self.image = [self.image resizableImageWithCapInsets:curInsets resizingMode:UIImageResizingModeStretch];
    }
}


@end
