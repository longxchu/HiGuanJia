//
//  linkon_op.h
//  linkon_op
//
//  Created by Dable on 16/6/2.
//  Copyright © 2016年 ThinkRise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iosCloudPkt : NSObject

-(NSString*)getPktDevID;
-(NSString*)getPktContent;
-(int)getPktType;
-(void)setPktDevID:(NSString*) strID;
-(void)setPktType: (int)type;
-(void)setPktContent: (NSString *)content;
+(iosCloudPkt *)createCloudPkt:(NSString*) devId TYPE:(int)type CONTENT:(NSString *)content;

@end

@interface linkon_op : NSObject

/** 初始化 DMI */
+ (void) dmiInit;

/** (UI 层和 DMI 进行交互)。参数和返回值均为 JSON 字符串 */
+ (NSString *) dmiJsonCommand:(NSString *)jsonCommand;

/** 处理 APP 从云 SDK 上 读取的数据,APP 需要将读取的数据封装成 CloudCmd 类,然后再调用此方法 */
+ (void) dmiPushCloudPkt:(iosCloudPkt *)pkt;

/** 用户获取要发送到云上的命令 (需要 APP 转送到云 SDK 的接口上去) 定时调 */
+ (iosCloudPkt *) dmiPullCloudPkt;
@end
