//
//  KeychainHelper.m
//  FirstApp
//
//  Created by 若尘 on 2025/1/14.
//

#import "KeychainHelper.h"
#import <Security/Security.h>

@implementation KeychainHelper

+ (NSMutableDictionary *)keychainQueryForService:(NSString *)service {
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithCapacity:2];
    [query setObject:(__bridge  id)kSecClassGenericPassword forKey:(__bridge  id)kSecClass];
    [query setObject:service forKey:(__bridge id)kSecAttrService];
    return query;
}

+ (BOOL)saveData:(NSData *)data
         service:(NSString *)service {
    if (!data || !service) {
        return NO;
    }
    NSMutableDictionary *query = [self keychainQueryForService:service];
    [query setObject:data forKey:(__bridge id)kSecValueData];
    
    /// 删除旧的项，防止重复添加
    SecItemDelete((__bridge CFDictionaryRef)query);
    
    /// 保存数据到钥匙串
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    return (status == errSecSuccess);
}

+ (NSData *)getDataForService:(NSString *)service {
    NSMutableDictionary *query = [self keychainQueryForService:service];
    [query setObject:@YES forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    
    if (status == errSecSuccess) {
        return (__bridge_transfer NSData *)result;
    }
    return nil;
}

+ (BOOL)deleteDataForService:(NSString *)service {
    NSMutableDictionary *query = [self keychainQueryForService:service];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    return (status == errSecSuccess);
}

+ (BOOL)dataExistsForService:(NSString *)service {
    NSData *data = [self getDataForService:service];
    return (data != nil);
}
@end
