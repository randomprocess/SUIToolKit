//
//  SUIEmoticon.h
//  SUIToolKitDemo
//
//  Created by zzZ on 16/1/5.
//  Copyright © 2016年 SUIO~. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SUIEmoticonSection, SUIEmoticonItem;

typedef NS_ENUM(NSInteger, SUIEmoticonItemType) {
    SUIEmoticonItemTypePng = 1,
    SUIEmoticonItemTypeGif = 2,
    SUIEmoticonItemTypeGifAndPng = 3,
    SUIEmoticonItemTypeText = 4,
    SUIEmoticonItemTypeDelete = 9
};

NS_ASSUME_NONNULL_BEGIN

typedef void (^SUIEmoticonDidClickSendBtnBlock)(void);
typedef void (^SUIEmoticonDidClickItemBlock)(SUIEmoticonSection *cSection, SUIEmoticonItem *cItem);

/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIEmoticon
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@interface SUIEmoticon : UIView

+ (instancetype)emoticonWithPlistArray:(nullable NSArray<NSString *> *)cArray controller:(UIViewController *)controller primary:(BOOL)primary;

- (void)didClickSendBtn:(SUIEmoticonDidClickSendBtnBlock)cb;
- (void)didClickItem:(SUIEmoticonDidClickItemBlock)cb;

@property (null_resettable,nonatomic,strong) UIImage *deleteImage;

- (void)show;
- (void)dismiss;

@end


@interface UIViewController (SUIEmoticon)

- (SUIEmoticon *)emoticonWithPlistArray:(nullable NSArray<NSString *> *)cArray primary:(BOOL)primary;

@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIEmoticonSection
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@interface SUIEmoticonSection : NSObject

@property (nonatomic) NSInteger numOfRowItems;
@property (nonatomic) NSInteger numOfColItems;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSString *image;

@property (nonatomic,getter=isHasDeleteItem) BOOL hasDeleteItem;
@property (nonatomic,getter=isHasSendBtn) BOOL hasSendBtn;

@property (nonatomic,strong,readonly) NSMutableArray<SUIEmoticonItem *> *emoticonItems;

@end


/*o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o*
 *  SUIEmoticonItem
 *o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~o~*/

@interface SUIEmoticonItem : NSObject

@property (nonatomic) SUIEmoticonItemType type;

@property (nullable,nonatomic,copy) NSString *png;
@property (nullable,nonatomic,copy) NSString *gif;
@property (nullable,nonatomic,copy) NSString *text;

@property (nullable,nonatomic,strong) NSDictionary *remark;

@end


NS_ASSUME_NONNULL_END
