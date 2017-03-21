//
//  SNAirKissConfig.h
//  JMAirKissDemo
//
//  Created by User on 2016/11/1.
//  Copyright © 2016年 shengxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SNAirKissConfigDelegate <NSObject>

- (void)airKissConfigSuccessWithDeviceID:(NSString *)deviceID type:(NSString *)type;

@optional
- (void)airKissConfigFailureWithError:(NSError *)error;

@end

@interface SNAirKissConfig : NSObject

- (void)configWithPassword:(NSString *)password companyID:(NSString *)companyID types:(NSArray<NSString *> *)types timeout:(NSInteger)timeout;

- (void)stop;

@property (nonatomic, assign) id<SNAirKissConfigDelegate> delegate;

@end
