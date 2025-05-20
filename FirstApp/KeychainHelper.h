//
//  KeychainHelper.h
//  FirstApp
//
//  Created by 若尘 on 2025/1/14.
//

#import <Foundation/Foundation.h>

@interface KeychainHelper : NSObject

+ (BOOL)saveData:(NSData *)data
         service:(NSString *)service;
+ (NSData *)getDataForService:(NSString *)service;
+ (BOOL)deleteDataForService:(NSString *)service;

@end

