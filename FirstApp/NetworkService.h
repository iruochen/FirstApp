//
//  NetworkService.h
//  FirstApp
//
//  Created by 若尘 on 2025/1/13.
//

#import <Foundation/Foundation.h>

typedef void(^NetworkCallback)(NSData *, NSURLResponse *, NSError *);

NS_ASSUME_NONNULL_BEGIN

@interface NetworkService : NSObject

+ (void)postWithUrl: (NSURL *)url params: (NSDictionary *)params callback: (NetworkCallback)callback;
+ (void)getWithUrl: (NSURL *)url callback: (NetworkCallback)callback;

@end

NS_ASSUME_NONNULL_END
