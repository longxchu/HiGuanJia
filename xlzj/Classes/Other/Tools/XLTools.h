//
//  XLTools.h
//  xlzj
//
//  Created by zhouxg on 16/5/19.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLTools : NSObject
/**
 *颜色转图片
 **/
+ (UIImage*)createImageWithColor: (UIColor*) color needRect:(CGRect)rect;
/**
 * NSDate转成格式化的字符串
 * 本app中所有的data都需要经过这个方法转
 **/
+ (NSString*)formatterStringWithDate:(NSDate *)date;
@end
