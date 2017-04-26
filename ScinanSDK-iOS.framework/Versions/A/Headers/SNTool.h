//
//  SNTool.h
//  sdk-demo
//
//  Created by User on 16/3/29.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SNTool : NSObject

/**
 *  获取当前网络的SSID
 */
+ (NSString *)SSID;

/**
 *  获取系统设备型号
 */
+ (NSString *)getDeviceModel;

/**
 *  获取网络状态
 */
+ (NSString *)getNetWorkStates;

@end
