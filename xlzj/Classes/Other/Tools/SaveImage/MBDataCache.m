//
//  MBDataCache.m
//  Park
//
//  Created by zhouxg on 16/2/21.
//  Copyright © 2016年 zhouxg. All rights reserved.
//

#import "MBDataCache.h"
#import "NSString+Hashing.h"
@implementation MBDataCache
//保存数据
//  保存data指向数据保存到文件中
+(void)saveData:(NSData *)data urlString:(NSString *)dateString
{
    //<1>创建缓存文件夹
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/DataCache/"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    //<2>先把网址转化为字符串
//    NSString *fileHTML = [[NSString stringWithFormat:@"%@%@",path,[dateString MD5Hash]]stringByAppendingPathExtension:@"html"];
    NSString *file = [NSString stringWithFormat:@"%@%@",path,[dateString MD5Hash]];
//    [data writeToFile:fileHTML atomically:YES];
    [data writeToFile:file atomically:YES];
}
//读取数据
//  从缓存中读取数据
+(NSData *)readDataWithUrlString:(NSString *)dateString
{
    //<1>获取文件名
    NSString *file = [NSString stringWithFormat:@"%@/Documents/DataCache/%@",NSHomeDirectory(),[dateString MD5Hash]];
    //<2>读取数据
    NSData *data = [[NSData alloc] initWithContentsOfFile:file];
    return data;
}
//从缓存删除数据
+(void)deleteDataWithUrlString:(NSString *)dateString
{
    NSError * error;
    NSString *file = [NSString stringWithFormat:@"%@/Documents/DataCache/%@",NSHomeDirectory(),[dateString MD5Hash]];
   BOOL deleteStatus =  [[NSFileManager defaultManager] removeItemAtPath:file error:&error];
    if (deleteStatus) {
        NSLog(@"缓存清除请成功!!!");
    }
}
@end
