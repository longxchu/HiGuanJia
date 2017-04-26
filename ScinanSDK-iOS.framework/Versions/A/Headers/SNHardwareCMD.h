//
//  SNHardwareCMD.h
//  sdk-demo
//
//  Created by User on 16/3/19.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNHardwareCMD : NSObject

/**
 *  设备ID
 */
@property (nonatomic, copy) NSString *deviceID;

/**
 *  sensorID
 */
@property (nonatomic, copy) NSString *sensorID;

/**
 *  数据
 */
@property (nonatomic, copy) NSString *data;

- (instancetype)initWithString:(NSString *)string;

- (NSString *)toSting;

@end
