//
//  XLDevice.h
//  xlzj
//
//  Created by 周绪刚 on 16/7/12.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLDevice : NSObject
/** lkc400 (用来索引设备,单独访问时,传入此参数)*/
@property (nonatomic ,copy) NSString *strIndex;
/** 客厅 */
@property (nonatomic ,copy) NSString *strDevName;
/** CE-1C0 */
@property (nonatomic ,copy) NSString *strEdition;
/** R0.01.01 */
@property (nonatomic ,copy) NSString *strVersion;
/** 00100101221021(设备唯一串号) */
@property (nonatomic ,copy) NSString *strSN;
/** 0 - Full Link(Cloud) 删除操作要从 DMI 和司南同时删除, 1 - Half Link (Only Local),删除只需要 DMI 删除,不能分享设备，只能分享截图到朋友圈 */
@property (nonatomic ,assign) int linkType;
/** UI 显示要除以 2 */
@property (nonatomic ,assign) int valTemp;
/** 相对湿度 */
@property (nonatomic ,assign) int valRH;
/** UI 显示要除以 2 */
@property (nonatomic ,assign) int valExprTemp;
/** 0:恒温模式; 1:节能模式; 2:离家模式 */
@property (nonatomic ,assign) int valWorkMode;
/** 0:制热模式; 1:制冷模式; 2:换气模式 */
@property (nonatomic ,assign) int valRunMode;
/** 0:小风模式; 1:中风模式; 2:大风模式 */
@property (nonatomic ,assign) int valFanSpeed;
/** 
  * 1~9,对室内环境的评价描述
  * 1.干冷    2.偏冷    3.湿冷    4.干燥    5.舒适    6.潮湿    7.干热    8.偏热    9.湿热
 */
@property (nonatomic ,assign) int eqDesc;
/** 温度评价,0~100,分别是冷~热.可换算成 UI 指针偏转角度 */
@property (nonatomic ,assign) int eqTemperature;
/** 湿度评价,0~100,分别是干~湿.可换算成 UI 指针偏转角度 */
@property (nonatomic ,assign) int eqHumidity;
/** 设备是否在线(连接状态,0-离线,1-在线,2-连接中) */
@property (nonatomic ,assign) int stConnect;
/** 设备是否被锁(对应锁的图标,0-未锁定,1-锁定) */
@property (nonatomic ,assign) int stLock;
/** 设备是否开始工作(对应电源图标,0-未开机,1-已开机) */
@property (nonatomic ,assign) int stPower;
/** 105F8C882B0001CA */
@property (nonatomic, copy) NSString *devId;

/** 设备固件类型(最新版本) */
@property (nonatomic ,assign) int fwType;
/** 设备新固件版本号(更新设备固件) */
@property (nonatomic, copy) NSString *fwVersion;

/** cellIcon */
@property (nonatomic ,strong) UIImage *cellIcon;


@property (nonatomic, copy) NSString *deviceID;
@property (nonatomic, copy) NSString *deviceType;
@end
