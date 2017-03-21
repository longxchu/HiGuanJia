//
//  XLHomeViewController.m
//  xlzj
//
//  Created by zhouxg on 16/5/20.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLHomeViewController.h"
#import "XLUserCenterViewController.h"
#import "XLControlViewController.h"
#import "XLDeviceViewController.h"
#import "XLNoticeView.h"
#import "XLWeather.h"
#import "XLDeviceList.h"
#import "XLDevice.h"

typedef NS_ENUM(NSInteger, TableViewTag)
{
    TableViewNotice = 0,
    TableViewMain = 1
};

@interface XLHomeViewController ()<UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,NSURLConnectionDelegate,NSCoding,NSKeyedArchiverDelegate,NSKeyedUnarchiverDelegate>

/********************************* 通知中心 *********************************/
@property (nonatomic ,strong) XLNoticeView *noticeView;
/********************************* 通知中心 *********************************/

/********************************* 多条信息子容器 *********************************/
@property (nonatomic ,strong) UIView *mutiContainer;
// 天气1
@property (nonatomic ,strong) UILabel *weatherLabel1;
// 天气图标1
@property (nonatomic ,strong) UIImageView *weatherImage1;
// 天气温度1
@property (nonatomic ,strong) UILabel *tempLabel1;
// 天气2
@property (nonatomic ,strong) UILabel *weatherLabel2;
// 天气图标2
@property (nonatomic ,strong) UIImageView *weatherImage2;
// 天气温度2
@property (nonatomic ,strong) UILabel *tempLabel2;
// 天气3
@property (nonatomic ,strong) UILabel *weatherLabel3;
// 天气图标3
@property (nonatomic ,strong) UIImageView *weatherImage3;
// 天气温度3
@property (nonatomic ,strong) UILabel *tempLabel3;
/********************************* 多条信息子容器 *********************************/

/********************************* 单条信息子容器 *********************************/
@property (nonatomic ,strong) UIView *singleContainer;
// 天气3
@property (nonatomic ,strong) UILabel *weatherLabel;
// 天气图标3
@property (nonatomic ,strong) UIImageView *weatherImage;
// 天气温度3
@property (nonatomic ,strong) UILabel *tempLabel;
/********************************* 单条信息子容器 *********************************/

/********************************* 百度 *********************************/
// 定位服务类
@property (nonatomic ,strong) BMKLocationService *locationService;
// 反地理编码
@property (nonatomic ,strong) BMKGeoCodeSearch *reverseGeoCodeSearch;
// 城市名称
@property (nonatomic, copy) NSString *cityName;
/********************************* 百度 *********************************/

/********************************* 其他 *********************************/
@property (nonatomic ,strong) UIView *mainContainer;
// 天气模型
@property (nonatomic ,strong) XLWeather *weather;
// 下降按钮
@property (nonatomic ,strong) UIButton *downBtn;
// 手势事件
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
// 设备信息展示表
@property (nonatomic ,strong) UITableView *tableViewMain;
/********************************* 其他 *********************************/

/********************************* DMI设备 *********************************/
/** 存放中间变量 */
@property (nonatomic ,strong) XLDevice *tempDevice;
/** 获取所有设备 */
@property (nonatomic ,strong) NSMutableArray *deviceList;
/** 定时器 */
@property (nonatomic ,strong) NSTimer *timer;
/********************************* DMI设备 *********************************/

/** 消息信息展示表 */
@property (nonatomic ,strong) UITableView *tableViewNotice;
/** 消息数组 */
@property (nonatomic ,strong) NSMutableArray *messageList;
/** 广告数组 */
@property (nonatomic ,strong) NSMutableArray *adList;

@property (nonatomic ,strong) iosCloudPkt *cloud;

@property (nonatomic ,strong) UIButton *switchBtn;

@end

@implementation XLHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"Hi!管家";
    
    [self initNaviBar];
    
    [self initTableView];
    
    [self initBottomView];
    
    [self initTopView];
    
    [self initBaiduLocation];
    
    [self initBaiduReverseGeoCodeSearch];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
    
    [self addDownBtnGesture];
    
    // 修正第一次登录拿不到结果的bug
    [self updateCloudDevices];
}

- (void)updateCloudDevices
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
        
    }];
}

// 5. DMI发送指令
- (void)dmiPullBegin
{
    self.cloud = [linkon_op dmiPullCloudPkt];
    
    if (self.cloud)
    {
        NSString *deviceID = [self.cloud getPktDevID];
        NSString *sensorID = [NSString stringWithFormat:@"0%d",[self.cloud getPktType]];
        NSString *content = [self.cloud getPktContent];
        
        [SNAPI sensorControlWithDeviceID:deviceID sensorID:sensorID value:content success:^{
        } failure:^(NSError *error) {}];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self NaviBarShow:NO];
    self.locationService.delegate = self;
    self.reverseGeoCodeSearch.delegate = self;
    
    /** 初始化消息数组 */
    self.messageList = [NSMutableArray array];
    // 反序列化消息数组
    NSString *messageDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *messageFilePath = [messageDocumentsPath stringByAppendingPathComponent:@"MessageList.archiver"];
    NSData *messageData = [NSData dataWithContentsOfFile:messageFilePath];
    NSKeyedUnarchiver *messageUnarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:messageData];
    messageUnarchiver.delegate = self;
    if (messageUnarchiver != nil)
    {
        self.messageList = [messageUnarchiver decodeObjectForKey:@"MessageList"];
        [messageUnarchiver finishDecoding];
    }
    
    /** 初始化广告数组 */
    self.adList = [NSMutableArray array];
    // 反序列化广告数组
    NSString *advertisementDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *advertisementFilePath = [advertisementDocumentsPath stringByAppendingPathComponent:@"Advertisement.archiver"];
    NSData *advertisementData = [NSData dataWithContentsOfFile:advertisementFilePath];
    NSKeyedUnarchiver *advertisementUnarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:advertisementData];
    advertisementUnarchiver.delegate = self;
    if (advertisementUnarchiver != nil)
    {
        self.adList = [advertisementUnarchiver decodeObjectForKey:@"Advertisement"];
        [advertisementUnarchiver finishDecoding];
    }
    
    /** 定时刷新本地列表 */
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getDeviceListTimerFire) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)getDeviceListTimerFire
{
    /** 整个 cell 显示 */
    // 1. 从 DMI 层获取设备设备列表
    NSDictionary *getDeviceListDict = @{@"strCmd":@"getDeviceList"};
    NSString *getDeviceListDictJson = [XLDictionary dictionaryToJson:getDeviceListDict];
    NSString *getDeviceListCommand = [linkon_op dmiJsonCommand:getDeviceListDictJson];
    // 2. 根据retData取到对应数组
    NSDictionary *getDeviceListRetDict = [XLDictionary dictionaryWithJsonString:getDeviceListCommand];
    NSArray *getDeviceListRetArr = [getDeviceListRetDict valueForKey:@"retData"];
    
    // 3. 字典数组转模型数组
    self.deviceList = [XLDevice mj_objectArrayWithKeyValuesArray:getDeviceListRetArr];
    
    
    for (int i = 0; i < self.deviceList.count; i++)
    {
        self.tempDevice = self.deviceList[i];
        
        // 过滤未响应的云设备
        if ([self.tempDevice.strDevName isEqualToString:@"未响应的云设备"] && self.tempDevice.stConnect == 0)
        {
            [self.deviceList removeObject:self.tempDevice];
        }
    }
    
    //获取通知中心单例对象
    NSNotificationCenter *messageCenter = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [messageCenter addObserver:self selector:@selector(addMessageToArray) name:@"Thinkrise_Message" object:nil];
    
    //获取通知中心单例对象
    NSNotificationCenter *advertisementCenter = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [advertisementCenter addObserver:self selector:@selector(addAdvertisementToArray) name:@"Thinkrise_Advertisement" object:nil];
    
    [self.tableViewMain reloadData];
    
    // 一键离家模式启动判断状态
    if (self.tempDevice.strIndex)
    {
        NSDictionary *getLeaveModeStatusDict = @{@"strCmd":@"getLeaveModeStatus",@"strIndex":self.tempDevice.strIndex};
        NSString *getLeaveModeStatusDictJson = [XLDictionary dictionaryToJson:getLeaveModeStatusDict];
        NSString *getLeaveModeStatusCommand = [linkon_op dmiJsonCommand:getLeaveModeStatusDictJson];
        // 2. 根据retData取到对应数组
        NSDictionary *getLeaveModeStatusRetDict = [XLDictionary dictionaryWithJsonString:getLeaveModeStatusCommand];
        // 0表示退出离家模式，1表示进入离家模式。
        NSString *getLeaveModeStatusRetValue = [getLeaveModeStatusRetDict objectForKey:@"retData"];
        int retDataValue = [getLeaveModeStatusRetValue intValue];
        
        UIImage *image = [UIImage imageNamed:@"slide_point"];
        
        if (retDataValue == 0)  // 在家
        {
            self.switchBtn.selected = NO;
            [self.switchBtn setTitle:@"OFF" forState:UIControlStateNormal];
            self.switchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 35.0);
            self.switchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -image.size.width/2, 0, 0);
        }
        else if(retDataValue == 1)// 离家
        {
            self.switchBtn.selected = YES;
            [self.switchBtn setTitle:@"ON" forState:UIControlStateSelected];
            self.switchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0);
            self.switchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -image.size.width/2-25, 0, image.size.width/2);
        }
    }
}

- (void)addMessageToArray
{
    XLAppDelegate *app = (XLAppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.message)
    {
        for (int i = 0; i <= self.messageList.count; i++)
        {
            BOOL isbool = [self.messageList containsObject:app.message];
            if (isbool == NO)
            {
                [self.messageList insertObject:app.message atIndex:0];
                // 序列化消息数组
                NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
                NSString *newFilePath = [documentsPath stringByAppendingPathComponent:@"MessageList.archiver"];
                NSMutableData *data = [[NSMutableData alloc]init];
                NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                archiver.delegate = self;
                [archiver encodeObject:self.messageList forKey:@"MessageList"];
                [archiver finishEncoding];
                BOOL isSucced = [data writeToFile:newFilePath atomically:YES];
                if (isSucced == YES)
                {
                    NSLog(@"写入成功");
                }
                else
                {
                    NSLog(@"写入失败");
                }
            }
        }
    }
    
    [self.tableViewNotice reloadData];
}

- (void)addAdvertisementToArray
{
    XLAppDelegate *app = (XLAppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.ad)
    {
        for (int i = 0; i <= self.adList.count; i++)
        {
            BOOL isbool = [self.adList containsObject:app.ad];
            if (isbool == NO)
            {
                [self.adList insertObject:app.ad atIndex:0];
                // 序列化广告数组
                NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
                NSString *newFilePath = [documentsPath stringByAppendingPathComponent:@"Advertisement.archiver"];
                NSMutableData *data = [[NSMutableData alloc]init];
                NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                archiver.delegate = self;
                [archiver encodeObject:self.adList forKey:@"Advertisement"];
                [archiver finishEncoding];
                BOOL isSucced = [data writeToFile:newFilePath atomically:YES];
                if (isSucced == YES)
                {
                    NSLog(@"写入成功");
                }
                else
                {
                    NSLog(@"写入失败");
                }
            }
        }
    }
    
    [self.tableViewNotice reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.locationService.delegate = nil;
    self.reverseGeoCodeSearch.delegate = nil;
    
    [self.timer invalidate];
    self.timer = nil;
    
    /*************************** 防止控制器跳转天气显示不正确 ***************************/
    self.mainContainer.y = 0.0;
    self.downBtn.y = 150.0;
    self.noticeView.y = -(kMainScreenSizeHeight - 176.0);
    [self singleContainerHidden:NO];
    [self.downBtn setImage:[UIImage imageNamed:@"slide_down"] forState:UIControlStateNormal];
    /*************************** 防止控制器跳转天气显示不正确 ***************************/
}

#pragma mark - 百度定位
#pragma mark -
- (void)initBaiduLocation
{
    self.locationService = [[BMKLocationService alloc]init];
    [self.locationService startUserLocationService];
}

#pragma mark - 百度反地理编码
#pragma mark -
- (void)initBaiduReverseGeoCodeSearch
{
    self.reverseGeoCodeSearch = [[BMKGeoCodeSearch alloc]init];
}

#pragma mark - BMKLocationServiceDelegate
#pragma mark -
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation) {
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
        BOOL flag = [self.reverseGeoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
        
    }else{
        NSLog(@"定位失败 %@",userLocation.location);
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
#pragma mark -
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    self.cityName = result.addressDetail.city;
    
    if (self.cityName)
    {
        [self.locationService stopUserLocationService];
        [self initWeather];
    }
}

- (void)initNaviBar
{
    UIButton *userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *user = [UIImage imageNamed:@"user_button"];
    userBtn.frame = CGRectMake(0, 0, user.size.width/2 * 1.2, user.size.height/2 * 1.2);
    userBtn.backgroundColor = [UIColor clearColor];
    [userBtn setBackgroundImage:user forState:UIControlStateSelected];
    [userBtn setBackgroundImage:user forState:UIControlStateNormal];
    [userBtn addTarget:self action:@selector(userBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:userBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *message = [UIImage imageNamed:@"message_button"];
    messageBtn.frame = CGRectMake(0, 0, message.size.width/2 * 1.2, message.size.height/2 * 1.2);
    [messageBtn setBackgroundImage:message forState:UIControlStateNormal];
    [messageBtn setBackgroundImage:message forState:UIControlStateHighlighted];
    messageBtn.backgroundColor = [UIColor clearColor];
    [messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:messageBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)userBtnClick
{
    XLUserCenterViewController *userCenter = [[XLUserCenterViewController alloc]init];
    [self.navigationController pushViewController:userCenter animated:YES];
}

- (void)settingBtnClick
{
    XLDeviceViewController *device = [[XLDeviceViewController alloc]init];
    [self.navigationController pushViewController:device animated:YES];
}

- (void)messageBtnClick
{
    if (self.noticeView.y < 0.0)
    {
        [UIView animateWithDuration:1.0 animations:^{
            self.noticeView.y = 0.0;
            self.mainContainer.y = kMainScreenSizeHeight - 26.0 - 150.0;
            self.downBtn.y = kMainScreenSizeHeight - 26.0;
            [self singleContainerHidden:YES];
            [self.downBtn setImage:[UIImage imageNamed:@"slide_up"] forState:UIControlStateNormal];
        }];
    }
    else
    {
        [UIView animateWithDuration:1.0 animations:^{
            self.noticeView.y = -(kMainScreenSizeHeight - 176.0);
            self.mainContainer.y = 0.0;
            self.downBtn.y = 150.0;
            [self singleContainerHidden:NO];
            [self.downBtn setImage:[UIImage imageNamed:@"slide_down"] forState:UIControlStateNormal];
        }];
    }
}

- (void)initTopView
{
    /********************************** 通知中心 **********************************/
    self.noticeView = [[XLNoticeView alloc]init];
    [self.view addSubview:self.noticeView];
    [self.noticeView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(-(kMainScreenSizeHeight - 176.0), 0, 0, 0) excludingEdge:ALEdgeBottom];
    [self.noticeView autoSetDimension:ALDimensionHeight toSize:(kMainScreenSizeHeight - 176.0)];
    
    UIImageView *topBg = [[UIImageView alloc]init];
    topBg.image = [UIImage imageNamed:@"weather_notice_bg"];
    [self.noticeView addSubview:topBg];
    [topBg autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.tableViewNotice = [[UITableView alloc]init];
    self.tableViewNotice.delegate = self;
    self.tableViewNotice.dataSource = self;
    self.tableViewNotice.rowHeight = 80.0;
    self.tableViewNotice.showsVerticalScrollIndicator = NO;
    self.tableViewNotice.tableFooterView = [[UIView alloc]init];
    self.tableViewNotice.tag = TableViewNotice;
    self.tableViewNotice.backgroundColor = [UIColor clearColor];
    self.tableViewNotice.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.noticeView addSubview:self.tableViewNotice];
    [self.tableViewNotice autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64, 0, 0, 0)];
    
    /********************************** 通知中心 **********************************/
    
    /********************************** 天气父容器 ********************************/
    self.mainContainer = [[UIView alloc]init];
    self.mainContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainContainer];
    [self.mainContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [self.mainContainer autoSetDimension:ALDimensionHeight toSize:150.0];
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.image = [UIImage imageNamed:@"weather_bg"];
    bgImageView.userInteractionEnabled = YES;
    [self.mainContainer addSubview:bgImageView];
    [bgImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    /********************************** 天气父容器 ********************************/
    
    /********************************** 天气多容器 ********************************/
    self.mutiContainer = [[UIView alloc]init];
    self.mutiContainer.hidden = YES;
    [self.mainContainer addSubview:self.mutiContainer];
    [self.mutiContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // 第一行
    self.weatherLabel1 = [[UILabel alloc]init];
    [self.weatherLabel1 setTextColor:[UIColor whiteColor]];
    [self.weatherLabel1 setTextAlignment:NSTextAlignmentLeft];
    self.weatherLabel1.font = [UIFont boldSystemFontOfSize:18.0];
    [self.mutiContainer addSubview:self.weatherLabel1];
    [self.weatherLabel1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.mutiContainer withOffset:10.0];
    [self.weatherLabel1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.mutiContainer withOffset:15.0];
    [self.weatherLabel1 autoSetDimensionsToSize:CGSizeMake(90.0, 30.0)];
    
    self.weatherImage1 = [[UIImageView alloc]init];
    [self.mutiContainer addSubview:self.weatherImage1];
    [self.weatherImage1 autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.weatherImage1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.mutiContainer];
    [self.weatherImage1 autoSetDimensionsToSize:CGSizeMake(49.0, 49.0)];
    
    self.tempLabel1 = [[UILabel alloc]init];
    [self.tempLabel1 setTextColor:[UIColor whiteColor]];
    [self.tempLabel1 setTextAlignment:NSTextAlignmentRight];
    self.tempLabel1.font = [UIFont boldSystemFontOfSize:18.0];
    [self.mutiContainer addSubview:self.tempLabel1];
    [self.tempLabel1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.mutiContainer withOffset:10.0];
    [self.tempLabel1 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.mutiContainer withOffset:-15.0];
    [self.tempLabel1 autoSetDimensionsToSize:CGSizeMake(90.0, 30.0)];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor whiteColor];
    [self.mutiContainer addSubview:line1];
    [line1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.weatherImage1];
    [line1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.mutiContainer withOffset:15.0];
    [line1 autoPinEdge: ALEdgeRight toEdge:ALEdgeRight ofView:self.mutiContainer withOffset:-15.0];
    [line1 autoSetDimension:ALDimensionHeight toSize:2.0];
    
    // 第二行
    self.weatherLabel2 = [[UILabel alloc]init];
    [self.weatherLabel2 setTextColor:[UIColor whiteColor]];
    [self.weatherLabel2 setTextAlignment:NSTextAlignmentLeft];
    self.weatherLabel2.font = [UIFont boldSystemFontOfSize:18.0];
    [self.mutiContainer addSubview:self.weatherLabel2];
    [self.weatherLabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:line1 withOffset:10.0];
    [self.weatherLabel2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.mutiContainer withOffset:15.0];
    [self.weatherLabel2 autoSetDimensionsToSize:CGSizeMake(90.0, 30.0)];
    
    self.weatherImage2 = [[UIImageView alloc]init];
    [self.mutiContainer addSubview:self.weatherImage2];
    [self.weatherImage2 autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.weatherImage2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line1];
    [self.weatherImage2 autoSetDimensionsToSize:CGSizeMake(49.0, 49.0)];
    
    self.tempLabel2 = [[UILabel alloc]init];
    [self.tempLabel2 setTextColor:[UIColor whiteColor]];
    [self.tempLabel2 setTextAlignment:NSTextAlignmentRight];
    self.tempLabel2.font = [UIFont boldSystemFontOfSize:18.0];
    [self.mutiContainer addSubview:self.tempLabel2];
    [self.tempLabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line1 withOffset:10.0];
    [self.tempLabel2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.mutiContainer withOffset:-15.0];
    [self.tempLabel2 autoSetDimensionsToSize:CGSizeMake(90.0, 30.0)];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = [UIColor whiteColor];
    [self.mutiContainer addSubview:line2];
    [line2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.weatherImage2];
    [line2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.mutiContainer withOffset:15.0];
    [line2 autoPinEdge: ALEdgeRight toEdge:ALEdgeRight ofView:self.mutiContainer withOffset:-15.0];
    [line2 autoSetDimension:ALDimensionHeight toSize:2.0];
    
    // 第三行
    self.weatherLabel3 = [[UILabel alloc]init];
    [self.weatherLabel3 setTextColor:[UIColor whiteColor]];
    [self.weatherLabel3 setTextAlignment:NSTextAlignmentLeft];
    self.weatherLabel3.font = [UIFont boldSystemFontOfSize:18.0];
    [self.mutiContainer addSubview:self.weatherLabel3];
    [self.weatherLabel3 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:line2 withOffset:10.0];
    [self.weatherLabel3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.mutiContainer withOffset:15.0];
    [self.weatherLabel3 autoSetDimensionsToSize:CGSizeMake(90.0, 30.0)];
    
    self.weatherImage3 = [[UIImageView alloc]init];
    [self.mutiContainer addSubview:self.weatherImage3];
    [self.weatherImage3 autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.weatherImage3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line2];
    [self.weatherImage3 autoSetDimensionsToSize:CGSizeMake(49.0, 49.0)];
    
    self.tempLabel3 = [[UILabel alloc]init];
    [self.tempLabel3 setTextColor:[UIColor whiteColor]];
    [self.tempLabel3 setTextAlignment:NSTextAlignmentRight];
    self.tempLabel3.font = [UIFont boldSystemFontOfSize:18.0];
    [self.mutiContainer addSubview:self.tempLabel3];
    [self.tempLabel3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line2 withOffset:10.0];
    [self.tempLabel3 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.mutiContainer withOffset:-15.0];
    [self.tempLabel3 autoSetDimensionsToSize:CGSizeMake(90.0, 30.0)];
    /********************************** 天气多容器 ********************************/
    
    /********************************** 天气单容器 ********************************/
    self.singleContainer = [[UIView alloc]init];
    self.singleContainer.backgroundColor = [UIColor clearColor];
    self.singleContainer.hidden = NO;
    [self.mainContainer addSubview:self.singleContainer];
    [self.singleContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.weatherLabel = [[UILabel alloc]init];
    [self.weatherLabel setTextColor:[UIColor whiteColor]];
    [self.weatherLabel setTextAlignment:NSTextAlignmentCenter];
    self.weatherLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self.singleContainer addSubview:self.weatherLabel];
    [self.weatherLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.singleContainer withOffset:80.0];
    [self.weatherLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.singleContainer withOffset:15.0];
    [self.weatherLabel autoSetDimensionsToSize:CGSizeMake(90.0, 30.0)];
    
    self.weatherImage = [[UIImageView alloc]init];
    [self.singleContainer addSubview:self.weatherImage];
    [self.weatherImage autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.weatherImage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.singleContainer withOffset:60.0];
    [self.weatherImage autoSetDimensionsToSize:CGSizeMake(64.0, 64.0)];
    
    self.tempLabel = [[UILabel alloc]init];
    [self.tempLabel setTextColor:[UIColor whiteColor]];
    [self.tempLabel setTextAlignment:NSTextAlignmentCenter];
    self.tempLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self.singleContainer addSubview:self.tempLabel];
    [self.tempLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.singleContainer withOffset:80.0];
    [self.tempLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.singleContainer withOffset:-15.0];
    [self.tempLabel autoSetDimensionsToSize:CGSizeMake(90.0, 30.0)];
    /********************************** 天气单容器 ********************************/
    
    /********************************** 滑动小按钮 ********************************/
    self.downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downBtn setImage:[UIImage imageNamed:@"slide_down"] forState:UIControlStateNormal];
    CGFloat XY = (kMainScreenSizeWidth - 12.0)/2;
    self.downBtn.imageEdgeInsets = UIEdgeInsetsMake(6.0, XY, 6.0, XY);
    [self.downBtn setBackgroundColor:[UIColor lightGrayColor]];
    self.downBtn.frame = CGRectMake(0, 150.0, kMainScreenSizeWidth, 26.0);
    [self.view addSubview:self.downBtn];
    /********************************** 滑动小按钮 ********************************/
}

- (void)addDownBtnGesture
{
    [self.downBtn addGestureRecognizer:self.panGestureRecognizer];
}

- (void)initWeather
{
    NSString *urlStr = [NSString stringWithFormat:weather_domain,self.cityName,weather_key];
    NSString *newStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:newStr];
    NSURLRequest *requst = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *reason = [dict objectForKey:@"reason"];
        
        if ([reason isEqualToString:@"successed!"] || [reason isEqualToString:@"查询成功"]) {
            NSDictionary *tempDict = dict[@"result"];
            XLWeather *weather = [XLWeather mj_objectWithKeyValues:tempDict[@"data"]];
            
            XLWeather_weather *w1 = [XLWeather_weather mj_objectWithKeyValues:weather.weather[0]];
            XLWeather_weather *w2 = [XLWeather_weather mj_objectWithKeyValues:weather.weather[1]];
            XLWeather_weather *w3 = [XLWeather_weather mj_objectWithKeyValues:weather.weather[2]];
            
            // 1. 数组
            // 今天
            XLWeatherInfo *info1 = w1.info;
//            NSLog(@"info1 --- %@ --- %@",info1.night,info1.day);
            // 明天
            XLWeatherInfo *info2 = w2.info;
//            NSLog(@"info1 --- %@ --- %@",info2.night,info2.day);
            // 后天
            XLWeatherInfo *info3 = w3.info;
//            NSLog(@"info1 --- %@ --- %@",info3.night,info3.day);
            
            // 2. 天气
            // 今天
            NSString *nightWeather1 = info1.night[1];
            NSString *dayWeather1 = info1.day[1];
//            NSLog(@"weather --- %@ --- %@",nightWeather1,dayWeather1);
            // 明天
            NSString *nightWeather2 = info2.night[1];
            NSString *dayWeather2 = info2.day[1];
//            NSLog(@"weather --- %@ --- %@",nightWeather2,dayWeather2);
            // 后天
            NSString *nightWeather3 = info3.night[1];
            NSString *dayWeather3 = info3.day[1];
//            NSLog(@"weather --- %@ --- %@",nightWeather3,dayWeather3);
            
            // 温度范围
            NSString *nightTemp1 = info1.night[2];
            NSString *dayTemp1 = info1.day[2];
//            NSLog(@"temperature --- %@ --- %@",nightTemp1,dayTemp1);
            NSString *nightTemp2 = info2.night[2];
            NSString *dayTemp2 = info2.day[2];
//            NSLog(@"temperature --- %@ --- %@",nightTemp2,dayTemp2);
            NSString *nightTemp3 = info3.night[2];
            NSString *dayTemp3 = info3.day[2];
//            NSLog(@"temperature --- %@ --- %@",nightTemp3,dayTemp3);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"HH"];
            NSString *str = [formatter stringFromDate:[NSDate date]];
            int time = [str intValue];
            if (time >= 18 || time <= 06) {
                NSLog(@"夜晚");
                [self.weatherLabel setText:nightWeather1];                      // 晴
                UIImage *image = [UIImage imageWithWeatherStr:nightWeather1];   // 图标
                self.weatherImage.image = image;
                
//                [self.weatherLabel1 setText:nightWeather1];
                [self.weatherLabel1 setText:@"今天"];
                UIImage *image1 = [UIImage imageWithWeatherStr:nightWeather1];
                self.weatherImage1.image = image1;
                
//                [self.weatherLabel2 setText:nightWeather2];
                [self.weatherLabel2 setText:@"明天"];
                UIImage *image2 = [UIImage imageWithWeatherStr:nightWeather2];
                self.weatherImage2.image = image2;
                
//                [self.weatherLabel3 setText:nightWeather3];
                [self.weatherLabel3 setText:@"后天"];
                UIImage *image3 = [UIImage imageWithWeatherStr:nightWeather3];
                self.weatherImage3.image = image3;
            }else{
                NSLog(@"白天");
                [self.weatherLabel setText:dayWeather1];                        // 晴
                UIImage *image = [UIImage imageWithWeatherStr:dayWeather1];     // 图标
                self.weatherImage.image = image;
                
//                [self.weatherLabel1 setText:dayWeather1];
                [self.weatherLabel1 setText:@"今天"];
                UIImage *image1 = [UIImage imageWithWeatherStr:dayWeather1];
                self.weatherImage1.image = image1;
                
//                [self.weatherLabel2 setText:dayWeather2];
                [self.weatherLabel2 setText:@"明天"];
                UIImage *image2 = [UIImage imageWithWeatherStr:dayWeather2];
                self.weatherImage2.image = image2;
                
//                [self.weatherLabel3 setText:dayWeather3];
                [self.weatherLabel3 setText:@"后天"];
                UIImage *image3 = [UIImage imageWithWeatherStr:dayWeather3];
                self.weatherImage3.image = image3;
            }
            
            // 温度范围
            NSString *range = [NSString stringWithFormat:@"%@°~%@°",nightTemp1,dayTemp1];
            [self.tempLabel setText:range];
            
            NSString *range1 = [NSString stringWithFormat:@"%@°~%@°",nightTemp1,dayTemp1];
            [self.tempLabel1 setText:range1];
            
            NSString *range2 = [NSString stringWithFormat:@"%@°~%@°",nightTemp2,dayTemp2];
            [self.tempLabel2 setText:range2];
            
            NSString *range3 = [NSString stringWithFormat:@"%@°~%@°",nightTemp3,dayTemp3];
            [self.tempLabel3 setText:range3];
            
        }else{
            NSLog(@"获取失败,请检查网络设置!");
        }
    }];
}

-(void)handlePanGestures:(UIPanGestureRecognizer *)paramSender
{
    CGPoint point = [paramSender locationInView:self.view];
    CGFloat currentY = point.y;
    
    if (paramSender.state == UIGestureRecognizerStateChanged)
    {
        if (self.downBtn.y >= 150.0 && self.downBtn.y <= kMainScreenSizeHeight - 26.0)
        {
            self.downBtn.y = currentY;
            
            self.mainContainer.y = self.downBtn.y - 150.0;
            
            if (self.downBtn.y != 150.0 || self.downBtn.y != kMainScreenSizeHeight - 26.0)
            {
                self.noticeView.y = self.mainContainer.y - kMainScreenSizeHeight + 176.0;
            }
        }
    }
    
    if (paramSender.state == UIGestureRecognizerStateEnded)
    {
        if (self.downBtn.y < 150.0)
        {
            self.downBtn.y = 150.0;
            self.mainContainer.y = self.downBtn.y - 150.0;
        }
        
        if (self.downBtn.y > kMainScreenSizeHeight - 26.0)
        {
            self.downBtn.y = kMainScreenSizeHeight - 26.0;
            self.mainContainer.y = self.downBtn.y - 150.0;
        }
        
        // 下滑
        if (currentY >= self.downBtn.y)
        {
            NSLog(@"下滑");
            if (self.downBtn.y >= kMainScreenSizeHeight / 2 && self.downBtn.y <= kMainScreenSizeHeight - 26.0)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    self.downBtn.userInteractionEnabled = NO;
                    self.downBtn.y = kMainScreenSizeHeight - 26.0;
                    self.mainContainer.y = self.downBtn.y - 150.0;
                } completion:^(BOOL finished) {
                    self.downBtn.userInteractionEnabled = YES;
                }];
            }
            
            if (self.downBtn.y == kMainScreenSizeHeight - 26.0)
            {
                [self.downBtn setImage:[UIImage imageNamed:@"slide_up"] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.5 animations:^{
                    self.noticeView.y = 0.0;
                }];
                
                [self singleContainerHidden:YES];
            }
            else
            {
                [UIView animateWithDuration:0.5 animations:^{
                    self.noticeView.height = kMainScreenSizeHeight - 176.0;
                }];
                
                [self singleContainerHidden:NO];
            }
        }
        
        // 上滑
        if (currentY <= self.downBtn.y)
        {
            if (self.downBtn.y <= kMainScreenSizeHeight / 2 && self.downBtn.y >= 150.0)
            {
                NSLog(@"上滑");
                [UIView animateWithDuration:0.5 animations:^{
                    self.downBtn.userInteractionEnabled = NO;
                    self.downBtn.y = 150.0;
                    self.mainContainer.y = self.downBtn.y - 150.0;
                } completion:^(BOOL finished) {
                    self.downBtn.userInteractionEnabled = YES;
                }];
            }
            
            if (self.downBtn.y == 150.0)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    self.noticeView.y = -(kMainScreenSizeHeight - 176.0);
                }];
                
                [self singleContainerHidden:NO];
                
                [self.downBtn setImage:[UIImage imageNamed:@"slide_down"] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)singleContainerHidden:(BOOL)isHidden
{
    if (isHidden)
    {
        self.singleContainer.hidden = YES;
        self.mutiContainer.hidden = NO;
    }
    else
    {
        self.singleContainer.hidden = NO;
        self.mutiContainer.hidden = YES;
    }
}

- (void)initTableView
{
    self.tableViewMain = [[UITableView alloc]init];
    self.tableViewMain.delegate = self;
    self.tableViewMain.dataSource = self;
    self.tableViewMain.rowHeight = kMainScreenSizeWidth/4.2;
    self.tableViewMain.showsVerticalScrollIndicator = NO;
    self.tableViewMain.tableFooterView = [[UIView alloc]init];// 设置有数据的时候有分割线,没数据的时候不显示分割线
    self.tableViewMain.tag = TableViewMain;
    [self.view addSubview:self.tableViewMain];
    [self.tableViewMain autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(115.0, 8.0, 80.0, 8.0)];
}

#pragma mark - UITableViewDelegate
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == TableViewMain)
    {
        // 重要,这边不能删除,进行双重过滤
        for (int i = 0; i < self.deviceList.count; i++)
        {
            self.tempDevice = self.deviceList[i];
            
            // 过滤未响应的云设备
            if ([self.tempDevice.strDevName isEqualToString:@"未响应的云设备"] && self.tempDevice.stConnect == 0)
            {
                [self.deviceList removeObject:self.tempDevice];
            }
        }
        
        return self.deviceList.count;
    }
    
    return self.messageList.count + self.adList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TableViewMain)
    {
        XLDevice *device = self.deviceList[indexPath.row];
        
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UIImageView *iconView = [[UIImageView alloc]init];
        NSData *imageData =  [MBDataCache readDataWithUrlString:device.strSN];
        imageData = [MBDataCache readDataWithUrlString:device.strSN];
        if (imageData == NULL) {
            iconView.image = [UIImage imageNamed:@"livingroom"];
        }else{
            iconView.image = [UIImage imageWithData:imageData];
        }
        
        iconView.frame = CGRectMake(5.0, 5.0, kMainScreenSizeWidth/3, kMainScreenSizeWidth/4.7);
        iconView.layer.cornerRadius = 5.0;
        iconView.layer.masksToBounds = YES;
        [cell.contentView addSubview:iconView];
        
        UILabel *stConnectLabel = [[UILabel alloc]init];
        stConnectLabel.font = [UIFont systemFontOfSize:14.0];
        [stConnectLabel setTextColor:[UIColor colorWithHex:0x3C3C3C]];
        int stConnect = device.stConnect;
        if (stConnect == 0)
        {
            [stConnectLabel setText:@"离线"];
            cell.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
        }else if (stConnect == 1){
            [stConnectLabel setText:@"在线"];
        }else if (stConnect == 2){
            [stConnectLabel setText:@"连接中"];
        }
        stConnectLabel.frame = CGRectMake(kMainScreenSizeWidth - 60.0, 10.0, 50.0, 30.0);
        [cell.contentView addSubview:stConnectLabel];
        
        UIImageView *stConnectImageV = [[UIImageView alloc]init];
        
        int linkType = device.linkType;
        if (linkType == 0)
        {
            stConnectImageV.image = [UIImage imageNamed:@"cloud_online"];
        }
        else if (linkType == 1)
        {
            stConnectImageV.image = [UIImage imageNamed:@"wifi_online"];
        }
        stConnectImageV.frame = CGRectMake(CGRectGetMinX(stConnectLabel.frame) - 22.0, 18.0, 20.0, 15.0);
        [cell.contentView addSubview:stConnectImageV];
/*****************************已关机提示*****
        UILabel *deviceCloseLabel = [[UILabel alloc]init];
        deviceCloseLabel.font = [UIFont systemFontOfSize:14.0];
        [deviceCloseLabel setTextColor:[UIColor redColor]];
        deviceCloseLabel.text = @"已关机";
        deviceCloseLabel.textAlignment = NSTextAlignmentCenter;
        deviceCloseLabel.frame = CGRectMake(CGRectGetMinX(stConnectImageV.frame), CGRectGetMaxY(stConnectImageV.frame) + 17.0, CGRectGetMaxX(stConnectLabel.frame) - CGRectGetMinX(stConnectImageV.frame) - 10.0, 30.0);
        if (device.stPower == 0)
        {
            deviceCloseLabel.hidden = NO;
        }
        else
        {
            deviceCloseLabel.hidden = YES;
        }
        [cell.contentView addSubview:deviceCloseLabel];
*******************************************/
        
        UILabel *strDevNameLabel = [[UILabel alloc]init];
        strDevNameLabel.font = [UIFont systemFontOfSize:17.0];
        [strDevNameLabel setTextColor:[UIColor colorWithHex:0x3C3C3C]];
        strDevNameLabel.text = device.strDevName;
        strDevNameLabel.frame = CGRectMake(CGRectGetMaxX(iconView.frame) + 10.0, 10.0, CGRectGetMinX(stConnectImageV.frame) - CGRectGetMaxX(iconView.frame) - 20.0, 30.0);
        [cell.contentView addSubview:strDevNameLabel];
        
        UIImageView *valTempImageV = [[UIImageView alloc]init];
        valTempImageV.image = [UIImage imageNamed:@"temp_icon"];
        valTempImageV.frame = CGRectMake(CGRectGetMaxX(iconView.frame) + 10.0,CGRectGetMaxY(strDevNameLabel.frame) + 15.0, 11.7, 19.5);//18*30
        [cell.contentView addSubview:valTempImageV];
        
        UILabel *valTempLabel = [[UILabel alloc]init];
        [valTempLabel setText:[NSString stringWithFormat:@"%.1f°",(float)device.valTemp/2]];
        valTempLabel.font = [UIFont systemFontOfSize:18.0];
        [valTempLabel setTextColor:[UIColor colorWithHex:0x3C3C3C]];
        valTempLabel.frame = CGRectMake(CGRectGetMaxX(valTempImageV.frame) + 5.0, CGRectGetMaxY(strDevNameLabel.frame) + 10.0, 45.0, 30.0);
        [cell.contentView addSubview:valTempLabel];
        
        UIImageView *valRHImageV = [[UIImageView alloc]init];
        valRHImageV.image = [UIImage imageNamed:@"center_humidity"];
        valRHImageV.frame = CGRectMake(CGRectGetMaxX(valTempLabel.frame) + 30.0, CGRectGetMaxY(strDevNameLabel.frame) + 15.0, 11.7, 19.5);//18*30
        [cell.contentView addSubview:valRHImageV];
        
        UILabel *valRHLabel = [[UILabel alloc]init];
        NSString *valRHStr = [NSString stringWithFormat:@"%d",device.valRH];
        NSString *valRHValue = [valRHStr stringByAppendingString:@"%"];
        [valRHLabel setText:valRHValue];
        valRHLabel.font = [UIFont systemFontOfSize:18.0];
        [valRHLabel setTextColor:[UIColor colorWithHex:0x3C3C3C]];
        valRHLabel.frame = CGRectMake(CGRectGetMaxX(valRHImageV.frame) + 5.0, CGRectGetMaxY(strDevNameLabel.frame) + 10.0, 40.0, 30.0);
        [cell.contentView addSubview:valRHLabel];
        
        [cell setNeedsLayout];
        
        return cell;
    }
    
    static NSString *ID = @"cellMessage";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(50.0, 0, 2.0, 12.0)];
    topView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:topView];
    UIImageView *pointImageView = [[UIImageView alloc]initWithFrame:CGRectMake(45.0, 12.0, 12.0, 12.0)];
    pointImageView.image = [UIImage imageNamed:@"point_null"];
    [cell.contentView addSubview:pointImageView];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(50.0, 24.0, 2.0, 60.0)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:bottomView];
    
    XLMessage *message;
    if (self.messageList.count > 0)
    {
        message = self.messageList[indexPath.row];
    }
    XLAd *ad;
    if (self.adList.count > 0)
    {
        ad = self.adList[indexPath.row];
    }
    NSLog(@"message --- %@ ==== ad --- %@",message,ad);
    
    if (message)
    {
        NSArray *list = [message.push_time componentsSeparatedByString:@" "];// 以空格分割成数组
        NSString *date = list[0];
        NSArray *steps = [date componentsSeparatedByString:@"-"];
        NSString *year = steps[0];
        NSString *month = steps[1];
        NSString *day = steps[2];
        
        NSDateComponents *_comps = [[NSDateComponents alloc] init];
        [_comps setDay:day.integerValue];
        [_comps setMonth:month.integerValue];
        [_comps setYear:year.integerValue];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *_date = [gregorian dateFromComponents:_comps];
        NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:_date];
        NSInteger weekday = [weekdayComponents weekday];
        NSLog(@"_weekday::%zd",weekday);
    }
    
    if (message != NULL)
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 0, kMainScreenSizeWidth - 80.0, 30.0)];
        titleLabel.text = message.push_time;//2016-08-02 11:01:50
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        titleLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:titleLabel];
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 30.0, kMainScreenSizeWidth - 80.0, 20.0)];
        detailLabel.text = [NSString stringWithFormat:@"来自 %@",message.title];
        detailLabel.font = [UIFont systemFontOfSize:14.0];
        detailLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:detailLabel];
        cell.backgroundColor = [UIColor clearColor];
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 50.0, kMainScreenSizeWidth - 80.0, 30.0)];
        contentLabel.text = message.content;
        contentLabel.font = [UIFont systemFontOfSize:16.0];
        contentLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:contentLabel];
    }
    if (ad != NULL)
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 0, kMainScreenSizeWidth - 80.0, 30.0)];
        titleLabel.text = ad.push_time;
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        titleLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:titleLabel];
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 30.0, kMainScreenSizeWidth - 80.0, 20.0)];
        detailLabel.text = [NSString stringWithFormat:@"来自%@",ad.title];
        detailLabel.font = [UIFont systemFontOfSize:14.0];
        detailLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:detailLabel];
        cell.backgroundColor = [UIColor clearColor];
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 50.0, kMainScreenSizeWidth - 80.0, 30.0)];
        contentLabel.text = ad.content;
        contentLabel.font = [UIFont systemFontOfSize:16.0];
        contentLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:contentLabel];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TableViewMain)
    {
        XLDevice *device = self.deviceList[indexPath.row];
        XLControlViewController *control = [[XLControlViewController alloc]init];
        control.titleLabel = device.strDevName;
        NSLog(@"device - strIndex - %@ -- %@",device.strIndex,device.strSN);
        control.strIndex = device.strIndex;
        control.valWorkMode = device.valWorkMode;
        control.valRunMode = device.valRunMode;
        control.valFanSpeed = device.valFanSpeed;
        
        int stConnect = device.stConnect;
        if (stConnect == 0)
        {
            [SVProgressHUD showInfoWithStatus:@"主人:设备已离线,无法控制~" maskType:SVProgressHUDMaskTypeBlack];
        }
        else if (stConnect == 1)
        {
            [self.navigationController pushViewController:control animated:YES];
        }
        else if (stConnect == 2)
        {
            [SVProgressHUD showInfoWithStatus:@"主人:设备正在连接中......        \n请稍候~" maskType:SVProgressHUDMaskTypeBlack];
        }
    }
    else if (tableView.tag ==  TableViewNotice)
    {
        
    }
}

- (void)initBottomView
{
    UIView *container = [[UIView alloc]init];
    container.backgroundColor = [UIColor clearColor];
    [self.view addSubview:container];
    [container autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
    [container autoSetDimension:ALDimensionHeight toSize:82.0];
    
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"device_bottom_bg"];
    [container addSubview:bgView];
    [bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, -82)];
    //95*82
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setImage:[UIImage imageNamed:@"device_setting_nomal"] forState:UIControlStateNormal];
    [settingBtn setImage:[UIImage imageNamed:@"device_setting_press"] forState:UIControlStateHighlighted];
    [settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:settingBtn];
    [settingBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeLeft];
    [settingBtn autoSetDimension:ALDimensionWidth toSize:95.0];
    
    self.switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
    [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateSelected];
    [self.switchBtn setImage:[UIImage imageNamed:@"slide_point"] forState:UIControlStateNormal];
    [self.switchBtn setImage:[UIImage imageNamed:@"slide_point"] forState:UIControlStateHighlighted];
    UIImage *image = [UIImage imageNamed:@"slide_point"];
    self.switchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 35.0);
    self.switchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -image.size.width/2, 0, 0);
    
    [self.switchBtn setTitle:@"OFF" forState:UIControlStateNormal];
    [self.switchBtn setTitle:@"ON" forState:UIControlStateSelected];
    [self.switchBtn addTarget:self action:@selector(switchBtnSelected:) forControlEvents:UIControlEventTouchDown];
    [container addSubview:self.switchBtn];
    [self.switchBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:container withOffset:-18.0];
    [self.switchBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:container withOffset:18.0];
    [self.switchBtn autoSetDimensionsToSize:CGSizeMake(60.0, 25.0)];
    
    UILabel *modelLabel = [[UILabel alloc]init];
    [modelLabel setText:@"离家模式"];
    [modelLabel setTextAlignment:NSTextAlignmentCenter];
    [modelLabel setTextColor:[UIColor colorWithHex:0x3C3C3C]];
    modelLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [container addSubview:modelLabel];
    [modelLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.switchBtn];
    [modelLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.switchBtn];
    [modelLabel autoSetDimensionsToSize:CGSizeMake(100.0, 30.0)];
}

- (void)switchBtnSelected:(UIButton *)button
{
    if (!self.tempDevice.strIndex)  // 保护操作
    {
        return;
    }
    
    XLAppDelegate *appDelegate = (XLAppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.canSoundPlay)
    {
        // 开始播放\继续播放
        [appDelegate.player play];
        [ECMusicTool stopMusic:appDelegate.songs[1]];
        [ECMusicTool playMusic:appDelegate.songs[1]];
    }
    
    if (appDelegate.canVibratePlay)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    UIImage *image = [UIImage imageNamed:@"slide_point"];
    
    if (!button.selected) {
        button.selected = YES;
        [button setTitle:@"ON" forState:UIControlStateSelected];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -image.size.width/2-25, 0, image.size.width/2);
        NSLog(@"ON");
        
        [XLDMITools commandStrCmdWith:@"switchLeaveMode" withStrIndex:self.tempDevice.strIndex withValue:@(1)];
    }else{
        button.selected = NO;
        [button setTitle:@"OFF" forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 35.0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -image.size.width/2, 0, 0);
        NSLog(@"OFF");
        
        [XLDMITools commandStrCmdWith:@"switchLeaveMode" withStrIndex:self.tempDevice.strIndex withValue:@(0)];
    }
}

@end
