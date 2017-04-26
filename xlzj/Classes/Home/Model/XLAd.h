//
//  XLAd.h
//  xlzj
//
//  Created by zhouxg on 16/8/2.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 以下是广告推送的举例：
 1	[{"title":"水电费","icon_url":"","push_describe":"水电费水电费","push_type":"1","msg_id":"123","push_time":"2016-05-26 15:37:59","image_url":"http://download.test.scinan.com/files/upload/msp_push/images/b6d9192a-aac6-49d2-9ad6-ebd991cda1ae.png","link_url":"http://www.scinan.com"}]
 2   [{"title":"1111111111","icon_url":"","push_describe":"22222222","push_type":"2","msg_id":"122","push_time":"2016-05-26 15:30:55","content":"33333333333333"}]
 4   [{"title":"测试链接推送","icon_url":"","push_describe":"测试链接推送描述","push_type":"4","msg_id":"109","push_time":"2016-05-26 11:07:42","link_url":"http://www.baidu.com"}]
 
 */

@interface XLAd : NSObject<NSCoding>
/** 推送标题 */
@property (nonatomic, copy) NSString *title;
/** 推送类型 1:图片 2:文字 4:链接*/
@property (nonatomic ,assign) int push_type;
/** 消息编号 */
@property (nonatomic, copy) NSString *msg_id;
/** 推送时间 */
@property (nonatomic, copy) NSString *push_time;
/** 内容 */
@property (nonatomic, copy) NSString *content;
/** 推送描述 */
@property (nonatomic, copy) NSString *push_describe;
/** 推送图标 */
@property (nonatomic, copy) NSString *icon_url;
/** 图片下载地址 */
@property (nonatomic, copy) NSString *image_url;
/** 链接地址 */
@property (nonatomic, copy) NSString *link_url;
@end
