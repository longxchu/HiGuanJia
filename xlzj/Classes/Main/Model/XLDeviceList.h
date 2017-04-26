//
//  XLDeviceList.h
//  xlzj
//
//  Created by 周绪刚 on 16/7/12.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XLDevice;

@interface XLDeviceList : NSObject
/** 0 */
@property (nonatomic ,assign) int retCode;
/** RET_DEV_LIST */
@property (nonatomic, copy) NSString *retMsg;
/** 模型对象 */
@property (nonatomic ,strong) XLDevice *device;
/** 数组存放 XLDevice 对象 */
@property (nonatomic ,strong) NSMutableArray *retData;
@end
