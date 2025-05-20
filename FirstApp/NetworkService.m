///
///  NetworkService.m
///  FirstApp
///
///  网络请求封装类
///  Created by 若尘 on 2025/1/13.
///

#import "NetworkService.h"

typedef void(^NetworkCallback)(NSData *, NSURLResponse *, NSError *);

@implementation NetworkService

/// POST 请求封装
/// - Parameters:
///   - url: 请求 url
///   - params: body 参数
///   - callback: 回调方法
+ (void)postWithUrl: (NSURL *)url params: (NSDictionary *)params callback: (NetworkCallback)callback{
    
    NSError *error;
    /// 将字典转换为 NSData
    NSData *body = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    if (error) {
        NSLog(@"json 转换失败，请检测参数是否正常");
        callback(nil, nil, error);
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    request.HTTPBody = body;
    
    /// 发送请求
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:callback];
    [task resume];
}

/// GET 请求封装
/// - Parameters:
///   - url: 请求 url
///   - callback: 回调函数
+ (void)getWithUrl: (NSURL *)url callback: (NetworkCallback)callback{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:callback];
    [task resume];
}

@end
