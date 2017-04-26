//
//  NSStringSNCategory.h
//  sdk-demo
//
//  Created by User on 16/3/19.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringSNCategory : NSObject

@end

@interface NSString (SNCategory)

/**
 *  MD5加密
 */
- (NSString *) MD5;

/**
 *  MD5加密32位大写
 */
- (NSString *) upperMD5;
@end
