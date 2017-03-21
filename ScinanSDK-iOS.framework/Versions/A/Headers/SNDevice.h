//
//  SNDevice.h
//  AirPurge
//
//  Created by User on 15/10/15.
//  Copyright © 2015年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNDevice : NSObject

/**
 *  设备Device编号,等同id
 */
@property (nonatomic, copy) NSString *ID;

/**
 *  设备Device名称
 */
@property (nonatomic, copy) NSString *title;

/**
 *  对设备Device描述
 */
@property (nonatomic, copy) NSString *about;

/**
 *  设备类型
 */
@property (nonatomic, copy) NSString *type;

/**
 *  设备图片
 */
@property (nonatomic, copy) NSString *image;

/**
 *  主从授权 0:主 1:从
 */
@property (nonatomic, assign) NSInteger ms_type;

/**
 *  用户产品 id
 */
@property (nonatomic, copy) NSString *product_id;

/**
 *  在线离线状态
 */
@property (nonatomic, assign) BOOL online;

/**
 *  最后一次操作时间
 */
@property (nonatomic, copy) NSString *c_timestamp;

/**
 *  最后一次全状态时间
 */
@property (nonatomic, copy) NSString *as_timestamp;

/**
 *  全状态
 */
@property (nonatomic, copy) NSString *s00;

/**
 *  把s00第一段(时间戳)去掉生成的数组
 */
@property (nonatomic, strong) NSArray *s00Array;

/**
 *  定时器是否启动
 */
@property (nonatomic, assign) BOOL timer;

/**
 *  倒计时是否启动
 */
@property (nonatomic, assign) BOOL countdown;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *tags;

@property (nonatomic, copy) NSString *gps_name;

@property (nonatomic, copy) NSString *lat;

@property (nonatomic, copy) NSString *lon;

@property (nonatomic, copy) NSString *door_type;

@property (nonatomic, copy) NSString *public_type;

@property (nonatomic, copy) NSString *update_time;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *device_key;

@property (nonatomic, copy) NSString *company_id;

@property (nonatomic, copy) NSString *mstype;

@property (nonatomic, copy) NSString *nline;

@property (nonatomic, copy) NSString *extend;

@property (nonatomic, copy) NSString *ip;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *deployment_status;

@property (nonatomic, copy) NSString *electric_quantity;

@property (nonatomic, copy) NSString *model;

@property (nonatomic, copy) NSString *hardware_version;

@property (nonatomic, copy) NSString *timestamp;

@property (nonatomic, copy) NSString *online_time;

@property (nonatomic, strong) id datas;

//超级APP增加
/**
 *  设备id 在超级APP中，服务器返回的设备id为 device_id;
 */
@property(nonatomic,copy) NSString* device_id;

@property (nonatomic,copy) NSString* version_android;

@property (nonatomic,copy) NSString* version_ios;

/**
 *  设备Device名称
 */
@property (nonatomic,copy) NSString* name;

/**
 *  动作id
 */
@property (nonatomic,copy) NSString* action_id;

/**
 *  动作编号（底板使用）
 */
@property(nonatomic,copy) NSString* action_code;

/**
 *  动作描述
 */
@property(nonatomic,copy) NSString* action_desc;

/**
 *  控制指令
 */
@property(nonatomic,copy) NSString* command;

/**
 *  子设备数组
 */
@property(nonatomic,copy) NSArray* list;

//网关子设备
@property(nonatomic,copy) NSString* frequency;

//@property(nonatomic,copy) NSString* product_type;
@property(nonatomic,copy) NSString* type_code;
//@property(nonatomic,copy) NSString* product_type_sub;
@property(nonatomic,copy) NSString* sub_type_code;

@property(nonatomic,copy) NSString* sub_device_id;

@property(nonatomic,copy) NSString* sub_name;

@property(nonatomic,copy) NSString* device_desc;

@property(nonatomic,copy) NSString* gateway_device_id;

@property(nonatomic,copy) NSString *dis_pwd_status;

@end
