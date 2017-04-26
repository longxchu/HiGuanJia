//
//  SNLog.h
//  sdk-demo
//
//  Created by User on 16/3/29.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNLog : NSObject

/**
 *  是否显示Log
 */
+ (void)isShowLog:(BOOL)isShow;

/**
 *  显示Log
 */
+ (void)log:(NSString *)formatStr, ...;

/**
 *  发送log
 */
+ (void)saveLog:(NSString *)log;

/**
 *  获取服务器保存Log的开关
 */
+ (void)getLogSwitch:(void (^)(BOOL isOn))logSwitch;

@end
