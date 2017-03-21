//
//  SNMqtt.h
//  sdk-demo
//
//  Created by User on 16/3/19.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNHardwareCMD.h"

@interface SNMqtt : NSObject

/**
 *  连接
 */
+ (void)connect;

/**
 *  断开
 */
+ (void)disconnect;

/**
 *  MQTT收到消息
 *
 *  @param receive message返回设备状态信息，cmd是把message消息拆解成模型
 */
+ (void)receiveMessage:(void (^)(NSString *message, SNHardwareCMD *cmd))receive;

/**
 *  MQTT收到消息
 *
 *  @param receive topic返回设备状态信息，payload返回广告消息，cmd是把topic消息拆解成模型
 */
+ (void)receive:(void (^)(NSString *topic, NSData *payload, SNHardwareCMD *cmd))receive;

/**
 *  是否连接
 */
+ (BOOL)isConnected;

@end
