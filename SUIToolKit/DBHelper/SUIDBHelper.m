//
//  SUIDBHelper.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/12/22.
//  Copyright © 2015年 SUIO~. All rights reserved.
//

#import "SUIDBHelper.h"
#import "SUIDBEntity.h"
#import "ReactiveCocoa.h"
#import "SUIMacros.h"
#import "LKDBHelper.h"
#import "NSDictionary+SUIAdditions.h"

#define uSUIDBHelperWillChangeContent \
if ([self.delegate respondsToSelector:@selector(sui_DBHelperWillChangeContent:)]) { \
[self.delegate sui_DBHelperWillChangeContent:self]; \
}

#define uSUIDBHelperDidChangeObject(__stuff) \
if ([self.delegate respondsToSelector:@selector(sui_DBHelper:didChangeObject:atIndexPath:forChangeType:newIndexPath:)]) { \
__stuff \
}

#define uSUIDBHelperDidChangeContent \
if ([self.delegate respondsToSelector:@selector(sui_DBHelperDidChangeContent:)]) { \
[self.delegate sui_DBHelperDidChangeContent:self]; \
}

//static dispatch_queue_t sui_DBHelper_queue() {
//    static dispatch_queue_t sui_DBHelper_queue;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sui_DBHelper_queue = dispatch_queue_create([@"com.SUIToolKit.DBHelper" UTF8String], DISPATCH_QUEUE_SERIAL);
//    });
//    return sui_DBHelper_queue;
//}

@interface SUIDBHelper ()

@property (nonatomic,strong) id searchTerm;
@property (nonatomic,copy) NSString *orderTerm;
@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger count;

@property (nonatomic,weak) id<SUIDBHelperDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *sui_objects;
@property (nonatomic,strong) NSMutableArray *sui_objectCbs;

@end

@implementation SUIDBHelper


- (instancetype)initWithClass:(Class)modelClass where:(NSString *)searchTerm orderBy:(NSString *)orderTerm delegate:(id<SUIDBHelperDelegate>)delegate
{
    return [self initWithClass:modelClass where:searchTerm orderBy:orderTerm offset:0 count:0 delegate:delegate];
}

- (instancetype)initWithClass:(Class)modelClass where:(nullable id)searchTerm orderBy:(nullable NSString *)orderTerm offset:(NSInteger)offset count:(NSInteger)count delegate:(id<SUIDBHelperDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.searchTerm = searchTerm;
        self.orderTerm = orderTerm;
        self.delegate = delegate;
        self.offset = offset;
        self.count = count;
        [self commonInitWithClass:modelClass];
    }
    return self;
}

- (void)commonInitWithClass:(Class)modelClass
{
    [self searchForInitialObjectsWithClass:modelClass];
    
    [self registerForObjectChangeNotificationsWithClass:modelClass];
}

- (void)searchForInitialObjectsWithClass:(Class)modelClass
{
    LKDBHelper *curDBHelper = [modelClass getUsingLKDBHelper];
    NSMutableArray *curResultAry = [curDBHelper search:modelClass where:self.searchTerm orderBy:self.orderTerm offset:self.offset count:self.count];
    if (curResultAry.count > 0) {
        [self.sui_objects addObjectsFromArray:curResultAry];
        
        uSUIDBHelperWillChangeContent
        uSUIDBHelperDidChangeObject
        (
         [self.sui_objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.delegate sui_DBHelper:self didChangeObject:obj atIndexPath:nil forChangeType:SUIDBHelperChangeInsert newIndexPath:gIndexPath(idx, 0)];
        }];
         )
        uSUIDBHelperDidChangeContent
    }
}

- (void)registerForObjectChangeNotificationsWithClass:(Class)modelClass
{
    @weakify(self)
    [[gNotiCenter rac_addObserverForName:kSUIDBHelperObjectChangeNotifications object:nil] subscribeNext:^(NSNotification *cNoti) {
        @strongify(self)
        SUIDBEntity *curEntity = cNoti.object;
        if ([curEntity isKindOfClass:modelClass])
        {
            [self needReloadEntity:curEntity];
        }
    }];
}

- (void)replaceEntity:(SUIDBEntity *)cEntity inArray:(NSMutableArray *)cArray
{
    [cArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SUIDBEntity *curEntity = obj;
        if (curEntity.rowid == cEntity.rowid) {
            [cArray replaceObjectAtIndex:idx withObject:cEntity];
            *stop = YES;
        }
    }];
}

- (BOOL)checkEntityIsNeededForThisHelper:(SUIDBEntity *)cEntity
{
    id curSearchTerm = nil;
    if ([self.searchTerm isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *searchTermDict = [NSMutableDictionary dictionaryWithDictionary:self.searchTerm];
        [searchTermDict setObject:@(cEntity.rowid) forKey:@"rowid"];
        curSearchTerm = searchTermDict;
    }
    else if ([self.searchTerm isKindOfClass:[NSString class]] && ([LKDBUtils checkStringIsEmpty:self.searchTerm] == NO))
    {
        NSMutableString *searchTermString = [NSMutableString stringWithString:gFormat(@"rowid = %zd and ", cEntity.rowid)];
        [searchTermString appendString:self.searchTerm];
        curSearchTerm = searchTermString;
    }
    
    LKDBHelper *curDBHelper = [cEntity.class getUsingLKDBHelper];
    BOOL ret = [curDBHelper isExistsClass:cEntity.class where:curSearchTerm];
    return ret;
}

- (void)needReloadEntity:(SUIDBEntity *)cEntity
{
    [self sui_performDisorderObjects:^(NSMutableArray *curResultAry) {
        [self replaceEntity:cEntity inArray:curResultAry];
    } entity:cEntity];
}

- (void)sui_performDisorderObjects:(void (^)(NSMutableArray *curResultAry))cb entity:(SUIDBEntity *)cEntity
{
    if (self.sui_objectCbs.count == 0) {
        [self performSelectorOnMainThread:@selector(sui_disorderObjects:) withObject:cEntity waitUntilDone:NO];
    }
    [self.sui_objectCbs addObject:[cb copy]];
}

- (NSMutableArray *)sui_resultAryForEntity:(SUIDBEntity *)cEntity
{
    NSMutableArray<SUIDBEntity *> *curResultAry = [cEntity.class searchWithWhere:self.searchTerm orderBy:self.orderTerm offset:self.offset count:self.count];
    
    [curResultAry enumerateObjectsUsingBlock:^(SUIDBEntity * _Nonnull cObj, NSUInteger cIdx, BOOL * _Nonnull cStop) {
        [self.sui_objects enumerateObjectsUsingBlock:^(__kindof SUIDBEntity * _Nonnull sObj, NSUInteger sIdx, BOOL * _Nonnull sStop) {
            if (cObj.rowid == sObj.rowid) {
                [curResultAry replaceObjectAtIndex:cIdx withObject:sObj];
                *sStop = YES;
            }
        }];
    }];
    
    [self.sui_objectCbs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        void (^objectCb)(NSMutableArray *curResultAry) = obj;
        objectCb(curResultAry);
    }];
    
    return curResultAry;
}

- (void)sui_addOrDelObjectsInResultAry:(NSMutableArray *)cResultAry
{
    uSUIDBHelperWillChangeContent
    uSUIDBHelperDidChangeObject
    (
     NSMutableArray<__kindof SUIDBEntity *> *delObjects = [NSMutableArray arrayWithArray:self.sui_objects];
     [delObjects removeObjectsInArray:cResultAry];
     if (delObjects.count > 0)
     {
         [delObjects enumerateObjectsUsingBlock:^(__kindof SUIDBEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             NSInteger curIdx = [self.sui_objects indexOfObject:obj];
             [self.delegate sui_DBHelper:self didChangeObject:obj atIndexPath:gIndexPath(curIdx, 0) forChangeType:SUIDBHelperChangeDelete newIndexPath:nil];
         }];
         [self.sui_objects removeObjectsInArray:delObjects];
     }
     
     
     NSMutableArray<__kindof SUIDBEntity *> *addObjects = [NSMutableArray arrayWithArray:cResultAry];
     [addObjects removeObjectsInArray:self.sui_objects];
     if (addObjects.count > 0)
     {
         [addObjects enumerateObjectsUsingBlock:^(__kindof SUIDBEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             NSInteger curIdx = [cResultAry indexOfObject:obj];
             [self.delegate sui_DBHelper:self didChangeObject:obj atIndexPath:nil forChangeType:SUIDBHelperChangeInsert newIndexPath:gIndexPath(curIdx, 0)];
             [self.sui_objects insertObject:obj atIndex:curIdx];
         }];
     }
     )
    uSUIDBHelperDidChangeContent
}

- (void)sui_moveObjectsInResultAry:(NSMutableArray *)cResultAry
{
    uSUIDBHelperWillChangeContent
    uSUIDBHelperDidChangeObject
    (
     for (NSInteger curIdx=0; curIdx < cResultAry.count; curIdx++)
     {
         SUIDBEntity *curEntity = cResultAry[curIdx];
         SUIDBEntity *eveEntity = self.sui_objects[curIdx];
         
         if (curEntity != eveEntity)
         {
             NSInteger curIdx = [cResultAry indexOfObject:curEntity];
             NSInteger eveIdx = [self.sui_objects indexOfObject:curEntity];
             [self.delegate sui_DBHelper:self didChangeObject:curEntity atIndexPath:gIndexPath(eveIdx, 0) forChangeType:SUIDBHelperChangeMove newIndexPath:gIndexPath(curIdx, 0)];
         }
     }
     [self.sui_objects removeAllObjects];
     [self.sui_objects addObjectsFromArray:cResultAry];
     )
    uSUIDBHelperDidChangeContent
}

- (void)sui_updateObjectsInResultAry:(NSMutableArray *)cResultAry
{
    NSMutableArray<__kindof SUIDBEntity *> *updateAry = [NSMutableArray array];
    [cResultAry enumerateObjectsUsingBlock:^(SUIDBEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SUIDBEntity *sObj = self.sui_objects[idx];
        if (obj == sObj && obj.sui_updated) {
            [updateAry addObject:obj];
        }
    }];
    
    if (updateAry.count > 0)
    {
        uSUIDBHelperWillChangeContent
        uSUIDBHelperDidChangeObject
        (
         [updateAry enumerateObjectsUsingBlock:^(SUIDBEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger eveIdx = [cResultAry indexOfObject:obj];
            [self.delegate sui_DBHelper:self didChangeObject:obj atIndexPath:gIndexPath(eveIdx, 0) forChangeType:SUIDBHelperChangeUpdate newIndexPath:nil];
        }];
         )
        uSUIDBHelperDidChangeContent
    }
}

- (void)sui_disorderObjects:(SUIDBEntity *)cEntity
{

    NSMutableArray<SUIDBEntity *> *curResultAry = [self sui_resultAryForEntity:cEntity];
    
    if (self.sui_objectCbs.count > 30)
    {
        uSUIDBHelperWillChangeContent
        uSUIDBHelperDidChangeObject
        (
         [self.sui_objects removeAllObjects];
         [self.sui_objects addObjectsFromArray:curResultAry];
         [self.delegate sui_DBHelper:self didChangeObject:nil atIndexPath:nil forChangeType:SUIDBHelperChangeReload newIndexPath:nil];
         )
        uSUIDBHelperDidChangeContent
    }
    else
    {
        if (![curResultAry isEqualToArray:self.sui_objects]) {
            [self sui_addOrDelObjectsInResultAry:curResultAry];
            
            [self sui_updateObjectsInResultAry:curResultAry];
            
            if (![curResultAry isEqualToArray:self.sui_objects]) {
                [self sui_moveObjectsInResultAry:curResultAry];
            }
        } else {
            [self sui_updateObjectsInResultAry:curResultAry];
        }
    }
    
    [self.sui_objectCbs removeAllObjects];
}


#pragma mark - Lazily instantiate

- (NSMutableArray *)sui_objects
{
    if (!_sui_objects) {
        _sui_objects = [NSMutableArray array];
    }
    return _sui_objects;
}

- (NSMutableArray *)sui_objectCbs
{
    if (!_sui_objectCbs) {
        _sui_objectCbs = [NSMutableArray array];
    }
    return _sui_objectCbs;
}

@end


@implementation NSObject (SUIDBHelper)


+ (SUIDBHelper *)sui_DBHelperWithWhere:(NSString *)searchTerm orderBy:(NSString *)orderTerm delegate:(id<SUIDBHelperDelegate>)delegate
{
    return [self sui_DBHelperWithWhere:searchTerm orderBy:orderTerm delegate:delegate];
}

+ (SUIDBHelper *)sui_DBHelperWithWhere:(NSString *)searchTerm orderBy:(NSString *)orderTerm offset:(NSInteger)offset count:(NSInteger)count delegate:(id<SUIDBHelperDelegate>)delegate
{
    SUIDBHelper *curHelper = [[SUIDBHelper alloc] initWithClass:self where:searchTerm orderBy:orderTerm offset:offset count:count delegate:delegate];
    return curHelper;
}


@end
