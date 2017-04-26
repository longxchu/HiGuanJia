//
//  SNAPI+qianpa.h
//  ScinanSDK-iOS
//
//  Created by User on 16/8/22.
//  Copyright © 2016年 felixlin. All rights reserved.
//

#import "SNAPI.h"

@interface SNAPI (qianpa)

/**
 *  千帕首页设备跑马灯
 */
+ (void)qianpaKpaListWithDeviceType:(NSString *)type pageSize:(NSInteger)pageSize success:(void (^)(NSArray *resultData))success failure:(void (^)(NSError *error))failure;

/**
 *  千帕首页菜谱跑马灯
 */
+ (void)qianpaMarqueeWithDeviceType:(NSString *)type pageSize:(NSInteger)pageSize success:(void (^)(NSArray *foodList))success failure:(void (^)(NSError *error))failure;

/**
 *  菜谱分类
 */
+ (void)qianpaMenuCategoryWithDeviceType:(NSString *)type success:(void (^)(NSArray *resultData))success failure:(void (^)(NSError *error))failure;

/**
 *  获取首页菜谱列表
 */
//+ (void)qianpaMenuListWithDeviceType:(NSString *)type pageSize:(NSString *)size pageNumber:(NSInteger)number categoryID:(NSString *)categoryID success:(void (^)(NSArray *foodList, NSInteger rows, NSInteger start))success failure:(void (^)(NSError *error))failure;
+ (void)qianpaMenuListWithDeviceType:(NSString *)type pageSize:(NSString *)size pageNumber:(NSInteger)number categoryID:(NSString *)categoryID menuType:(NSString *)menuType success:(void (^)(NSArray *foodList, NSInteger rows, NSInteger start))success failure:(void (^)(NSError *error))failure;

/**
 *  获取菜谱详情
 *
 *  @param menuID  菜谱ID
 */
+ (void)qianpaMenuDetailWithMenuID:(NSString *)menuID success:(void (^)(SNFood *food))success failure:(void (^)(NSError *error))failure;

/**
 *  菜谱控制(启动)
 */
+ (void)qianpaControlWithDeviceID:(NSString *)deviceID type:(int)type sensorID:(NSString *)sensorID foodMenuID:(NSString *)menuID runCommand:(NSString *)runCommand success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  一键烹饪<启动>[千帕锅]
 */
+ (void)qianpaPanControlWithDeviceID:(NSString *)deviceID type:(int)type sensorID:(NSString *)sensorID foodMenuID:(NSString *)menuID workStatus:(NSString *)workStatus cookModel:(NSString *)cookModel kgID:(NSString *)kgID runCommand:(NSString *)runCommand algorithmType:(NSString *)algorithmType success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  食谱使用记录
 */
+ (void)qianpaUselogWithDeviceType:(NSString *)type pageSize:(NSString *)size pageNumber:(NSInteger)number categoryID:(NSString *)categoryID success:(void (^)(NSArray *logs, NSInteger rows, NSInteger start))success failure:(void (^)(NSError *error))failure;

/**
 *  自定义菜谱添加
 */
+ (void)qianpaAddMenuWithMenuName:(NSString *)menuName categoryID:(NSString *)categoryID material:(NSArray *)material description:(NSString *)description image:(UIImage *)image deviceType:(NSString *)type runCommand:(NSString *)runCommand success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  自定义菜谱修改
 */
+ (void)qianpaUpdateMenuWithMemuID:(NSString *)menuID menuName:(NSString *)menuName categoryID:(NSString *)categoryID material:(NSArray *)material description:(NSString *)description image:(UIImage *)image DeviceType:(NSString *)type runCommand:(NSString *)runCommand success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  修改收藏菜谱命令信息
 */
+ (void)qianpaUpdateFavoriteInfoWithID:(NSString *)ID menuType:(NSString *)menuType runCommand:(NSString *)runCommand success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  修改模块密码
 */
+ (void)qianpaModifyModulePasswordWithDeviceID:(NSString *)deviceID password:(NSString *)password oldPassword:(NSString *)oldPassword success:(void (^)())success failure:(void (^)(NSError *error))failure;

// 添加设备
+ (void)qianpaDeviceAddWithDeviceID:(NSString *)deviceID title:(NSString *)title type:(NSString *)type model:(NSString *)model productID:(NSString *)productID hardwareVersion:(NSString *)version modulePassword:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure;

// 获取设备列表
+ (void)qianpaDeviceLiseSuccess:(void (^)(NSArray *deviceList))success failure:(void (^)(NSError *error))failure;

// 验证模块密码
+ (void)qianpaVerifyModulePasswordWithDeviceID:(NSString *)deviceID password:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure;

// 获取菜谱类别所对应的功能算法列表
+ (void)qianpaAlgorithmWithDeviceType:(NSString *)deviceType categoryID:(NSString *)categoryID success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

// 获取启动菜谱
+ (void)qianpaGetStartMenuIDSuccess:(void (^)(NSString *menuID))success failure:(void (^)(NSError *error))failure;

// 设置启动菜谱
+ (void)qianpaSetStartMenuID:(NSString *)menuID success:(void (^)(NSString *menuID))success failure:(void (^)(NSError *error))failure;

// 获取菜谱收藏列表
+ (void)qianpaFavoriteListWithDeviceType:(NSString *)deviceType pageSize:(NSString *)size pageNumber:(NSInteger)number categoryID:(NSString *)categoryID success:(void (^)(NSArray *foodList, NSInteger rows))success failure:(void (^)(NSError *error))failure;
@end
