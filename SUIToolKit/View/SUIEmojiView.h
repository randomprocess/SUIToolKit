//
//  SUIEmojiView.h
//  SUIToolKitDemo
//
//  Created by zzZ on 15/8/12.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIPopupObject.h"

#import "SUIBaseProtocol.h"

typedef NS_ENUM(NSInteger, SUIEmojiViewType)
{
    SUIEmojiViewTypePng                   = 0,
    SUIEmojiViewTypeGif                   = 1,
    SUIEmojiViewTypeText                  = 2,
};

@interface SUIEmojiView : SUIPopupObject


@property (nonatomic,weak) IBOutlet id<SUIBaseProtocol> currVC;


@property (nonatomic,assign) IBInspectable NSInteger showCustomEmoji;

@property (nonatomic,assign) IBInspectable NSInteger hidePrimaryEmoji;

/** default is 12.0 */
@property (nonatomic,assign) IBInspectable CGFloat sectionPadding;


@property (nonatomic,assign) IBInspectable UIImage *deleteImage;


@property (nonatomic,assign,readonly) CGFloat currHeight;



@end


// _____________________________________________________________________________

@interface SUIEmojiItem : NSObject

@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) NSDictionary *attributes;

@property (nonatomic,copy) NSString *imageName;

@property (nonatomic,copy) NSString *remark;

// _________________________

- (SUIEmojiSection *)section;

@property (nonatomic,assign,getter=isDeleteItem) BOOL deleteItem;

@property (nonatomic,assign) CGRect touchRect;
@property (nonatomic,assign) CGRect realRect;

@end


// _____________________________________________________________________________

@interface SUIEmojiSection : NSObject

@property (nonatomic,assign) SUIEmojiViewType type;
@property (nonatomic,assign) NSInteger numOfRowItems;
@property (nonatomic,assign) NSInteger numOfColItems;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIImage *image;

@property (nonatomic,assign) UIEdgeInsets padding; // default is {0, 0, 0, 0}

@property (nonatomic,assign,getter=isHasDeleteItem) BOOL hasDeleteItem; // default is YES
@property (nonatomic,assign,getter=isHasSendBtn) BOOL hasSendBtn; // default is YES

@property (nonatomic,strong) NSArray *emojiItemAry;

// _________________________

+ (SUIEmojiSection *)primaryEmojiSection;

- (NSInteger)numOfSinglePageItems;
- (NSInteger)numOfTotalItems;
- (NSInteger)numOfEmojiPageItems;
- (NSInteger)numOfPages;

@property (nonatomic,weak) UIScrollView *currScrollView;

- (NSInteger)numOfRowRealItems;
- (NSInteger)numOfColRealItems;

- (CGFloat)itemWidth;
- (CGFloat)itemHeight;

@end
