//
//  SNNetworking.h
//
//
//  Created by User on 16/3/19.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNNetworking : NSObject

/**
 *  Post请求
 *
 *  @param url      URL
 *  @param paramers 参数
 */
+ (void)postURL:(NSString *)url parameters:(NSDictionary *)paramers success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/**
 *  Get请求
 *
 *  @param url      URL
 *  @param paramers 参数
 */
+ (void)getURL:(NSString *)url parameters:(NSDictionary *)paramers success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/**
 *  Post上传文件
 *
 *  @param url           URL
 *  @param paramers      参数
 *  @param formDataArray SNFormData对象数组
 */
+ (void)postURL:(NSString *)url parameters:(NSDictionary *)paramers formDataArray:(NSArray *)formDataArray success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

@end


@interface SNFormData : NSObject

/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *fileData;

/**
 *  参数的Key
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *fileName;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;

@end
