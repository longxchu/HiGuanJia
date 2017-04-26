//
//  XLAd.m
//  xlzj
//
//  Created by zhouxg on 16/8/2.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLAd.h"

@implementation XLAd

#pragma mark 写入文件
-(void)encodeWithCoder:(NSCoder *)encoder
{
    // 推送标题
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeInt:self.push_type forKey:@"push_type"];
    [encoder encodeObject:self.msg_id forKey:@"msg_id"];
    [encoder encodeObject:self.push_time forKey:@"push_time"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.push_describe forKey:@"push_describe"];
    [encoder encodeObject:self.icon_url forKey:@"icon_url"];
    [encoder encodeObject:self.image_url forKey:@"image_url"];
    [encoder encodeObject:self.link_url forKey:@"link_url"];
}

#pragma mark 从文件中读取
-(id)initWithCoder:(NSCoder *)decoder
{
    self.title = [decoder decodeObjectForKey:@"title"];
    self.push_type = [decoder decodeIntForKey:@"push_type"];
    self.msg_id = [decoder decodeObjectForKey:@"msg_id"];
    self.push_time = [decoder decodeObjectForKey:@"push_time"];
    self.content = [decoder decodeObjectForKey:@"content"];
    self.push_describe = [decoder decodeObjectForKey:@"push_describe"];
    self.icon_url = [decoder decodeObjectForKey:@"icon_url"];
    self.image_url = [decoder decodeObjectForKey:@"image_url"];
    self.link_url = [decoder decodeObjectForKey:@"link_url"];
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"title = %@, push_type = %d, msg_id = %@, push_time = %@, content = %@, push_describe = %@,icon_url = %@, image_url = %@, link_url = %@",self.title,self.push_type,self.msg_id,self.push_time,self.content,self.push_describe,self.icon_url,self.image_url,self.link_url];
}

@end
