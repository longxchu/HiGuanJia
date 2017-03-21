//
//  SNSensor.h
//  sdk-demo
//
//  Created by User on 16/3/4.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNSensor : NSObject

/**
 *  传感器Sensor编号
 */
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *device_id;

@property (nonatomic, copy) NSString *user_id;

/**
 *  传感器Sensor类型
 */
@property (nonatomic, copy) NSString *type;

/**
 *  传感器Sensor的名字
 */
@property (nonatomic, copy) NSString *title;

/**
 *  传感器Sensor的描述
 */
@property (nonatomic, copy) NSString *about;

@property (nonatomic, copy) NSString *tags;

@property (nonatomic, copy) NSString *unit_name;

@property (nonatomic, copy) NSString *unit_symbol;

@property (nonatomic, copy) NSString *update_time;

@property (nonatomic, copy) NSString *create_time;

/**
 *  图标
 */
@property (nonatomic, copy) NSString *s_icon;

/**
 *  位置
 */
@property (nonatomic, copy) NSString *s_position;

/**
 *  使用计量费用
 */
@property (nonatomic, copy) NSString *su_price;

/**
 *  使用计量基数
 */
@property (nonatomic, copy) NSString *su_measure;

@end
