//
//  XLMessage.m
//  xlzj
//
//  Created by zhouxg on 16/8/1.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLMessage.h"

@implementation XLMessage

#pragma mark 写入文件
-(void)encodeWithCoder:(NSCoder *)encoder
{
    // 推送标题
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeInt:self.push_type forKey:@"push_type"];
    [encoder encodeObject:self.msg_id forKey:@"msg_id"];
    [encoder encodeObject:self.push_time forKey:@"push_time"];
    [encoder encodeObject:self.content forKey:@"content"];
}

#pragma mark 从文件中读取
-(id)initWithCoder:(NSCoder *)decoder
{
    self.title = [decoder decodeObjectForKey:@"title"];
    self.push_type = [decoder decodeIntForKey:@"push_type"];
    self.msg_id = [decoder decodeObjectForKey:@"msg_id"];
    self.push_time = [decoder decodeObjectForKey:@"push_time"];
    self.content = [decoder decodeObjectForKey:@"content"];
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"title = %@, push_type = %d, msg_id = %@, push_time = %@, content = %@",self.title,self.push_type,self.msg_id,self.push_time,self.content];
}

@end