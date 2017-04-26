//
//  XLWeather.h
//  xlzj
//
//  Created by zhouxg on 16/6/13.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XLWeather_weather;
@class XLWeatherInfo;

@interface XLWeather : NSObject
@property (nonatomic ,strong) NSArray<XLWeather_weather *> *weather;
@end

@interface XLWeather_weather : NSObject
// 时间
@property (nonatomic, copy) NSString *date;
// 天气模型
@property (nonatomic ,strong) XLWeatherInfo *info;
@end

@interface XLWeatherInfo : NSObject
// 夜晚
@property (nonatomic ,strong) NSArray *night;
// 白天
@property (nonatomic ,strong) NSArray *day;
@end