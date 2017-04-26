//
//  SNUser.h
//  AirPurge
//
//  Created by User on 15/10/15.
//  Copyright © 2015年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNUser : NSObject

/**
 *  用户ID
 */
@property (nonatomic, copy) NSString *user_id;

/**
 *  用户名称
 */
@property (nonatomic, copy) NSString *user_name;

/**
 *  用户数字账号
 */
@property (nonatomic, copy) NSString *user_nickname;

/**
 *  用户 email
 */
@property (nonatomic, copy) NSString *user_email;

/**
 *  用户头像 url
 */
@property (nonatomic, copy) NSString *avatar;

/**
 *  用户电话
 */
@property (nonatomic, copy) NSString *user_phone;

/**
 *  手机号码
 */
@property (nonatomic, copy) NSString *user_mobile;

/**
 *  地址
 */
@property (nonatomic, copy) NSString *user_address;

/**
 *  性别
 */
@property (nonatomic, copy) NSString *user_sex;

/**
 *
 */
@property (nonatomic, copy) NSString *user_password;

/**
 *
 */
@property (nonatomic, copy) NSString *user_operationcode;

/**
 *
 */
@property (nonatomic, copy) NSString *user_type;

/**
 *
 */
@property (nonatomic, copy) NSString *user_level;

/**
 *
 */
@property (nonatomic, copy) NSString *latest_logintime;

/**
 *
 */
@property (nonatomic, copy) NSString *create_time;

/**
 *
 */
@property (nonatomic, copy) NSString *user_digit;

/**
 *
 */
@property (nonatomic, copy) NSString *email_flag;

/**
 *
 */
@property (nonatomic, copy) NSString *qq_openid;

/**
 *
 */
@property (nonatomic, copy) NSString *is_developer;

/**
 *
 */
@property (nonatomic, copy) NSString *source;

/**
 *
 */
@property (nonatomic, copy) NSString *area_code;

@end
