///
///  SignHelper.m
///  FirstApp
///
///  Created by 若尘 on 2025/1/13.
///

#import "SignHelper.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation SignHelper

/// 生成加密字符串
/// - Parameters:
///   - params: 参数
///   - timestamp: 时间戳
+ (NSString *)generateSignWithParams:(NSDictionary *)params timestamp:(NSString *)timestamp {
    /// dict sort
    NSArray *sortedKeys = [[params allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *concatenated = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        NSString *value = [params objectForKey:key];
        [concatenated appendFormat:@"%@=%@", key, value];
    }
    
    /// add timestamp
    [concatenated appendString:timestamp];
    
//     NSLog(@"sign str =%@=", concatenated);
    
    // 计算md5
    const char *cStr = [concatenated UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *md5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5String appendFormat:@"%02x", digest[i]];
    }
    return md5String;
}
@end
