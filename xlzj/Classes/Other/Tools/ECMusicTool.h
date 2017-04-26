//
//  ECMusicTool.h
//  xlzj
//
//  Created by zhouxg on 16/8/10.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECMusicTool : NSObject
/**
 *  播放音乐
 *
 *  @param filename 音乐的文件名
 */
+ (BOOL)playMusic:(NSString *)filename;
/**
 *  停止音乐
 *
 *  @param filename 音乐的文件名
 */
+ (void)stopMusic:(NSString *)filename;
@end
