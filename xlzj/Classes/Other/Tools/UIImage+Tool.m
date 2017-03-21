//
//  UIImage+Tool.m
//  xlzj
//
//  Created by zhouxg on 16/6/7.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "UIImage+Tool.h"

@implementation UIImage (Tool)

+ (UIImage *)imageWithWeatherStr:(NSString *)weatherStr
{
    if ([weatherStr rangeOfString:@"雪"].location != NSNotFound && [weatherStr rangeOfString:@"多云"].location != NSNotFound)
    {
        return [UIImage imageNamed:@"weather_cloudy_snow"];
    }
    else if ([weatherStr rangeOfString:@"雨"].location != NSNotFound && [weatherStr rangeOfString:@"多云"].location != NSNotFound)
    {
        return [UIImage imageNamed:@"weather_cloudy_rain"];
    }
    else if ([weatherStr rangeOfString:@"雾"].location != NSNotFound || [weatherStr rangeOfString:@"霾"].location != NSNotFound)
    {
        return [UIImage imageNamed:@"weather_fog"];
    }
    else if ([weatherStr rangeOfString:@"雷"].location != NSNotFound && [weatherStr rangeOfString:@"雨"].location != NSNotFound)
    {
        return [UIImage imageNamed:@"weather_ray_rain"];
    }
    else if ([weatherStr rangeOfString:@"雪"].location != NSNotFound)
    {
        return [UIImage imageNamed:@"weather_snow"];
    }
    else if ([weatherStr rangeOfString:@"雨"].location != NSNotFound)
    {
        return [UIImage imageNamed:@"weather_rain"];
    }
    else if ([weatherStr rangeOfString:@"阴"].location != NSNotFound)
    {
        return [UIImage imageNamed:@"weather_yin"];
    }
    else if ([weatherStr rangeOfString:@"多云"].location != NSNotFound)
    {
        return [UIImage imageNamed:@"weather_cloudy"];
    }
    else if ([weatherStr rangeOfString:@"晴"].location != NSNotFound)
    {
        return [UIImage imageNamed:@"weather_sunny"];
    }
    
    return 0;
}
@end
