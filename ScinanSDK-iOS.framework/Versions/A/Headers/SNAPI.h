//
//  SNAPI.h
//  sdk-demo
//
//  Created by User on 16/3/19.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SNUser.h"
#import "SNResult.h"
#import "SNDevice.h"
#import "SNSensor.h"
#import "SNFood.h"
#import "SNHistoryData.h"
#import "SNScene.h"
#import "SNAction.h"
#import "SNArticle.h"

@interface SNAPI : NSObject

#pragma mark - 初始化

/**
 *  初始化
 *
 *  @param isformalServer 是否连接正式服务器(0:连接测试服务器，1:连接正式服务器)
 *  @param companyID      厂商ID
 *  @param debugKey       测试服务器的APP Key
 *  @param debugSecret    测试服务器的APP Secret
 *  @param releaseKey     正式服务器的APP Key
 *  @param releaseSecret  正式服务器的APP Secret
 */
+ (void)initWithIsFormalServer:(BOOL)isformalServer companyID:(NSString *)companyID debugAPPKey:(NSString *)debugKey debugAPPSecret:(NSString *)debugSecret releaseAPPKey:(NSString *)releaseKey releaseAPPSecret:(NSString *)releaseSecret;

/**
 *  设置语言
 */
+ (void)setLanguage:(NSString *)language;

/**
 *  统一处理成功
 */
+ (void)setSuccessHanlder:(void (^)(SNResult *result))hanlder;

/**
 *  统一处理失败
 */
+ (void)setFailureHanlder:(void (^)(NSError *error))hanlder;

#pragma mark - 用户管理

/**
 *  登录
 *
 *  @param account  账号
 *  @param password 密码
 *  @param areaCode 地区编码
 */
+ (void)userLoginWithAccount:(NSString *)account password:(NSString *)password areaCode:(NSString *)areaCode success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  登录(同步)
 *
 *  @param account  账号
 *  @param password 密码
 *  @param areaCode 地区编码
 */
+ (void)userLoginSynchronousWithAccount:(NSString *)account password:(NSString *)password areaCode:(NSString *)areaCode success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  快速登录
 *
 *  @param moblile      手机号
 *  @param validCode    短信验证码
 *  @param areaCode     地区编码
 *  @param ticket       短信验证ticket
 */
+ (void)userLoginFastWithMobile:(NSString *)moblile validCode:(NSString *)validCode areaCode:(NSString *)areaCode ticket:(NSString *)ticket success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  邮箱注册
 *
 *  @param email        Email账号
 *  @param password     密码
 *  @param type         用户类型(0：不能登陆web；1：可以登陆web)(可选)
 *  @param qqOpenid     绑定的 qq openid(可选)
 *  @param userName     用户名(可选)
 *  @param userNickName 用户昵称(可选)
 */
+ (void)userRegisterEmail:(NSString *)email password:(NSString *)password type:(int)type qqOpenid:(NSString *)qqOpenid userName:(NSString *)userName userNickName:(NSString *)userNickName success:(void (^)(NSString *userDigit))success failure:(void (^)(NSError *error))failure;

/**
 *  手机注册
 *
 *  @param email     Email账号(可选)
 *  @param password  密码
 *  @param type      用户类型(0：不能登陆web；1：可以登陆web)(可选)
 *  @param ticket    短信验证ticket
 *  @param validCode 短信验证码
 */
+ (void)userRegisterMobileWithEmail:(NSString *)email password:(NSString *)password type:(int)type ticket:(NSString *)ticket validCode:(NSString *)validCode success:(void (^)(NSString *userDigit))success failure:(void (^)(NSError *error))failure;

/**
 *  修改密码
 *
 *  @param password    新密码
 *  @param oldPassword 旧密码
 */
+ (void)userModifyPassword:(NSString *)password oldPassword:(NSString *)oldPassword success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  修改用户基本信息
 *
 *  @param address  用户地址(可选)
 *  @param phone    用户电话(可选)
 *  @param nickname 用户名字(可选)
 *  @param sex      性别(可选)
 */
+ (void)userModifyBaseWithUserAddress:(NSString *)address userPhone:(NSString *)phone userNickname:(NSString *)nickname userSex:(NSString *)sex success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  获取用户基本信息
 */
+ (void)userInfoSuccess:(void (^)(SNUser *user))success failure:(void (^)(NSError *error))failure;

/**
 *  绑定手机号码
 *
 *  @param ticket    短信验证ticket
 *  @param validCode 短信验证码
 */
+ (void)userBindMobileWithTicket:(NSString *)ticket validCode:(NSString *)validCode success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  绑定Email
 *
 *  @param email   Email
 */
+ (void)userBindEmail:(NSString *)email success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  绑定QQ
 *
 *  @param qqOpenID qq_openid
 */
+ (void)userBindQQOpenID:(NSString *)qqOpenID success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  解绑QQ
 */
+ (void)userUnbindQQSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  使用邮箱重置密码
 *
 *  @param email   邮箱
 */
+ (void)userForgotPasswordEmail:(NSString *)email success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  使用手机号码重置密码
 *
 *  @param password   密码
 *  @param ticket     短信验证ticket
 *  @param valideCode 短信验证码
 */
+ (void)userForgotPasswordMobilWithPassword:(NSString *)password ticket:(NSString *)ticket validCode:(NSString *)valideCode success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  设置用户头像
 *
 *  @param image    用户头像图片
 *  @param nickName 用户昵称(可选)
 */
+ (void)userAvatar:(UIImage *)image nickName:(NSString *)nickName success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  绑定iPhone设备和用户
 *
 *  @param ticket  iPhone的ticket
 */
+ (void)userBindiPhoneToken:(NSString *)ticket success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  清除iOS推送的离线消息个数
 *
 *  @param ticket  iPhone的ticket
 */
+ (void)userCleariPhonePushWithTicket:(NSString *)ticket success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  换票
 */
+ (void)userRefreshTokenSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  换票(同步)
 */
+ (void)userRefreshTokenSynchronousSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;

#pragma mark - 设备管理

/**
 *  获取设备列表
 */
+ (void)deviceLiseSuccess:(void (^)(NSArray *deviceList))success failure:(void (^)(NSError *error))failure;

/**
 *  获取设备列表(同步)
 */
+ (void)deviceLiseSynchronousSuccess:(void (^)(NSArray *deviceList))success failure:(void (^)(NSError *error))failure;

/**
 *  添加设备
 *
 *  @param deviceID  设备Device编号
 *  @param title     设备名称(可选)
 *  @param type      设备类型
 *  @param model     设备型号(可选)
 *  @param productID 厂商自定义设备ID(可选)
 *  @param version   厂商固件版本号(可选)
 */
+ (void)deviceAddWithDeviceID:(NSString *)deviceID title:(NSString *)title type:(NSString *)type model:(NSString *)model productID:(NSString *)productID hardwareVersion:(NSString *)version success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  修改设备
 *
 *  @param deviceID 设备Device编号
 *  @param title    设备名称
 *  @param about    设备介绍(可选)
 *  @param tags     标签(可选)
 */
+ (void)deviceModifyWithDeviceID:(NSString *)deviceID title:(NSString *)title about:(NSString *)about tags:(NSString *)tags success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  删除设备
 *
 *  @param deviceID 设备Device编号
 */
+ (void)deviceDeleteWithDeviceID:(NSString *)deviceID success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  设置设备图片
 *
 *  @param deviceID 设备Device编号
 *  @param image    设备图片
 */
+ (void)deviceImage:(UIImage *)image deviceID:(NSString *)deviceID success:(void (^)(NSString *imageURL))success failure:(void (^)(NSError *error))failure;

/**
 *  获取设备详情
 *
 *  @param device  Device对象
 *  @param success 返回一个新的Device对象
 */
+ (void)deviceStatusWithDevice:(SNDevice *)device Success:(void (^)(SNDevice *device))success failure:(void (^)(NSError *error))failure;

/**
 *  设备分享
 *
 *  @param deviceID 分享的设备ID
 *  @param mobile   分享到的手机号码或邮箱地址
 *  @param areaCode 国家地区代码(Mobile为手机号时必填)
 */
+ (void)deviceShareWithDeviceID:(NSString *)deviceID mobile:(NSString *)mobile areaCode:(NSString *)areaCode success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  获取设备分享列表
 *
 *  @param deviceID 分享的设备ID
 */
+ (void)deviceShareListWithDeviceID:(NSString *)deviceID success:(void (^)(NSArray *shareList))success failure:(void (^)(NSError *error))failure;

/**
 *  删除分享的设备
 *
 *  @param deviceID 分享的设备ID
 *  @param userID   删除的目标用户ID
 */
+ (void)deviceShareDeleteWithDeviceID:(NSString *)deviceID targetUserID:()userID success:(void (^)())success failure:(void (^)(NSError *error))failure;

#pragma mark - Sensor管理

/**
 *  获取Sensor列表
 *
 *  @param deviceID 设备Device编号
 *  @param type     Sensor类型(可选)
 */
+ (void)sensorListWithDeviceID:(NSString *)deviceID sensorType:(NSString *)type success:(void (^)(NSArray *sensorList))success failure:(void (^)(NSError *error))failure;

/**
 *  发送操作命令
 *
 *  @param deviceID 设备Device编号
 *  @param sensorID 传感器Sensor编号
 *  @param type     传感器Sensor类型
 *  @param data     设置的值，根据传感器和设置类型的不同，分为不同格式。如："control_data":{"value":0.555}
 */
+ (void)sensorControlWithDeviceID:(NSString *)deviceID sensorID:(NSString *)sensorID sensorType:(NSString *)type contolData:(NSString *)data success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  发送操作命令(sensor_type为1，contro_data的格式为{"value":xx})
 *
 *  @param deviceID 设备Device编号
 *  @param sensorID 传感器Sensor编号
 *  @param value    {"value":xx} value为xx的智
 */
+ (void)sensorControlWithDeviceID:(NSString *)deviceID sensorID:(NSString *)sensorID value:(NSString *)value success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  增加Sensor
 *
 *  @param deviceID 设备Device编号
 *  @param sensorID 传感器Sensor编号
 *  @param type     传感器Sensor类型
 *  @param name     传感器名称
 *  @param icon     传感器图片(可选)
 *  @param position 传感器位置(可选)
 *  @param price    传感器使用数据基本费用(可选)
 *  @param measure  传感器使用基本计量基数(可选)
 */
+ (void)sensorAddWithDeviceID:(NSString *)deviceID sensorID:(NSString *)sensorID type:(NSString *)type name:(NSString *)name icon:(UIImage *)icon position:(NSString *)position price:(NSString *)price measure:(NSString *)measure success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  修改Sensor
 *
 *  @param deviceID 设备Device编号
 *  @param sensorID 传感器Sensor编号
 *  @param type     传感器Sensor类型
 *  @param name     传感器名称
 *  @param icon     传感器图片(可选)
 *  @param position 传感器位置(可选)
 *  @param price    传感器使用数据基本费用(可选)
 *  @param measure  传感器使用基本计量基数(可选)
 */
+ (void)sensorUpdateWithDeviceID:(NSString *)deviceID sensorID:(NSString *)sensorID type:(NSString *)type name:(NSString *)name icon:(UIImage *)icon position:(NSString *)position price:(NSString *)price measure:(NSString *)measure success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  删除Sensor
 *
 *  @param deviceID 设备Device编号
 *  @param sensorID 传感器Sensor编号
 */
+ (void)sensorDeleteWithDeviceID:(NSString *)deviceID sensorID:(NSString *)sensorID success:(void (^)())success failure:(void (^)(NSError *error))failure;

#pragma mark - 公共接口

/**
 *  请求发送短信验证码
 *
 *  @param mobile   目标手机号码
 *  @param type     类型，0：默认类型；1：用户注册时手机用户已存在提示；2：绑定操作时手机用户不存在提示
 *  @param areaCode 区号，支持国外手机传区号，不支持则传“86”
 */
+ (void)commonMessageValidWithMobile:(NSString *)mobile type:(NSInteger)type areaCode:(NSString *)areaCode success:(void (^)(NSString * ticket))success failure:(void (^)(NSError *error))failure;

/**
 *  跳转到厂商商城
 */
+ (void)commonMarketSuccess:(void (^)(NSString *htmlString))success failure:(void (^)(NSError *error))failure;

#pragma mark - 第三方相关

typedef NS_ENUM(NSInteger, SNThirdpartyType) {
    SNThirdpartyTypeQQ          = 1,
    SNThirdpartyTypeWechat      = 2,
    SNThirdpartyTypeSina        = 3
};

/**
 *  第三方用户授权验证
 *
 *  @param type     第三方用户类型
 *  @param openID   第三方用户openid
 */
+ (void)thirdpartyCheckWithThirdpartyType:(SNThirdpartyType)type openID:(NSString *)openID success:(void (^)(BOOL isBind))success failure:(void (^)(NSError *error))failure;

/**
 *  第三方用户快速注册或绑定
 *
 *  @param type         第三方用户类型
 *  @param openID       第三方用户openid
 *  @param mobile       用户手机号
 *  @param validCode    短信验证码
 *  @param ticket       短信验证ticket
 *  @param name         第三方用户昵称
 *  @param avatarUrl    第三方用户头像url
 *  @param password     用户密码
 */
+ (void)thirdpartyRegisterWithThirdpartyType:(SNThirdpartyType)type openID:(NSString *)openID mobile:(NSString *)mobile validCode:(NSString *)validCode ticket:(NSString *)ticket userNickname:(NSString *)name avatarUrl:(NSString *)avatarUrl password:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  第三方用户绑定已经存在账号
 *
 *  @param type         第三方用户类型
 *  @param openID       第三方用户openid
 *  @param account      帐号
 *  @param password     帐号密码
 */
+ (void)thirdpartyBindWithThirdpartyType:(SNThirdpartyType)type openID:(NSString *)openID account:(NSString *)account password:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure;

#pragma mark - 版本升级

/**
 *  APP版本升级
 *
 *  @param version 版本号
 *  @param os      操作系统
 */
+ (void)updateAPPWithVersionCode:(NSString *)version os:(NSString *)os success:(void (^)(NSDictionary *resuleDta))success failure:(void (^)(NSError *error))failure;

/**
 *  模组固件版本升级
 *
 *  @param deviceID 设备编号
 */
+ (void)updateHardwareWithDeviceID:(NSString *)deviceID success:(void (^)(NSDictionary *resuleDta))success failure:(void (^)(NSError *error))failure;

/**
 *  设备厂商固件版本升级
 *
 *  @param companyID 厂商ID
 *  @param type      设备类型
 *  @param model     设备型号
 */
+ (void)updateVendorWithCompanyID:(NSString *)companyID deviceType:(NSString *)type deviceModel:(NSString *)model success:(void (^)(NSDictionary *resuleDta))success failure:(void (^)(NSError *error))failure;

#pragma mark - 数据接口

/**
 *  获取功率历史数据
 *
 *  @param deviceID   设备Device编号
 *  @param sensorID   传感器Sensor编号
 *  @param sensorType 传感器Sensor类型
 *  @param dataType   请求数据类型
 *  @param date       日期
 */
+ (void)dataPowerWithDeviceID:(NSString *)deviceID sensorID:(NSString *)sensorID sensorType:(NSString *)sensorType dataType:(NSString *)dataType date:(NSString *)date success:(void (^)(NSArray *dataList))success failure:(void (^)(NSError *error))failure;

/**
 *  获取设备历史数据
 *
 *  @param deviceID   设备Device编号
 *  @param sensorID   传感器Sensor编号
 *  @param page       当前分页数(默认为1)(可选)
 *  @param date       请求的数据时间(默认为当天)(日期格式：YYYY-MM-DD)(可选)
 */
+ (void)dataHistoryWithDeviceID:(NSString *)deviceID sensorID:(NSString *)sensorID page:(NSString *)page date:(NSString *)date success:(void (^)(NSArray *dataList))success failure:(void (^)(NSError *error))failure;

/**
 *  获取操作历史数据
 *
 *  @param deviceID   设备Device编号
 *  @param sensorID   传感器Sensor编号
 *  @param dataType   类型
 *  @param page       当前分页数(默认为1)(可选)
 *  @param timeID    定时器ID(可选)

 */
+ (void)dataControlWithDeviceID:(NSString *)deviceID sensorID:(NSString *)sensorID sensorType:(NSString *)sensorType dataType:(NSString *)dataType FType:(NSString *)f_type page:(NSString *)page timerID:(NSString *)timeID success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

#pragma mark - GPS接口

/**
 *  获取电子围栏信息
 *
 *  @param deviceID   设备Device编号
 *  @param sensorID   传感器Sensor编号
 *  @param sensorType 传感器Sensor类型
 */
+ (void)gpsFenceWithDeviceID:(NSString *)deviceID sensorID:(NSString *)sensorID sensorType:(NSString *)sensorType success:(void (^)(NSArray *fenceList))success failure:(void (^)(NSError *error))failure;

#pragma mark - 天气接口

/**
 *  获取空气质量
 *
 *  @param cityID  城市ID(若没有传入请求参数，根据客户端的IP地址自动匹配城市)(可选)
 *  @param ip      ip(可选)
 */
+ (void)weatherAirQualityWithCityID:(NSString *)cityID ip:(NSString *)ip success:(void (^)(NSDictionary *quality))success failure:(void (^)(NSError *error))failure;

#pragma mark - 433接口

/**
 *  分组-修改名称
 *
 *  @param deviceID 设备Device编号
 *  @param groupID  分组编号
 *  @param name     分组名称
 *  @param ext      扩展字段(可选)
 */
+ (void)lightBetaGroupModifyWithDeviceID:(NSString *)deviceID groupID:(NSString *)groupID groupName:(NSString *)name ext:(NSString *)ext success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  分组-查询
 *
 *  @param deviceID  设备Device编号
 *  @param groupID   分组编号(可选)
 *  @param sub       是否包含组内元素(1包含；其他不包含)(可选)
 *  @param onlySwith 仅仅查询分组下面的开关(1是；其他否)(可选)
 */
+ (void)lightBetaGroupListWithDeviceID:(NSString *)deviceID groupID:(NSString *)groupID sub:(NSString *)sub onlySwith:(NSString *)onlySwith success:(void (^)(NSArray *gropList))success failure:(void (^)(NSError *error))failure;

/**
 *  面板-修改属性
 *
 *  @param deviceID     设备Device编号
 *  @param controllerID 面板编号
 *  @param name         面板的名称
 */
+ (void)lightBetaControllerModifyWithDeviceID:(NSString *)deviceID controllerID:(NSString *)controllerID controllerName:(NSString *)name success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  面板-查询详情
 *
 *  @param deviceID     设备Device编号
 *  @param controllerID 面板编号(可选)
 *  @param code         底板的433ID(与上面参数，必填一个)
 */
+ (void)lightBetaControllerGetWithDeviceID:(NSString *)deviceID controllerID:(NSString *)controllerID controllerCode:(NSString *)code success:(void (^)(NSDictionary *controller))success failure:(void (^)(NSError *error))failure;

/**
 *  上传背景图片
 *
 *  @param image   图片
 *  @param groupID 分组ID
 */
+ (void)lightBetaImage:(UIImage *)image groupID:(NSString *)groupID success:(void (^)(NSString *imageURL))success failure:(void (^)(NSError *error))failure;

/**
 *  开关-修改名称
 *
 *  @param deviceID 设备Device编号
 *  @param switchID 开关唯一ID
 *  @param name     开关的名称(可选)
 */
+ (void)lightBetaSwitchModifyWithDeviceID:(NSString *)deviceID switchID:(NSString *)switchID switchName:(NSString *)name success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  开关-批量设置常用开关
 *
 *  @param deviceID 设备Device编号
 *  @param IDsOn    批量设置（多个ID逗号分割）
 *  @param IDsOff   批量取消（多个ID逗号分割）(可选)
 *  @param code     底板的组id
 */
+ (void)lightBetaSwitchBatchflagWithDeviceID:(NSString *)deviceID IDsOn:(NSString *)IDsOn IDsOff:(NSString *)IDsOff groupCode:(NSString *)code success:(void (^)())success failure:(void (^)(NSError *error))failure;

#pragma mark - 灯接口

/**
 *  场景-修改属性
 *
 *  @param deviceID 设备Device编号
 *  @param groupID  分组编号
 *  @param name     场景名称
 *  @param ext      扩展字段（图标id）(可选)
 */
+ (void)lightGroupModifyWithDeviceID:(NSString *)deviceID groupID:(NSString *)groupID groupName:(NSString *)name ext:(NSString *)ext success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  场景-查询
 *
 *  @param deviceID  设备Device编号
 *  @param groupID   分组编号(可选)
 *  @param sub       是否包含组内元素：1包含；其他不包含(可选)
 */
+ (void)lightGroupListWithDeviceID:(NSString *)deviceID groupID:(NSString *)groupID sub:(NSString *)sub success:(void (^)(NSArray *gropList))success failure:(void (^)(NSError *error))failure;

/**
 *  场景-新增
 *
 *  @param deviceID 设备Device编号
 *  @param name     场景名称
 *  @param ext      扩展字段（图标id）(可选)
 */
+ (void)lightGroupAddDeviceID:(NSString *)deviceID groupName:(NSString *)name ext:(NSString *)ext success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  场景-删除
 *
 *  @param deviceID  设备Device编号
 *  @param groupID   场景唯一ID（数据库的）
 */
+ (void)lightGroupDeleteWitchDeviceID:(NSString *)deviceID groupID:(NSString *)groupID success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  灯-修改属性
 *
 *  @param deviceID     设备Device编号
 *  @param controllerID 灯编号（数据库的）
 *  @param name         灯的名称
 */
+ (void)lightControllerModifyWithDeviceID:(NSString *)deviceID controllerID:(NSString *)controllerID controllerName:(NSString *)name success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  灯-查询详情
 *
 *  @param deviceID     设备Device编号
 *  @param controllerID 灯id（数据库的）
 *  @param code         灯编号（底板的）(与上面参数，必填一个)
 */
+ (void)lightControllerGetWithDeviceID:(NSString *)deviceID controllerID:(NSString *)controllerID controllerCode:(NSString *)code success:(void (^)(NSDictionary *controller))success failure:(void (^)(NSError *error))failure;

/**
 *  上传场景背景图片
 *
 *  @param image   图片
 *  @param groupID 分组ID
 */
+ (void)lightImage:(UIImage *)image groupID:(NSString *)groupID success:(void (^)(NSString *imageURL))success failure:(void (^)(NSError *error))failure;

#pragma mark - 意见

/**
 *  获取意见反馈类型
 */
+ (void)suggestionTypeListSuccess:(void (^)(NSArray *typeList))success failure:(void (^)(NSError *error))failure;

/**
 *  添加意见反馈
 *
 *  @param content 反馈内容
 *  @param type    反馈类型ID
 *  @param email   电子邮箱(email与mobile二选一)
 *  @param mobile  电话(email与mobile二选一)
 */
+ (void)suggestionAdd:(NSString *)content type:(NSInteger)type email:(NSString *)email mobile:(NSString *)mobile success:(void (^)())success failure:(void (^)(NSError *error))failure;

#pragma mark - 超级APP

/**
 *  获取产品分类
 *
 */
+ (void)smartProductCategorySuccess:(void (^)(NSArray* categoryList))success failure:(void (^)(NSError *error))failure;

/**
 *  获取产品分类 - 二级
 *
 *  @param categoryID   产品id
 */
+ (void)smartProductCategorySecondaryWithCategoryID:(NSString*)categoryID Success:(void (^)(NSArray* categorySecondaryList))success failure:(void (^)(NSError *error))failure;

/**
 *  获取插件下载地址
 */
+ (void)smartProductUpdateWithOS:(NSString*)os andPluginID:(NSString*)pluginID success:(void (^)(NSDictionary *resuleDta))success failure:(void (^)(NSError *error))failure;

/**
 *  获取设备列表
 *
 */
+ (void)smartDeviceListSuccess:(void (^)(NSArray *deviceList))success failure:(void (^)(NSError *error))failure;

/**
 *
 * 获取设备详情（支持子设备）
 * @param   deviceID        设备ID
 * @param   gatewayDeviceID 子设备ID（有此字段，查询的是子设备详情）
 */
+ (void)smartDeviceDetailWithDeviceID:(NSString*)deviceID andGatewayDeviceID:(NSString*)gatewayDeviceID Success:(void (^)(SNDevice*device))success failure:(void (^)(NSError *error))failure;

/**
 *  获取网关中设备列表
 *
 *  @param deviceID 网关的设备id
 */
+ (void)smartGatewaySubdeviceListWithDeviceID:(NSString*)deviceID Success:(void (^)(NSArray *deviceList))success failure:(void (^)(NSError *error))failure;

/**
 *  向网关中添加子设备
 *
 *  @param deviceID         网关的设备id
 *  @param type             设备类型（1：网关发现的，2：添加的）
 *  @param frequency        射频段 （2为2.4G；3为315；4为433；5为红外）
 */
+ (void)smartGatewaySubdeviceAddWithDeviceID:(NSString*)deviceID type:(NSString*)type frequency:(NSString*)frequency typeCode:(NSString*)typeCode subTypeCode:(NSString*)subTypeCode subDeviceID:(NSString *)subDeviceID success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  子设备修改
 *
 *  @param deviceID         网关的设备id
 *  @param gatewayDeviceID  子设备唯一ID（数据库的）
 *  @param subName          子设备名称
 *  @param subDesc          子设备描述
 */
+ (void)smartGatewaySubdeviceEditWithDeviceID:(NSString*)deviceID  andGatewayDeviceID:(NSString*)gatewayDeviceID andSubname:(NSString*)subName andSubDesc:(NSString*)subDesc Success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  子设备删除
 *
 *  @param deviceID         网关的设备id
 *  @param gatewayDeviceID  子设备唯一ID（数据库的）
 */
+ (void)smartGatewaySubdeviceDelWithDeviceID:(NSString*)deviceID andGatewayDeviceID:(NSString*)gatewayDeviceID Success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  获取情景列表
 *
 */
+ (void)smartSceneListSuccess:(void (^)(NSArray* sceneList))success failure:(void (^)(NSError *error))failure;

/**
 *  获取用户当前情景
 *
 *
 */
+ (void)smartSceneCurrent:(void (^)(SNScene *scene))success failure:(void (^)(NSError *error))failure;


/**
 *  情景控制
 *
 *  @param sceneID  情景id
 */
+ (void)smartSceneControlWithSceneID:(NSString*)sceneID Success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  情景新增
 *
 *  @param title        情景title
 *  @param sceneDesc    情景描述
 */
+ (void)smartSceneAddWithTitle:(NSString*)title andSceneDesc:(NSString*)sceneDesc Success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  情景修改
 *  @param  sceneID         情景id
 *  @param  title           情景标题
 *  @param  sceneDesc       情景描述
 *  @param  command         控制指令
 */
+ (void)smartSceneEditWithSceneID:(NSString*)sceneID andTitle:(NSString*)title andSceneDesc:(NSString*)sceneDesc andCommand:(NSString*)command Success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  情景删除
 *  @param  sceneID     情景id
 *
 */
+ (void)smartSceneDelWithSceneId:(NSString*)sceneID Success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  情景获取设备列表
 *  @param  sceneID     情景id
 *
 */
+ (void)smartSceneDeviceListWithSceneID:(NSString*)sceneID Success:(void (^)(NSArray* deviceList))success failure:(void (^)(NSError *error))failure;

/**
 *  情景模式-设备详情
 *  @param  sceneID                         设备id
 *  @param  deviceID                        动作ID
 *  @param gatewayDeviceID                  子设备唯一ID（数据库的）
 */
+ (void)smartSceneDeviceDetailWithSceneID:(NSString*)sceneID andDeviceID:(NSString*)deviceID andGatewayDeviceID:(NSString*)gatewayDeviceID Success:(void (^)(SNDevice* device))success failure:(void (^)(NSError *error))failure;

/**
 *  获取网关分类
 *  @param  sceneID     情景ID
 *  @param  deviceID    设备ID
 */
+ (void)smartSceneGatewayTypeWithSceneID:(NSString*)sceneID andDeviceID:(NSString*)deviceID  Success:(void (^)(NSArray* GatewayType))success failure:(void (^)(NSError *error))failure;

/**
 *  网关分类查询子设备
 *  @param  sceneID     情景ID
 *  @param  deviceID    设备ID
 *  @param  typeCode    分类编码
 */
+ (void)smartSceneGatewaySubdeviceWithSceneID:(NSString*)sceneID andDeviceID:(NSString*)deviceID andTypecode:(NSString*)typeCode  Success:(void (^)(NSArray* subDeviceList))success failure:(void (^)(NSError *error))failure;

/**
 *  网关分类一键配置
 *  @param  sceneID     情景ID
 *  @param  deviceID    设备ID
 *  @param  typeCode    分类编码
 *  @param  config      配置属性（0关/1开/2单独控制）
 */
+ (void)smartSceneGatewayTypeConfigWithSceneID:(NSString*)sceneID andDeviceID:(NSString*)deviceID andTypecode:(NSString*)typeCode andConfig:(NSString*)config Success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  动作防区列表
 *  @param  deviceID             设备id
 *  @param  gatewayDeviceID      子设备id
 *  @param  subTypeCode          子分类编码
 */
+ (void)smartGatewayActionListWithDeviceID:(NSString*)deviceID andGatewayDeviceID:(NSString*)gatewayDeviceID andSubTypeCode:(NSString*)subTypeCode Success:(void (^)(NSArray* actionList))success failure:(void (^)(NSError *error))failure;

/**
 *  动作防区修改
 *  @param  deviceID             设备id
 *  @param  gatewayDeviceID      子设备id
 *  @param  actionCode           动作编号（底板使用）
 *  @param  title                动作名称
 *  @param  actionDesc           动作描述
 *  @param  command              控制指令
 *  @param  subTypeCode          子分类编码
 */
+ (void)smartGatewayActionEditWithDeviceID:(NSString*)deviceID andGatewayDeviceID:(NSString*)gatewayDeviceID andActionCode:(NSString*)actionCode andTitle:(NSString*)title andActionDesc:(NSString*)actionDesc andCommand:(NSString*)command andSubTypeCode:(NSString*)subTypeCode Success:(void (^)())success failure:(void (^)(NSError *error))failure;


/**
 *  动作防区的添加
 *  @param  deviceID             设备id
 *  @param  gatewayDeviceID      子设备id
 *  @param  actionCode           动作编号（底板使用）
 *  @param  title                动作名称
 *  @param  actionDesc           动作描述
 *  @param  command              控制指令
 *  @param  subTypeCode          子分类编码
 *  @param  allowRemoval         是否允许撤防 (0:不允许，1：允许)
 */
+ (void)smartGatewayActionAddWithDeviceID:(NSString*)deviceID andGatewayDeviceID:(NSString*)gatewayDeviceID andActionCode:(NSString*)actionCode andTitle:(NSString*)title andActionDesc:(NSString*)actionDesc andCommand:(NSString*)command andSubTypeCode:(NSString*)subTypeCode andAllowRemoval:(NSString*)allowRemoval Success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  动作删除
 *  @param  deviceID                设备id
 *  @param  actionCode              动作ID
 */
+ (void)smartGatewayActionDelWithDeviceID:(NSString*)deviceID andActionCode:(NSString*)actionCode andGatewayDeviceID:(NSString*)gatewayDeviceID andSubTypeCode:(NSString*)subTypeCode Success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  情景模式管理动作
 *  @param  sceneID                 设备id
 *  @param  actionID                动作ID
 *  @param  type                    1:关联，2：解除
 */
+ (void)smartSceneActionWithSceneID:(NSString*)sceneID andActionID:(NSString*)actionID andType:(NSString*)type Success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  情景模式添加设备
 *  @param  sceneID                         设备id
 *  @param  deviceID                        动作ID
 *  @param  gatewayDeviceID                 网关中子设备ID
 *  @param  command                         控制指令
 */
+ (void)smartSceneDeviceAddWithSceneID:(NSString*)sceneID andDeviceID:(NSString*)deviceID andGatewayDeviceID:(NSString*)gatewayDeviceID andCommand:(NSString*)command  Success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  情景模式删除设备
 *  @param  sceneID                         设备id
 *  @param  deviceID                        动作ID
 */
+ (void)smartSceneDeviceDelWithSceneID:(NSString*)sceneID andDeviceID:(NSString*)deviceID andGatewayDeviceID:(NSString*)gatewayDeviceID Success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  安防产品防区列表
 *  @param  sceneID                         情景 ID
 *  @param  deviceID                        网关的设备 id
 *  @param  gatewayDeviceID                 子设备 id(库的)
 */
+ (void)smartSceneGatewaySafetyListWithSceneID:(NSString*)sceneID andDeviceID:(NSString*)deviceID andGatewayDeviceID:(NSString*)gatewayDeviceID subTypeCode:(NSString *)subTypeCode Success:(void (^)(NSArray* ActionList))success failure:(void (^)(NSError *error))failure;

/**
 *  配置布防撤防
 *  @param  sceneID                         设备id
 *  @param  deviceID                        动作ID
 *  @param  command                         控制指令
 *  @param  actionCode                      动作编号（底板使用）
 *  @param  subTypeCode                     子分类编码
 */
+ (void)smartSceneGatewaySafetyEditWithSceneID:(NSString*)sceneID andDeviceID:(NSString*)deviceID andGatewayDeviceID:(NSString*)gatewayDeviceID andActionCode:(NSString*)actionCode andCommand:(NSString*)command andSubTypeCode:(NSString*)subTypeCode Success:(void (^)())success failure:(void (^)(NSError *error))failure;

#pragma mark - 其他

/**
 *  访问未封装的接口
 *
 *  @param url      接口地址，（内部拼接http://api.scinan.com/v2.0）,传入后半部即可
 *  @param paramers 除通用参数外的参数
 */
+ (void)postWithURL:(NSString *)url parameters:(NSDictionary *)paramers success:(void (^)(SNResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  获取设备ID
 */
+ (NSString *)imei;

/**
 *  获取Token
 */
+ (NSString *)token;

/**
 *  获取厂商ID
 */
+ (NSString *)companyID;

@end
