//
//  TabBarViewController.m
//  FirstApp
//
//  Created by 若尘 on 2025/1/12.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "MineViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HomeViewController *home = [[HomeViewController alloc] init];
    home.tabBarItem.title = @"首页";
    
    MineViewController *mine = [[MineViewController alloc] init];
    /// 导航对象，在个人中心 -> 关于我跳转
    /// 将个人中心页面作为根页面
    UINavigationController *naviMine = [[UINavigationController alloc] initWithRootViewController:mine];
    naviMine.tabBarItem.title = @"个人中心";
    
    self.viewControllers = @[home, naviMine];
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
