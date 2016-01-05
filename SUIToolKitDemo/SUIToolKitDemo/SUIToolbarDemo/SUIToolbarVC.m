//
//  SUIToolbarVC.m
//  SUICategoriesDemo
//
//  Created by zzZ on 16/1/4.
//  Copyright © 2016年 suio~. All rights reserved.
//

#import "SUIToolbarVC.h"
#import "SUIMacros.h"
#import "SUICategories.h"

@interface SUIToolbarVC ()
@property (weak, nonatomic) IBOutlet UITextField *currTextField;

@end

@implementation SUIToolbarVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)keyboardDismiss:(id)sender
{
    [self.currTextField sui_dismissKeyboard];
}


@end
