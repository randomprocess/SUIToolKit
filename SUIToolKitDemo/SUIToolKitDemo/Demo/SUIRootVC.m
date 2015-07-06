////
////  SUIRootVC.m
////  SUIToolKitDemo
////
////  Created by zzZ on 15/6/26.
////  Copyright (c) 2015年 SUIO~. All rights reserved.
////
//
//#import "SUIRootVC.h"
//#import "MJExtension.h"
////#import "SUIWeatherMD.h"
//
//@implementation SUIRootVC
//
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    
//    // tableView不分组的情况下
//    //
//    
//    // 新建一个继承SUIBaseVC的类①
//    // 命名以 SUI 开头, VC 结尾 (类似介个SUIRootVC)
//    //
//    // 在storyboard中拖出个VC, SB的Class中填入对应类名
//    //
//    // tableView需要添加上拉下拉左滑删除, 只需要在SB的属性检查器中选择就好
//    // 如果添加了上拉和下拉, 并当上拉和下拉发生时就会调用 handlerMainLoadData: 这个方法
//    // 具体看 SUIBaseProtocol
//    //
//    // 请求数据用 requestData: 这个方法, 其中http请求使用的传输方法和域名用的是上方统一设置的
//    // 具体可以参考这个类下方的方法
//    //
//    //
//    // 拖个tableView放到VC上, 拖Cell放到tableView上
//    //
//    // 新建一个继承SUIBaseCell的类
//    // 命名以 SUI 开头, Cell 结尾, 中间部分和VC的相同 (类似SUIRootCell)
//    // 在SB的Class填入类名, 这里需要在属性面板的Identifier中再填一次
//    //
//    // 在cell上拖入视图, 加好约束, 会自动计算高度, 也可以用代码加约束③
//    //`
//    
//    
//    // ①不是必须继承SUIBaseVC, 如果是继承其他VC只要实现SUIBaseProtocol协议
//    // 并在viewDidLoad中加上一句 [[SUIBaseConfig sharedConfig] configureController:self];
//    // 不过命名依然是要以 SUI 开头 VC 结尾, tableViewController之后会加上
//    
//    // ②tableView下拉上拉左滑删除偷懒不想写代码都放到了属性面板中, 搜索暂时未实现之后会加上
//    // 只要在storyboard的属性检查器中选择就好, 当然也可以直接写代码, 具体看 SUIBaseProtocol
//    
//    // ③这里用的都是Dynamic Prototypes, 如果要用Static Cells, 那么VC的父类需要继承SUIBaseTVC(之后会加上)
//    
//    
//    
//    
//    
//    
//    
//    
//}
//
//
//- (void)handlerMainLoadData:(BOOL)loadMoreData
//{
//    // 请求数据都是用requestData:这个方法, 如果是不同域名的其他请求 可以用SUIHttpClient中的方法
//    // 写在这个方法内replace的值为YES, 这样会自动刷新tableView
//    [self requestData:@{@"kw": @"杭州"} replace:YES completed:^NSArray *(NSError *error, id responseObject) {
//        uLog(@"%@", responseObject);
//        
//        // 请求到的数据推荐使用 MJExtension 快速打包成model
//        SUIWeatherMD *wMD = [SUIWeatherMD objectWithKeyValues:responseObject];
//        
//        uLog(@"address=%@, alevel=%zd, cityName=%@, lat=%f, lon=%f, level=%zd", wMD.address, wMD.alevel, wMD.cityName, wMD.lat, wMD.lon, wMD.level);
//        
//        // 返回打包好的model数组, 用来刷新tableView, 若不需要则返回nil
//        // 外面的括号是分组用的, 如果不分组就是[[model]]
//        return @[@[wMD]];
//    }];
//}
//
//
//- (void)doAction:(id)sender cModel:(id)cModel
//{
//    uFun
//}
//
//
//@end
