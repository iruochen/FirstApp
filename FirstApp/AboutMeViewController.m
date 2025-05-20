//
//  AboutMeViewController.m
//  FirstApp
//
//  Created by 若尘 on 2025/1/14.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

/// 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"init");
    }
    return self;
}

/// 加载 view
/// 只调用一次
//- (void)loadView {
//    NSLog(@"loadView");
//}

/// view 加载完成
/// 一般做样式修改
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    self.title = @"关于我";
    /// 背景色
    self.view.backgroundColor = [UIColor whiteColor];
}

/// 页面将要显示
/// 页面跳转回来后还会执行
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

/// 页面已经
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

/// 页面将要消失
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

/// 页面已经消失
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

/// 页面被销毁
- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
