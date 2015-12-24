SUIToolKit
======
- A collection of convenient classes for iOS.
- 一些常用或能方便开发的类库集合.

# Overview
* [Requirements](#requirements)
* [Features](#features)
* [Installation](#installation)
* [Reference](#reference)

------

# Requirements
- iOS7.0+
- ARC only
- [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)
- [AFNetworking](https://github.com/AFNetworking/AFNetworking)
- [UITableView+FDTemplateLayoutCell](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell)
- [LKDBHelper](https://github.com/li6185377/LKDBHelper-SQLite-ORM)

# Features
Include:
- 常用宏和工具类: [SUIUtilities](https://github.com/randomprocess/SUIUtilities)
- 常用的类别: [SUICategories](https://github.com/randomprocess/SUICategories)
- 基于MVVM编程模式架构

# Installation
Using CocoaPods:
```objective-c
pod 'SUIToolKit'
```

# Reference
Please Refer to the SUIToolKitDemo.

# Change-log
**Version 0.1.0**
- 加入BaseProtocol, 分离TableView的代理到DataSource中, 同时自动处理Coredata相关操作
- 界面传值使用了BaseSegue
- 添加UITableView+FDTemplateLayoutCell计算Cell高度

**Version 0.2.0**
- DataSource不再和VC绑定, 而是作为TableView的属性, 解决多个TableView的情况
- 从VC下分离出Request类

**Version 0.3.0**
- 移除BaseProtocol, 用组合的方式代替协议

**Version 1.0.0**
- 全新的基于MVVM编程模式架构
- 拆出SUIUtilities和SUICategories
- 基于storyboard新的界面传值和跳转方式
- 添加LKDBHelper使用FMDB代替Coredata


# License
SUIToolKit is available under the MIT license. See the LICENSE file for more info.
