//
//  SNAPI+Food.h
//  ScinanSDK-iOS
//
//  Created by User on 16/7/14.
//  Copyright © 2016年 felixlin. All rights reserved.
//
//  菜谱

#import "SNAPI.h"

@interface SNAPI (Food)

/**
 *  获取首页菜谱跑马灯
 */
+ (void)foodMarqueeSuccess:(void (^)(NSArray *foodList))success failure:(void (^)(NSError *error))failure;

/**
 *  获取首页菜谱列表
 *
 *  @param size       每页数据记录数(默认为5)(可选)
 *  @param number     当前请求页数(初次请求默认为1，后面累加即可)
 *  @param categoryID 菜谱分类编号(默认为空，获取最新菜谱列表，不为空时，获取该分类下最新菜谱列表)(可选)
 *  @param name       菜谱名称，用于搜索(可选)
 *  @param deviceType 设备类型(可选)
 */
//+ (void)foodListWithPageSize:(NSString *)size pageNumber:(NSInteger)number categoryID:(NSString *)categoryID foodMenuName:(NSString *)name success:(void (^)(NSArray *foodList, NSInteger rows, NSInteger start))success failure:(void (^)(NSError *error))failure;
+ (void)foodListWithPageSize:(NSString *)size pageNumber:(NSInteger)number categoryID:(NSString *)categoryID foodMenuName:(NSString *)name deviceType:(NSString *)deviceType success:(void (^)(NSArray *foodList, NSInteger rows, NSInteger start))success failure:(void (^)(NSError *error))failure;

/**
 *  获取菜谱分类
 *
 *  @param categoryID 菜谱分类编号(默认为空，获取所有一级分类，不为空时，获取该分类下的子分类)
 */
//+ (void)foodCategoryListWithCategoryID:(NSString *)categoryID success:(void (^)(NSArray *categoryList))success failure:(void (^)(NSError *error))failure;
+ (void)foodCategoryListWithCategoryID:(NSString *)categoryID deviceType:(NSString *)deviceType success:(void (^)(NSArray *categoryList))success failure:(void (^)(NSError *error))failure;

/**
 *  获取菜谱详情
 *
 *  @param menuID  菜谱ID
 */
+ (void)foodDetailWithFoodMenuID:(NSString *)menuID success:(void (^)(SNFood *food))success failure:(void (^)(NSError *error))failure;

/**
 *  菜谱控制(启动、停止)
 *
 *  @param deviceID 设备ID
 *  @param sensorID 传感器ID
 *  @param type     传感器类型(可选)
 *  @param menuID   菜谱ID
 *  @param stepID   步骤ID(可选)
 *  @param runTime  运行时长(单位：秒)(可选)
 *  @param action   操作(1：启动 0：停止)
 */
+ (void)foodControlWithDeviceID:(NSString *)deviceID sensorID:(NSString *)sensorID sensorType:(NSString *)type foodMenuID:(NSString *)menuID foodMenuStepID:(NSString *)stepID runTime:(NSString *)runTime action:(BOOL)action success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  菜谱收藏
 *
 *  @param menuID  菜谱ID
 *  @param action  操作(1：收藏 0：删除收藏)
 */
+ (void)foodFavoriteWithFoodMenuID:(NSString *)menuID action:(BOOL)action success:(void (^)())success failure:(void (^)(NSError *error))failure;
+ (void)foodFavoriteWithFoodMenuID:(NSString *)menuID action:(BOOL)action menuType:(NSString *)menuType success:(void (^)())success failure:(void (^)(NSError *))failure;

/**
 *  获取菜谱收藏列表
 *
 *  @param size       每页数据记录数(默认为5)(可选)
 *  @param number     当前请求页数(初次请求默认为1，后面累加即可)
 *  @param categoryID 菜谱分类编号(默认为空，获取最新菜谱列表，不为空时，获取该分类下最新菜谱列表)(可选)
 */
+ (void)foodfavoriteListWithPageSize:(NSString *)size pageNumber:(NSInteger)number categoryID:(NSString *)categoryID success:(void (^)(NSArray *foodList, NSInteger rows))success failure:(void (^)(NSError *error))failure;
+ (void)foodfavoriteListWithDeviceType:(NSString *)deviceType pageSize:(NSString *)size pageNumber:(NSInteger)number categoryID:(NSString *)categoryID success:(void (^)(NSArray *foodList, NSInteger rows))success failure:(void (^)(NSError *error))failure;

/**
 *  菜谱分享完成
 *
 *  @param menuID  菜谱ID
 */
+ (void)foodShareWithFoodMenuID:(NSString *)menuID success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
*  获取首页文章跑马灯
*
*  @param type    文章类型(1:物联网 2:食谱)(可选)
*/
+ (void)foodArticleMarqueeWithArticleType:(int)type success:(void (^)(NSArray *articleArray))success failure:(void (^)(NSError *error))failure;

/**
 *  获取首页文章列表
 *
 *  @param type    文章类型(1:物联网 2:食谱)(可选)
 *  @param size    每页数据记录数(默认为5)(可选)
 *  @param number  当前请求页数(初次请求默认为1，后面累加即可)
 */
+ (void)foodArticleListWithArticleType:(int)type pageSize:(int)size pageNumber:(NSInteger)number success:(void (^)(NSArray *articleArray, NSInteger rows, NSInteger pages))success failure:(void (^)(NSError *error))failure;

/**
 *  文章分享完成
 *
 *  @param ID      文章ID
 */
+ (void)foodArticleShareWithArticleID:(NSString *)articleID success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  文章收藏
 *
 *  @param articleID 文章ID
 *  @param action    操作(1：收藏 0：删除收藏)
 */
+ (void)foodArticleFavoriteWithArticleID:(NSString *)articleID action:(BOOL)action success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 *  获取菜谱收藏列表
 *
 *  @param size       每页数据记录数(默认为5)(可选)
 *  @param number     当前请求页数(初次请求默认为1，后面累加即可)
 */
+ (void)foodArticleFavoriteListWithPageSize:(int)size pageNumber:(NSInteger)number success:(void (^)(NSArray *articleArray, NSInteger rows, NSInteger pages))success failure:(void (^)(NSError *error))failure;


/**
 *  获取商品列表
 *
 *  @param size    每页数据记录数(默认为10)(可选)
 *  @param number  当前请求页数(初次请求默认为1，后面累加即可)
 */
+ (void)foodProductListWithPageSize:(int)size pageNumber:(NSInteger)number success:(void (^)(NSArray *productArray, NSInteger rows, NSInteger pages))success failure:(void (^)(NSError *error))failure;

@end
