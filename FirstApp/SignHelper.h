///
///  SignHelper.h
///  FirstApp
///
///  Created by 若尘 on 2025/1/13.
///

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignHelper : NSObject

+ (NSString *)generateSignWithParams:(NSDictionary *)params timestamp:(NSString *)timestamp;

@end

NS_ASSUME_NONNULL_END
