//
//  NSDataSNCategory.h
//  sdk-demo
//
//  Created by User on 16/3/18.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDataSNCategory : NSObject

@end

@interface NSData (SNCategory)

/**
*  AES加密
*
*  @param key 密钥
*/
- (NSData *)AES256EncryptWithKey:(NSString *)key;

/**
 *  AES解密
 *
 *  @param key 密钥
 */
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
