//
//  SUIScccVC.m
//  SUIToolKitDemo
//
//  Created by zzZ on 15/7/3.
//  Copyright (c) 2015年 SUIO~. All rights reserved.
//

#import "SUIScccVC.h"

@interface SUIScccVC () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *subScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *supScrollView;

@end

@implementation SUIScccVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _supScrollView.contentSize = CGSizeMake(900, 500);
//    _subScrollView.contentSize = CGSizeMake(400, 300);
//    
//    uLog(@"%f", _supScrollView.contentSize.height);
//    uLog(@"%f", _supScrollView.contentSize.width);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    uFun
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    uFun
}


@end
