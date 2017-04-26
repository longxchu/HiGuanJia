//
//  SNAPConfig.h
//  sdk-demo
//
//  Created by User on 16/3/14.
//  Copyright © 2016年 Scinan. All rights reserved.
//
//  AP模式绑定设备

#import <Foundation/Foundation.h>

@protocol SNAPConfigDelegate <NSObject>

@optional

/**
 *  建立TCP连接后，收到回传的设备ID
 */
- (void)APConfigReceiceDeviceID:(NSString *)deviceID companyID:(NSString *)companyID type:(NSString *)type;

/**
 *  发送SSID和密码后，收到回传的OK
 */
- (void)APConfigReceiveOK;

/**
 *  配置成功，configWithSSID:password:companyID:types:方法的回调
 */
- (void)APConfigSuccessWithDeviceID:(NSString *)deviceID type:(NSString *)type;

/**
 *  配置失败，configWithSSID:password:companyID:types:方法的回调
 */
- (void)APConfigFailureWithError:(NSError *)error;

@end

@interface SNAPConfig : NSObject

/**
 *  连接AP(TCP)，获取设备ID
 */
- (void)connectAP;

/**
 *  向设备发送SSID和密码(TCP)
 */
- (void)sendDeviceID:(NSString *)deviceID SSID:(NSString *)SSID password:(NSString *)password;

/**
 *  停止配置
 */
- (void)stop;

/**
 *  进行AP配
 */
- (void)configWithSSID:(NSString *)ssid password:(NSString *)password companyID:(NSString *)companyID types:(NSArray<NSString *> *)types;

@property (nonatomic, assign) id<SNAPConfigDelegate> delegate;

@end
