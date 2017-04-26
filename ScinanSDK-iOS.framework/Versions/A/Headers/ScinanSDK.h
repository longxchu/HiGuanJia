//
//  ScinanSDK.h
//  ScinanSDK-iOS
//
//  Created by User on 16/5/5.
//  Copyright © 2016年 felixlin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SNAPI.h"
#import "SNMqtt.h"
#import "SNAccount.h"
#import "SNAPConfig.h"
#import "SNSmartLink601.h"
#import "SNDatabase.h"
#import "SNLog.h"
#import "SNTool.h"
#import "SNNetworking.h"
#import "SNAPI+Food.h"
#import "SNAirKissConfig.h"

@interface ScinanSDK : NSObject

/**
 *  获取厂商ID
 */
+ (NSString *)getCompanyID;

@end
