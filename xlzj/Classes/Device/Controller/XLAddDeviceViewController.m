//
//  XLAddDeviceViewController.m
//  xlzj
//
//  Created by 周绪刚 on 16/5/25.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLAddDeviceViewController.h"
#import "XLRippleView.h"
#import "elian.h"
#import "XLDevice.h"
#import "XLDeviceViewController.h"

#define DEVICE_IS_IPHONE6P ([[UIScreen mainScreen] bounds].size.width == 414)

@interface XLAddDeviceViewController ()<GCDAsyncUdpSocketDelegate>
/**  水波纹 */
@property (nonatomic ,strong) XLRippleView *rippleView;
/**  wifi 帐号 */
@property (nonatomic ,strong) UITextField *wifiName;
/**  密码 */
@property (nonatomic ,strong) UITextField *wifiPassword;
/**  心跳包 */
@property (nonatomic ,strong) GCDAsyncUdpSocket *udpSocket;
/**  添加设备 */
@property (nonatomic ,strong) UIButton *addDeviceBtn;

@property (nonatomic ,strong) NSMutableSet *allDeviceSet;
/**  存放所有设备的集合 */
@property (nonatomic ,strong) NSMutableArray *allDeviceArray;
/**  扫描完成 */
@property (nonatomic ,assign) BOOL scanFinish;
/**  定时器 */
@property (nonatomic ,strong) NSTimer *timer;
/**  定时器总计数 */
@property (nonatomic ,assign) int timeTotal;
@end

@implementation XLAddDeviceViewController

static void *context;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加设备";
    self.view.backgroundColor = kBackgroundColor;
    
    [self initNaviBar];
    
    [self initImageView];
    
    [self initContainer];
    
    [self initAddDeviceContainer];
    
    NSString *netStatus = [SNTool getNetWorkStates];
    NSLog(@"当前网络状态 --- %@",netStatus);
    // 设置扫描成功状态
    self.scanFinish = NO;
    
    // 初始化设备集合
    self.allDeviceArray = [[NSMutableArray alloc]init];
    self.allDeviceSet = [NSMutableSet set];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self NaviBarShow:YES];
    
    self.timeTotal = 90;
    
    [XLDMITools commandStrCmdWith:@"stopDMIComm" withStrIndex:@"" withValue:@(1)];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 1. 停止水波纹
    [self.rippleView stopRippleAnimation];
    // 2. 关闭定时器并销毁
    [self.timer invalidate];
    self.timer = nil;
    // 3. 关闭socket
    [self.udpSocket close];
    NSLog(@"XLAddDeviceViewController -- viewWillDisappear");
    
    [XLDMITools commandStrCmdWith:@"stopDMIComm" withStrIndex:@"" withValue:@(0)];
}

- (void)initNaviBar
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"back"];
    backBtn.frame = CGRectMake(0, 0, image.size.width/2 * 1.2, image.size.height/2 * 1.2);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setBackgroundImage:image forState:UIControlStateSelected];
    [backBtn setBackgroundImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initImageView
{
    UIImageView *adviseImageView = [[UIImageView alloc]init];
    adviseImageView.image = [UIImage imageNamed:@"advertisement"];
    [self.view addSubview:adviseImageView];
    [adviseImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(30.0, 10.0, 0, 10.0) excludingEdge:ALEdgeBottom];
    [adviseImageView autoSetDimension:ALDimensionHeight toSize:100.0];
}

- (void)initContainer
{
    UIView *container = [[UIView alloc]init];
    [container setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:container];
    [container autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(140, 20, 0, 20) excludingEdge:ALEdgeBottom];
    [container autoSetDimension:ALDimensionHeight toSize:100.0];
    
    UIImageView *wifiImage = [[UIImageView alloc]init];
    [wifiImage setImage:[UIImage imageNamed:@"wifi"]];
    [container addSubview:wifiImage];
    [wifiImage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:container withOffset:8.0];
    [wifiImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:container withOffset:16.0];
    [wifiImage autoSetDimensionsToSize:CGSizeMake(32.0, 32.0)];
    
    self.wifiName = [[UITextField alloc]init];
    [self.wifiName setPlaceholder:@"请输入用户名"];
    [self.wifiName setKeyboardType:UIKeyboardTypeNumberPad];
    [self.wifiName setBorderStyle:UITextBorderStyleNone];
    self.wifiName.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSString *wifi = [SNTool SSID];
    [self.wifiName setText:wifi];
    [container addSubview:self.wifiName];
    [self.wifiName autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:container withOffset:8.0];
    [self.wifiName autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:wifiImage withOffset:8.0];
    [self.wifiName autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:container withOffset:-8.0];
    [self.wifiName autoSetDimension:ALDimensionHeight toSize:32.0];
    
    UIView *lineView = [[UIView alloc]init];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [container addSubview:lineView];
    [lineView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:container];
    [lineView autoAlignAxis:ALAxisVertical toSameAxisOfView:container];
    [lineView autoSetDimensionsToSize:CGSizeMake(kMainScreenSizeWidth - 72, 1.0)];
    
    UIImageView *passwordImage = [[UIImageView alloc]init];
    [passwordImage setImage:[UIImage imageNamed:@"password"]];
    [container addSubview:passwordImage];
    [passwordImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:container withOffset:-8.0];
    [passwordImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:container withOffset:16.0];
    [passwordImage autoSetDimensionsToSize:CGSizeMake(32.0, 32.0)];
    
    self.wifiPassword = [[UITextField alloc]init];
    [self.wifiPassword setPlaceholder:@"请输入当前WIFI密码"];
    self.wifiPassword.secureTextEntry = YES;
    [self.wifiPassword setBorderStyle:UITextBorderStyleNone];
    self.wifiPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    [container addSubview:self.wifiPassword];
    [self.wifiPassword autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:passwordImage withOffset:8.0];
    [self.wifiPassword autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:container withOffset:-8.0];
    [self.wifiPassword autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:container withOffset:-8.0];
    [self.wifiPassword autoSetDimension:ALDimensionHeight toSize:32.0];
    
    UIButton *showPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showPwdBtn setBackgroundImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    [showPwdBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    showPwdBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [showPwdBtn addTarget:self action:@selector(showPwdBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showPwdBtn];
    [showPwdBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:container withOffset:20.0];
    [showPwdBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:container withOffset:15.0];
    [showPwdBtn autoSetDimensionsToSize:CGSizeMake(18.0, 16.0)];
    
    UILabel *showPwdLabel = [[UILabel alloc]init];
    [showPwdLabel setText:@"显示密码"];
    [showPwdLabel setTextAlignment:NSTextAlignmentLeft];
    [showPwdLabel setTextColor:[UIColor lightGrayColor]];
    showPwdLabel.font = [UIFont systemFontOfSize:13.0];
    [self.view addSubview:showPwdLabel];
    [showPwdLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:container withOffset:21.0];
    [showPwdLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:showPwdBtn withOffset:5.0];
    [showPwdLabel autoSetDimensionsToSize:CGSizeMake(60.0, 13.0)];
}

- (void)initAddDeviceContainer
{
    self.addDeviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat W = kMainScreenSizeWidth/3;
    CGFloat X = (kMainScreenSizeWidth - W) / 2;
    CGFloat Y = kMainScreenSizeHeight - 300;
    
    if (DEVICE_IS_IPHONE6P)
    {
        self.addDeviceBtn.frame = CGRectMake(X, Y + 6, W, W);
    }
    else
    {
        self.addDeviceBtn.frame = CGRectMake(X, Y, W, W);
    }
    
    self.addDeviceBtn.backgroundColor = kTextColor;
    self.addDeviceBtn.layer.cornerRadius = kMainScreenSizeWidth/6;
    self.addDeviceBtn.layer.masksToBounds = YES;
    [self.addDeviceBtn setTitle:@"添加设备" forState:UIControlStateNormal];
    self.addDeviceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self.addDeviceBtn addTarget:self action:@selector(addDeviceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.addDeviceBtn.titleLabel.numberOfLines = 0;
    [self.view addSubview:self.addDeviceBtn];
    
    self.rippleView = [[XLRippleView alloc]init];
    self.rippleView.minRadius = W/2;
    self.rippleView.frame = CGRectMake(X, (Y + W/2), W, W);
//    self.rippleView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.rippleView];
}

- (void)showPwdBtnSelected:(UIButton *)button
{
    if (!button.selected)
    {
        button.selected = YES;
        self.wifiPassword.secureTextEntry = NO;
    }
    else
    {
        button.selected = NO;
        self.wifiPassword.secureTextEntry = YES;
    }
}

- (void)addDeviceBtnClick
{
    NSString *temp1 = @",";
    NSString *temp2 = @"/";
    NSString *temp3 = @" ";
    // 过滤密码特殊字符
    if ([self.wifiPassword.text containsString:temp1] ||[self.wifiPassword.text containsString:temp2] ||[self.wifiPassword.text containsString:temp3])
    {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"请不要在SSID和密码中包含不支持的字符，如 , / 空格和中文" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertV show];
        
        return;
    }
    else
    {
        // 判断是不是包含中文
        int length = (int)[self.wifiPassword.text length];
        for (int i = 0; i < length; ++i)
        {
            NSRange range = NSMakeRange(i, 1);
            NSString *subString = [self.wifiPassword.text substringWithRange:range];
            const char *cString = [subString UTF8String];
            if (strlen(cString) == 3)
            {
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"请不要在SSID和密码中包含不支持的字符，如 , / 空格和中文" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertV show];
                
                return;
            }
        }
    }
    
    // 过滤 SSID 特殊字符
    if ([self.wifiName.text containsString:temp1] ||[self.wifiName.text containsString:temp2] ||[self.wifiName.text containsString:temp3])
    {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"请不要在SSID和密码中包含不支持的字符，如 , / 空格和中文" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertV show];
        
        return;
    }
    else
    {
        // 判断是不是包含中文
        int length = (int)[self.wifiName.text length];
        for (int i = 0; i < length; ++i)
        {
            NSRange range = NSMakeRange(i, 1);
            NSString *subString = [self.wifiName.text substringWithRange:range];
            const char *cString = [subString UTF8String];
            if (strlen(cString) == 3)
            {
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"请不要在SSID和密码中包含不支持的字符，如 , / 空格和中文" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertV show];
                
                return;
            }
        }
    }
    /******************************** 建立心跳包 **********************************/
    // 初始化udpSocket
    if (self.udpSocket != nil)
    {
        self.udpSocket = nil;
    }
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    // 绑定特殊端口,不可修改
    [self.udpSocket bindToPort:5000 error:&error];
    if (error)
    {
        // 弹出错误信息
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"系统提示" message:error.description delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertV show];
    }
    else
    {
        // 开始接收数据
        [self.udpSocket beginReceiving:nil];
        // 允许广播
        [self.udpSocket enableBroadcast:YES error:nil];
        
        /******************************** 一键配置 **********************************/
        const char *ssid = [self.wifiName.text cStringUsingEncoding:NSASCIIStringEncoding];
        const char *s_authmode = [@"9" cStringUsingEncoding:NSASCIIStringEncoding];
        int authmode = atoi(s_authmode);
        const char *password = [self.wifiPassword.text cStringUsingEncoding:NSASCIIStringEncoding];
        unsigned char target[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
        
        NSLog(@"OnSend: ssid = %s, authmode = %d, password = %s", ssid, authmode, password);
        
        if (context)
        {
            elianStop(context);
            elianDestroy(context);
            context = NULL;
        }
        
        // elianPut
        context = elianNew(NULL, 0, target, ELIAN_SEND_V1);
        if (context == NULL)
        {
            NSLog(@"OnSend elianNew fail");
            return;
        }
        
        elianPut(context, TYPE_ID_AM, (char *)&authmode, 1);
        elianPut(context, TYPE_ID_SSID, (char *)ssid, (int)strlen(ssid));
        elianPut(context, TYPE_ID_PWD, (char *)password, (int)strlen(password));
        
        elianStart(context);
        /******************************** 一键配置 **********************************/
        
        self.rippleView.rippleColor = kTextColor;
        self.rippleView.rippleWidth = 3.0;
        self.rippleView.animationTime = 3.04;
        [self.rippleView startRippleAnimation];
        
        self.addDeviceBtn.userInteractionEnabled = NO;
        self.addDeviceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        
        /** 创建定时器 */
        [self.addDeviceBtn setTitle:[NSString stringWithFormat:@"正在扫描...%d",self.timeTotal] forState:UIControlStateNormal];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        [self.timer fire];
    }
    /******************************** 建立心跳包 **********************************/
}

- (void)timeFireMethod
{
    if (self.scanFinish == NO)  // 未扫描成功一直进行扫描,直到0为止
    {
        if (self.timeTotal == 0)
        {
            // 1. 改变按钮文字和状态
            [self.addDeviceBtn setTitle:@"重试" forState:UIControlStateNormal];
            self.addDeviceBtn.userInteractionEnabled = YES;
            // 2. 停止定时器
            [self.timer invalidate];
            // 3. 设置水波纹
            [self.rippleView stopRippleAnimation];
            // 4. 关闭socket
            [self.udpSocket close];
            // 5. 重新设置总时间
            self.timeTotal = 90;
        }
        else
        {
            [self.addDeviceBtn setTitle:[NSString stringWithFormat:@"正在扫描...\n        %d",self.timeTotal] forState:UIControlStateNormal];
        }
    }
    else                    // 扫描成功,停止定时器,改变按钮文字
    {
		if(self.timeTotal == 5 && self.allDeviceArray.count > 0)
		{
			// 迭代遍历
			[self.addDeviceBtn setTitle:@"正在添加" forState:UIControlStateNormal];// @"正在添加"
            
            for (XLDevice *device in self.allDeviceArray)
            {
                [SNAPI deviceAddWithDeviceID:device.deviceID title:nil type:device.deviceType model:nil productID:nil hardwareVersion:nil success:^{
                } failure:^(NSError *error) {
                }];
            }
		}
		else if(self.timeTotal == 1)
		{
			// 1. 关闭水波纹
			[self.rippleView stopRippleAnimation];
			// 2. 设置按钮状态
			[self.addDeviceBtn setTitle:@"添加成功" forState:UIControlStateNormal];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
                } failure:^(NSError *error) {
                    NSLog(@"error --- %@",error.domain);
                }];
            });
		}
		else if(self.timeTotal == 0)
		{
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"新添加%zd个设备",self.allDeviceArray.count] maskType:SVProgressHUDMaskTypeBlack];
            [self.navigationController popViewControllerAnimated:YES];
		}
    }
	
    self.timeTotal--;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - GCDAsyncUdpSocketDelegate
#pragma mark -
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"Message didSendDataWithTag");
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"Message didNotSendDataWithTag: %@",error);
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    // /105F8C882B0001CA/type/1/1
    NSString *message = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@" ---------- %@",message);
    
    NSArray *arr = [message componentsSeparatedByString:@"/"];
    
    // 105F8C882B0001CA
    NSString *deviceID = [[arr objectAtIndex:1]substringWithRange:NSMakeRange(0, 16)];
    
    // 1
    NSString *deviceType = [arr[4] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    // 初始化设备对象
    XLDevice *deviceTemp = [[XLDevice alloc]init];
    deviceTemp.deviceID = deviceID;
    deviceTemp.deviceType = deviceType;
    
    BOOL canAdd = YES;
    
    for (XLDevice *device in self.allDeviceArray)
    {
        if ([device.deviceID isEqualToString:deviceTemp.deviceID])
        {
            canAdd = NO;
        }
    }
    
    if (canAdd == YES)
    {
        [self.allDeviceArray addObject:deviceTemp];
    }
    
    NSLog(@"ID:%@ TYPE:%@",deviceID,deviceType);
    
    if (self.allDeviceArray.count > 0 && self.timeTotal < 60)
    {
        self.scanFinish = YES;
        
        // 3. 停止一键配置
        if (context)
        {
            elianStop(context);
            elianDestroy(context);
            context = NULL;
            // 4. 关闭socket
            [self.udpSocket close];
            // 5. 关闭定时器,调整时间
            //[self.timer invalidate];
			
			
            self.timeTotal = 5;
        }
    }
}

-(void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"Message withError: %@",error);
}

@end
