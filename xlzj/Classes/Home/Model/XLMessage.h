//
//  XLMessage.h
//  xlzj
//
//  Created by zhouxg on 16/8/1.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLMessage : NSObject<NSCoding>
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
@end
