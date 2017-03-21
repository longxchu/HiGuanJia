//
//  XLAppDelegate.h
//  xlzj
//
//  Created by 周绪刚 on 16/5/17.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "linkon_op.h"
#import "XLMessage.h"
#import "XLAd.h"
#import <ScinanSDK-iOS/SNUser.h>
#import <AVFoundation/AVFoundation.h>

@interface XLAppDelegate : UIApplication <UIApplicationDelegate,BMKGeneralDelegate>

@property (nonatomic ,strong) SNUser *user;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic ,strong) iosCloudPkt *cloud;

/** 消息 */
@property (nonatomic, strong) XLMessage *message;
/** 广告 */
@property (nonatomic, strong) XLAd *ad;

@property (nonatomic ,strong) NSMutableArray *messageList;


/**
 媒体播放
 */
@property (nonatomic, strong) AVAudioPlayer *player;

/**
 是否允许播放音效
 */
@property (nonatomic ,assign) BOOL canSoundPlay;

/**
 是否允许振动
 */
@property (nonatomic ,assign) BOOL canVibratePlay;

/**
 音效文件
 */
@property (nonatomic, strong) NSArray *songs;
@end

