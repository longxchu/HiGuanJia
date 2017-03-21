//
//  SNAccount.h
//  sdk-demo
//
//  Created by User on 16/3/25.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNAccount : NSObject

/**
 *  账号
 */
@property (nonatomic, copy) NSString *account;

/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;

/**
 *  区号
 */
@property (nonatomic, copy) NSString *areaCode;

/**
 *  地区名
 */
@property (nonatomic, copy) NSString *areaName;

#pragma mark - 归档

/**
 *  归档账号信息，覆盖原来的
 *
 *  @param account   登录账号
 *  @param password  密码
 *  @param areaCode  区号
 */
+ (void)saveAccount:(NSString *)account password:(NSString *)password areaCode:(NSString *)areaCode;

/**
 *  归档账号信息，覆盖原来的
 *
 *  @param account   登录账号
 *  @param password  密码
 *  @param areaCode  区号
 *  @param areaName  地区名
 */
+ (void)saveAccount:(NSString *)account password:(NSString *)password areaCode:(NSString *)areaCode areaName:(NSString *)areaName;

/**
 *  解档账号信息
 */
+ (SNAccount *)loadAccount;

/**
 *  删除账号，账号、密码、Token都删除
 */
+ (void)removeAccount;

/**
 *  清除密码，只删除密码
 */
+ (void)removePassword;


#pragma mark - Token

/**
 *  是否有token
 */
+ (BOOL)haveToken;

/**
 *  换票
 */
+ (void)refreshToken;

/**
 *  删除Token
 */
+ (void)removeToken;
@end
