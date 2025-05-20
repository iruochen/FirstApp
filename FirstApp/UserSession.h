//
//  UserSession.h
//  FirstApp
//
//  Created by 若尘 on 2025/1/14.
//

#import <Foundation/Foundation.h>

@interface UserSession : NSObject

/// token 信息
@property (nonatomic, copy) NSString *token;
/// 用户名 copy 读的时候会拷贝一份
@property (nonatomic, copy) NSString *userName;

+ (instancetype)shareInstance;

- (BOOL)isLogin;

- (void)logout;

- (void)saveUserInfo:(NSDictionary *)dictionary;

@end
