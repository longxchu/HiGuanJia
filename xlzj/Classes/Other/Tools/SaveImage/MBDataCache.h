//
//  MBDataCache.h
//  Park
//
//  Created by zhouxg on 16/2/21.
//  Copyright © 2016年 zhouxg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBDataCache : NSObject
+(void)saveData:(NSData *)data urlString:(NSString *)dateString;
+(NSData *)readDataWithUrlString:(NSString *)dateString;
+(void)deleteDataWithUrlString:(NSString *)dateString;
@end
