//
//  XLAppDelegate.m
//  xlzj
//
//  Created by 周绪刚 on 16/5/17.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLAppDelegate.h"
#import "XLLoginViewController.h"
#import "XLNavigationController.h"
#import "XLHomeViewController.h"
#import <ScinanSDK-iOS/SNDevice.h>
#import "XLMessage.h"
#import "UMMobClick/MobClick.h"

@interface XLAppDelegate ()
@property (nonatomic ,strong) BMKMapManager *mapManager;
@property (nonatomic ,strong) SNAccount *acc;
@end

@implementation XLAppDelegate

- (AVAudioPlayer *)player
{
    if (!_player) {
        // 0.音频文件的URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:nil withExtension:nil];
        
        // 1.创建播放器(一个AVAudioPlayer只能播放一个URL)
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 2.缓冲
        [player prepareToPlay];
        
        self.player = player;
    }
    return _player;
}

- (NSArray *)songs
{
    if (!_songs)
    {
        self.songs = @[@"angle_change.wav", @"state_change.wav"];
    }
    return _songs;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSUserDefaults *soundDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sound = [soundDefaults objectForKey:@"soundControl"];
    if ([sound isEqualToString:@"1"])
    {
        self.canSoundPlay = YES;
    }
    else
    {
        self.canSoundPlay = NO;
    }
    
    NSUserDefaults *vibrateDefaults = [NSUserDefaults standardUserDefaults];
    NSString *vibrate = [vibrateDefaults objectForKey:@"vibrateControl"];
    if ([vibrate isEqualToString:@"1"])
    {
        self.canVibratePlay = YES;
    }
    else
    {
        self.canVibratePlay = NO;
    }
    
    
    
    self.messageList = [[NSMutableArray alloc]init];
    
    // 友盟统计
    [self initUM];
    
    // 1. 初始化司南物联
    [self initSDK];
    
    // 3. 选择控制器
    [self initViewController];
    
    // 4. 初始化百度 Manager
    [self initBaiduMap];
    
    // 5. 获取用户基本信息
    [SNAPI userInfoSuccess:^(SNUser *user) {
        self.user = user;
    } failure:^(NSError *error) {
//        NSLog(@"获取用户基本信息失败");
    }];
    
    //token过期处理
    [self initLog];
    //启动页设置时间
    [NSThread sleepForTimeInterval:1.50];
    
    return YES;
}


// 友盟统计实现
- (void)initUM {
    //开发者在友盟后台申请的应用Appkeyk
    UMConfigInstance.appKey = @"58c8da34677baa1952000c31";
    
    //ChannelId的值为应用的渠道标识。默认为 @"App Store"
    UMConfigInstance.channelId = @"App Store";
    
    //配置以上参数后调用此方法初始化SDK！
    [MobClick startWithConfigure:UMConfigInstance];
}


- (void)initLog
{
    [SNAPI setFailureHanlder:^(NSError *error) {
        //        if ((error.code >= 10000 && error.code != 10003 && error.code != 20003 && error.code != 20002 && error.code != 49999) || error.code == -1009){
        ////            NSString *errorCode = [NSString stringWithFormat:@"%d", (int)error.code];
        ////            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",errorCode]];
        //        } else {
        //            NSLog(@"\nerroor code:%d \nerrorDomain:%@",(int) error.code,error.domain);
        //        }
        if (error.code == 10002 || error.code == 10003 || error.code == 10012 || error.code == 10013) { //token 不可换 重新登入
            if ([SNAccount haveToken])
            {
                [SNMqtt disconnect];
                // 移除 token
                
                [SNAccount removeToken];
                XLLoginViewController *login = [[XLLoginViewController alloc]init];
                XLNavigationController *nav = [[XLNavigationController alloc]initWithRootViewController:login];
                self.window.rootViewController = nav;
                [self.window makeKeyAndVisible];
            }
        }
    }];

}

// 1. 初始化司南物联 SDK
- (void)initSDK
{
    NSUserDefaults *versionInfoDefault = [NSUserDefaults standardUserDefaults];
    NSString *OriVersionInfo = [versionInfoDefault objectForKey:@"versionInfo"];
    
    // 1. 初始化
    [SNAPI initWithIsFormalServer:YES companyID:company_ID debugAPPKey:debugAPP_Key debugAPPSecret:debugAPP_Secret releaseAPPKey:releaseAPP_Key releaseAPPSecret:releaseAPP_Secret];
    
    // 2. 是否显示日志
    [SNLog isShowLog:NO];
    
    // 3. 设置语言
    [SNAPI setLanguage:@"zh-CN"];
    
    // 解档帐号信息
    _acc = [SNAccount loadAccount];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    
    // 保存用户名
    NSUserDefaults *versionInfo = [NSUserDefaults standardUserDefaults];
    [versionInfo setObject:appCurVersion forKey:@"versionInfo"];
    
    if (![OriVersionInfo isEqualToString:appCurVersion])
    {
        [SNAccount removeToken];
    }
}

// 2. 初始化控制器
- (void)initViewController
{
    if ([SNAccount haveToken])
    {
        // 如果token已经存在，建立连接
        if (![SNMqtt isConnected])
        {
            [SNMqtt connect];
        }
    }
    
    // 建立MQTT连接后，即可调用接收函数接收MQTT消息，并做相应的处理，截取的示例代码如下：
    // MQTT消息，接收从设备发回的数据，需要在获取token后，调用“[SNMqtt connect];”建立连接
    [SNMqtt receive:^(NSString *topic, NSData *payload, SNHardwareCMD *cmd) {
//        NSLog(@" --- topic :%@ --- data :%@",topic,cmd.data);
        /** 1. 消息 */
        if([topic rangeOfString:@"{"].location != NSNotFound && [topic rangeOfString:@"}"].location != NSNotFound)
        {
            NSRange start = [topic rangeOfString:@"{"];
            NSRange end = [topic rangeOfString:@"}"];
            NSString *sub = [topic substringWithRange:NSMakeRange(start.location, end.location-start.location+1)];
            self.message = [XLMessage mj_objectWithKeyValues:sub];
            NSLog(@"self.message = %@",self.message);
            
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"Thinkrise_Message" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }
        
        /** 2. 广告 */
        NSString *result = [[NSString alloc] initWithData:payload encoding:NSUTF8StringEncoding];
        if([result rangeOfString:@"{"].location !=NSNotFound && [result rangeOfString:@"}"].location !=NSNotFound)
        {
            NSRange start = [result rangeOfString:@"{"];
            NSRange end = [result rangeOfString:@"}"];
            NSString *sub = [result substringWithRange:NSMakeRange(start.location, end.location-start.location+1)];
            self.ad = [XLAd mj_objectWithKeyValues:sub];
            NSLog(@"self.ad = %@",self.ad);
            
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"Thinkrise_Advertisement" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }
        
        NSString *deviceID = cmd.deviceID;
        int type = cmd.sensorID.intValue;
        NSString *content = cmd.data;
        
        if ([content characterAtIndex:0]  == '{')
        {
            
        }
        else
        {
            self.cloud = [iosCloudPkt createCloudPkt:deviceID TYPE:type CONTENT:content];
            [linkon_op dmiPushCloudPkt:self.cloud];
        }
    }];
    
    self.window = [[UIWindow alloc]initWithFrame:kMainScreenBounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    XLHomeViewController *home = [[XLHomeViewController alloc]init];
    XLNavigationController *nav = [[XLNavigationController alloc]initWithRootViewController:home];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [self initDMI];
}
// 3. 初始化百度 Manager
- (void)initBaiduMap
{
    self.mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [self.mapManager start:baidu_map_key_thinkrise generalDelegate:self];
    if (!ret) {
    }else{
    }
}
// 4. 初始化 DMI
- (void)initDMI
{
    // 1. 初始化 linkon_op
    [linkon_op dmiInit];
    
    // 2. 更新云设备列表
    [SNAPI deviceLiseSuccess:^(NSArray *deviceList) {
        if (deviceList)
        {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < deviceList.count; i++)
            {
                SNDevice *device = deviceList[i];
                
                int deviceType = device.type.intValue;
                
                int stCloud = device.online;
                
                NSDictionary *updateCloudDevicesArray =
                                                     @{
                                                         @"devId": device.ID,
                                                         @"devType":@(deviceType),
                                                         @"stCloud":@(stCloud)
                                                         };
                [arr addObject:updateCloudDevicesArray];
                
            }
            [XLDMITools commandStrCmdWith:@"updateCloudDevices" withStrIndex:@"" withValue:arr];
        }
        
        // 3. 初始化定时器 (每秒调用一次dmiPullCloudPkt)
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(dmiPullBegin) userInfo:nil repeats:YES];
        [timer fire];
        
    } failure:^(NSError *error) {
//        NSLog(@"error --- %@",error.domain);
    }];
}

// 5. DMI发送指令
- (void)dmiPullBegin
{
    self.cloud = [linkon_op dmiPullCloudPkt];
    NSString *deviceID = [self.cloud getPktDevID];
    NSString *sensorID = [NSString stringWithFormat:@"0%d",[self.cloud getPktType]];
    NSString *content = [self.cloud getPktContent];
    
    [SNAPI sensorControlWithDeviceID:deviceID sensorID:sensorID value:content success:^{
    } failure:^(NSError *error) {}];
}

/** 从后台唤醒命令 */
-(void)applicationWillEnterForeground:(UIApplication *)application
{
//    [XLDMITools commandStrCmdWith:@"stopDMIComm" withStrIndex:@"" withValue:@(0)];
    
    [self initDMI];
    if([UIPasteboard generalPasteboard].hasStrings){
        NSString *pasteStr = [[UIPasteboard generalPasteboard] string];
        NSCharacterSet *numChar = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        pasteStr = [[pasteStr componentsSeparatedByCharactersInSet:numChar] componentsJoinedByString:@""];
        [UIPasteboard generalPasteboard].string = pasteStr;
    }

}
///** 进入后台命令 */
//-(void)applicationDidEnterBackground:(UIApplication *)application
//{
//    [XLDMITools commandStrCmdWith:@"stopDMIComm" withStrIndex:@"" withValue:@(1)];
//}

-(void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];//这里一定不能漏掉，否则app将不能成功启动。
    
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0)
    {
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan)
        {
//            NSLog(@"send UITouchPhaseBegan");
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"UITouchPhaseBegan" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }
        else if (phase == UITouchPhaseMoved)
        {
//            NSLog(@"send UITouchPhaseMoved");
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"UITouchPhaseMoved" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }
        else if (phase == UITouchPhaseEnded)
        {
//            NSLog(@"send UITouchPhaseEnded");
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"UITouchPhaseEnded" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }
    }
}

@end
