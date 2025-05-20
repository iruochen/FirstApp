//
//  AppDelegate.m
//  FirstApp
//
//  Created by 若尘 on 2025/1/12.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/// 应用启动完成调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"didFinishLaunchingWithOptions");
    UIScreen *screen = [UIScreen mainScreen];
    self.window = [[UIWindow alloc] initWithFrame:[screen bounds]];
    
    TabBarViewController *vc = [[TabBarViewController alloc] init];
    self.window.rootViewController = vc;
    
    /// 获取启动类
    NSLog(@"%@", [UIApplication sharedApplication].delegate);
    // 设置window为主window并可见
    [self.window makeKeyAndVisible];
    
    return YES;
}

/// app 将要启动完成调用
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions API_AVAILABLE(ios(6.0)) {
    NSLog(@"willFinishLaunchingWithOptions");
    return YES;
}

/// app 进入前台调用
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
}

/// app 进入后台调用
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive");
}

@end
