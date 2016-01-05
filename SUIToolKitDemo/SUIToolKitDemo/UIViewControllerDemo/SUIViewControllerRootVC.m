//
//  SUIViewControllerRootVC.m
//  SUICategoriesDemo
//
//  Created by zzZ on 15/12/11.
//  Copyright © 2015年 suio~. All rights reserved.
//

#import "SUIViewControllerRootVC.h"
#import "UIViewController+SUIAdditions.h"
#import "SUIUtilities.h"

@interface SUIViewControllerRootVC ()

@end


@implementation SUIViewControllerRootVC
{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    uLog(@"*** SUIViewControllerRootVC *** %@", self);
    
#pragma mark - Common
    
    uObj(self.sui_identifier);
    
    uObj(self.sui_tableView);
    
    uFun;
    
#pragma mark - Geometry

    uFloat(self.sui_opaqueNavBarHeight);
    
    uFloat(self.sui_translucentNavBarHeight);

    uFloat(self.sui_opaqueTabBarHeight);

    uFloat(self.sui_translucentTabBarHeight);

    uRect(self.sui_viewFrame);
}


#pragma mark - *** Alert & ActionSheet ***

- (void)showAlertStyle
{
    SUIAlertController *curAlertController = [self sui_showAlertWithTitle:@"aTitle"
                                                                  message:@"aMessage"
                                                                    style:SUIAlertStyleAlert];
    [curAlertController addTitle:@"取消"
                           style:SUIAlertActionCancel
                         handler:^(SUIAlertAction * _Nonnull cAction) {
                             uLog(@"Alert Cancel");
                         }];
    
    uWeakSelf
    [curAlertController addTitle:@"确定"
                           style:SUIAlertActionDestructive
                         handler:^(SUIAlertAction * _Nonnull cAction) {
                             uLog(@"Alert1");
                             [weakSelf modelPassed];
                         }];
    
    [curAlertController show];
}

- (void)showActionSheetStyle
{
    uWeakSelf
    
    SUIAlertController *curAlertController = [self sui_showAlertWithTitle:@"bTitle"
                                                                  message:@"bMessage"
                                                                    style:SUIAlertStyleActionSheet];
    [curAlertController addAction:
     [SUIAlertAction actionWithTitle:@"取消" style:SUIAlertActionCancel handler:^(SUIAlertAction * _Nonnull cAction) {
        uLog(@"Sheet Cancel");
    }]];
    
    [curAlertController addAction:
     [SUIAlertAction actionWithTitle:@"Action1" style:SUIAlertActionDefault handler:^(SUIAlertAction * _Nonnull cAction) {
        uLog(@"Action1");
        [weakSelf modelPassed];
    }]];
    
    [curAlertController addAction:
     [SUIAlertAction actionWithTitle:@"Action2" style:SUIAlertActionDestructive handler:^(SUIAlertAction * _Nonnull cAction) {
        uLog(@"Action2");
        [weakSelf modelPassed];
    }]];
    
    [curAlertController addAction:
     [SUIAlertAction actionWithTitle:@"Action3" style:SUIAlertActionDefault handler:^(SUIAlertAction * _Nonnull cAction) {
        uLog(@"Action3");
        [weakSelf modelPassed];
    }]];
    
    [curAlertController show];
}

- (void)modelPassed
{
    [self sui_signalPassed:^RACSignal * _Nonnull(__kindof UIViewController * _Nonnull cDestVC) {
        
        if ([cDestVC.sui_identifier isEqualToString:@"ViewControllerSecond"])
        {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:[RACTuple tupleWithObjectsFromArray:@[@"AlertController10", @"AlertController11"]]];
                [subscriber sendCompleted];
                return nil;
            }];
        }
        return nil;
    }];
    
    [self performSegueWithIdentifier:@"SecondPush" sender:self];
}


#pragma mark - StoryboardLink

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self showAlertStyle];
                }
                    break;
                case 1:
                {
                    [self showActionSheetStyle];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    [self sui_signalPassed:^RACSignal * _Nonnull(__kindof UIViewController * _Nonnull cDestVC) {
                        
                        if ([cDestVC.sui_identifier isEqualToString:@"ViewControllerSecond"])
                        {
                            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                                
                                
                                [subscriber sendNext:RACTuplePack(@"Segue", @"Push")];
                                [subscriber sendCompleted];
                                return nil;
                            }];
                        }
                        return nil;
                    }];
                    
                    [self sui_storyboardSegueWithIdentifier:@"SecondPush"];
                }
                    break;
                case 1:
                {
                    [self sui_signalPassed:^RACSignal * _Nonnull(__kindof UIViewController * _Nonnull cDestVC) {
                        
                        if ([cDestVC.sui_identifier isEqualToString:@"ViewControllerSecond"])
                        {
                            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                                [subscriber sendNext:RACTuplePack(@"Segue", @"Modal")];
                                [subscriber sendCompleted];
                                return nil;
                            }];
                        }
                        return nil;
                    }];
                    
                    // need to use prepareForSegue()
                    
                    [self sui_storyboardSegueWithIdentifier:@"SecondModal"];
                }
                    break;
                case 2:
                {
                    [self sui_signalPassed:^RACSignal * _Nonnull(__kindof UIViewController * _Nonnull cDestVC) {
                        
                        if ([cDestVC.sui_identifier isEqualToString:@"ViewControllerSecond"])
                        {
                            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                                [subscriber sendNext:[RACTuple tupleWithObjectsFromArray:@[@"Instantiate VC", @"Push"]]];
                                [subscriber sendCompleted];
                                return nil;
                            }];
                        }
                        return nil;
                    }];
                    
                    [self sui_storyboardInstantiate:@"SUIViewController" storyboardID:@"ViewControllerSecond"];
                }
                    break;
                case 3:
                {
                    [self sui_signalPassed:^RACSignal * _Nonnull(__kindof UIViewController * _Nonnull cDestVC) {
                        
                        if ([cDestVC.sui_identifier isEqualToString:@"ViewControllerSecond"])
                        {
                            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                                [subscriber sendNext:[RACTuple tupleWithObjectsFromArray:@[@"Instantiate VC", @"Modal"]]];
                                [subscriber sendCompleted];
                                return nil;
                            }];
                        }
                        return nil;
                    }];
                    
                    [self sui_storyboardInstantiate:@"SUIViewController" storyboardID:@"ViewControllerSecond" segueType:SUISegueTypeModal];
                }
                    break;
                    
                case 4:
                {
                    [self sui_signalPassed:^RACSignal * _Nonnull(__kindof UIViewController * _Nonnull cDestVC) {
                        
                        if ([cDestVC.sui_identifier isEqualToString:@"ViewControllerSecond"])
                        {
                            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                                [subscriber sendNext:[RACTuple tupleWithObjectsFromArray:@[@"Instantiate Nav", @"Push"]]];
                                [subscriber sendCompleted];
                                return nil;
                            }];
                        }
                        return nil;
                    }];
                    
                    [self sui_storyboardInstantiate:@"SUIViewController" storyboardID:@"ViewControllerNav" segueType:SUISegueTypePush];
                }
                    break;
                    
                case 5:
                {
                    [self sui_signalPassed:^RACSignal * _Nonnull(__kindof UIViewController * _Nonnull cDestVC) {
                        
                        if ([cDestVC.sui_identifier isEqualToString:@"ViewControllerSecond"])
                        {
                            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                                [subscriber sendNext:[RACTuple tupleWithObjectsFromArray:@[@"Instantiate Nav", @"Modal"]]];
                                [subscriber sendCompleted];
                                return nil;
                            }];
                        }
                        return nil;
                    }];
                    
                    [self sui_storyboardInstantiate:@"SUIViewController" storyboardID:@"ViewControllerNav" segueType:SUISegueTypeModal];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SecondModal"])
    {
        segue.destinationViewController.sui_sourceVC = segue.sourceViewController;
    }
}


@end
