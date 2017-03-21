//
//  XLDictionary.h
//  xlzj
//
//  Created by 周绪刚 on 16/7/12.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

@interface XLDictionary  : NSObject
/**
 *  字典转字符串
 *
 *  @param dict 字典
 *
 *  @return 字符串
 */
+ (NSString *)dictionaryToJson:(NSDictionary *)dict;
/**
 *  字符串转字典
 *
 *  @param jsonString JSON字符串
 *
 *  @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
