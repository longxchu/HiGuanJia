//
//  SNDatabase.h
//  sdk-demo
//
//  Created by User on 16/3/18.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNDevice, SNUser, SNSensor, SNFood;

@interface SNDatabase : NSObject

#pragma mark - 存储对象

/**
 *  把一个模型对象存到数据库，只能存SNDevice、SNUser、SNSensor、SNFood其中一种
 */
+ (void)saveSNObject:(id)object;

/**
 *  从数据库读取一个设备
 *
 *  @param ID 设备ID
 */
+ (SNDevice *)loadDeviceID:(NSString *)ID;

/**
 *  从数据库读取一个Sensor
 *
 *  @param ID 传感器ID
 */
+ (SNSensor *)loadSensorID:(NSString *)ID;

/**
 *  从数据库读取一个用户
 *
 *  @param ID 用户ID
 */
+ (SNUser *)loadUserID:(NSString *)ID;

/**
 *  从数据库读取一个用户
 *
 *  @param ID 菜谱ID
 */
+ (SNFood *)loadFoodMenuID:(NSString *)ID;

#pragma mark - 存储WiFi信息

/**
 *  把SSID和密码存储到数据库
 *
 *  @param ssid     SSID
 *  @param password 密码
 */
+ (void)saveSSID:(NSString *)ssid password:(NSString *)password;

/**
 *  从数据库读取SSID的密码
 *
 *  @param ssid SSID
 */
+ (NSString *)loadPasswordWithSSID:(NSString *)ssid;

/**
 *  设置默认SSID
 *
 *  @param ssid SSID
 */
+ (void)setDefaultSSID:(NSString *)ssid;

/**
 *  获取默认SSID
 */
+ (NSString *)getDefaultSSID;

@end
