//
//  SNSmartLink601.h
//  ScinanSDK-iOS
//
//  Created by User on 2016/11/3.
//  Copyright © 2016年 felixlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SNSmartLink601Delegate <NSObject>

- (void)smartLink601SuccessWithDeviceID:(NSString *)deviceID type:(NSString *)type;

@optional
- (void)smartLink601FailureWithError:(NSError *)error;

@end

@interface SNSmartLink601 : NSObject

- (void)configWithPassword:(NSString *)password companyID:(NSString *)companyID types:(NSArray<NSString *> *)types timeout:(NSInteger)timeout;

- (void)stop;

@property (nonatomic, assign) id<SNSmartLink601Delegate> delegate;

@end
