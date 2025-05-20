//
//  UserSession.m
//  FirstApp
//
//  Created by 若尘 on 2025/1/14.
//

#import "UserSession.h"
#import "KeychainHelper.h"

@implementation UserSession

/// 单例
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static UserSession *userSession;
    
    dispatch_once(&onceToken, ^{
        userSession = [[UserSession alloc] init];
    });
    return userSession;
}

/// 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 读取用户名
        self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        NSLog(@"userName = %@", self.userName);
        /// 读取 token
        self.token = [[NSString alloc] initWithData:[KeychainHelper getDataForService:@"userToken"] encoding:NSUTF8StringEncoding];
        NSLog(@"token = %@", self.token);
    }
    return self;
}

/// 判断用户是否登录
- (BOOL)isLogin {
    return self.token != nil && self.token.length > 0;
}

/// 退出登录
- (void)logout {
    self.token = nil;
    self.userName = nil;
    /// 退出后清空钥匙串
    [KeychainHelper deleteDataForService:@"userToken"];
    /// 删除用户信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    /// 同步
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 保存用户信息
/// - Parameter dictionary: 信息字典
- (void)saveUserInfo:(NSDictionary *)dictionary {
    NSString *token = dictionary[@"token"];
    NSString *userName = dictionary[@"username"];
    
    self.token = token;
    self.userName = userName;
    
    /// 登录成功后将用户信息存储到钥匙串中
    if ([self isLogin]) {
        /// 存储用户信息
        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
        /// 同步
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        /// 字符串转换为 NSData
        NSData *data = [token dataUsingEncoding:NSUTF8StringEncoding];
        [KeychainHelper saveData:data service:@"userToken"];
    }
}
@end
