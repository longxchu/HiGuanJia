//
//  XLTools.m
//  xlzj
//
//  Created by zhouxg on 16/5/19.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLTools.h"

@implementation XLTools
+ (UIImage*) createImageWithColor: (UIColor*) color needRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return theImage;
}
+ (NSString*)formatterStringWithDate:(NSDate *)date
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy_MM_dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString * dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}
@end
