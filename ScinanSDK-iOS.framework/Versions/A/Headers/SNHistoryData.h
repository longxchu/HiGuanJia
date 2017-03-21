//
//  SNHistoryData.h
//  ScinanSDK
//
//  Created by User on 16/4/13.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNHistoryData : NSObject

/**
 *  设备ID
 */
@property (nonatomic, copy) NSString *device_id;

/**
 *  设备类型
 */
@property (nonatomic, copy) NSString *device_type;

@property (nonatomic, copy) NSString *device_model;

/**
 *  设备名称
 */
@property (nonatomic, copy) NSString *device_title;

/**
 *  Sensor ID
 */
@property (nonatomic, copy) NSString *sensor_id;

/**
 *  数据类型(1:开关 2:状态 3:告警)
 */
@property (nonatomic, copy) NSString *message_type;

/**
 *  历史数据
 */
@property (nonatomic, copy) NSString *content;

/**
 *  时间
 */
@property (nonatomic, copy) NSString *create_time;

/**
 *  时间，把create_time转成NSDate类型
 */
@property (nonatomic, strong) NSDate *createDtae;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *data;

@property (nonatomic, copy) NSString *time_data;

@end
