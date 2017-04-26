//
//  XLLoginViewController.m
//  xlzj
//
//  Created by zhouxg on 16/5/18.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLLoginViewController.h"
#import "XLRegisterViewController.h"
#import "XLForgetViewContrller.h"
#import "XLHomeViewController.h"

@interface XLLoginViewController ()
@property (nonatomic ,strong) UITextField *userName;
@property (nonatomic ,strong) UITextField *password;
@end

@implementation XLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"Hi!管家";
    
    [self LoginAndRegisterBtns];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self NaviBarShow:YES];
    
    [self initContainer];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initContainer
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

    
    NSUserDefaults *user_account = [NSUserDefaults standardUserDefaults];
    NSString *account = [user_account objectForKey:@"userName"];
    NSUserDefaults *user_password = [NSUserDefaults standardUserDefaults];
    NSString *password = [user_password objectForKey:@"password"];
    
    UIView *container = [[UIView alloc]init];
    [container setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:container];
    [container autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(30, 20, 0, 20) excludingEdge:ALEdgeBottom];
    [container autoSetDimension:ALDimensionHeight toSize:100.0];
    
    UIImageView *userImage = [[UIImageView alloc]init];
    [userImage setImage:[UIImage imageNamed:@"username"]];
    [container addSubview:userImage];
    [userImage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:container withOffset:8.0];
    [userImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:container withOffset:16.0];
    [userImage autoSetDimensionsToSize:CGSizeMake(32.0, 32.0)];
    
    self.userName = [[UITextField alloc]init];
    [self.userName setKeyboardType:UIKeyboardTypeNumberPad];
    [self.userName setBorderStyle:UITextBorderStyleNone];
    self.userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    if (account == nil) {
        [self.userName setPlaceholder:@"请输入用户名"];
    }else{
        [self.userName setText:[NSString stringWithFormat:@"%@",account]];
    }
    
    [container addSubview:self.userName];
    [self.userName autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:container withOffset:8.0];
    [self.userName autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:userImage withOffset:8.0];
    [self.userName autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:container withOffset:-8.0];
    [self.userName autoSetDimension:ALDimensionHeight toSize:32.0];
    
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
    
    self.password = [[UITextField alloc]init];
    self.password.secureTextEntry = YES;
    [self.password setBorderStyle:UITextBorderStyleNone];
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (password == nil) {
        [self.password setPlaceholder:@"请输入密码"];
    }else{
        [self.password setText:[NSString stringWithFormat:@"%@",password]];
    }
    [container addSubview:self.password];
    [self.password autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:passwordImage withOffset:8.0];
    [self.password autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:container withOffset:-8.0];
    [self.password autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:container withOffset:-8.0];
    [self.password autoSetDimension:ALDimensionHeight toSize:32.0];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    [forgetBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:container withOffset:35.0];
    [forgetBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:container withOffset:-16.0];
    [forgetBtn autoSetDimensionsToSize:CGSizeMake(100, 30)];
}

- (void)LoginAndRegisterBtns
{
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"register"] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(220, 40, 0, 40) excludingEdge:ALEdgeBottom];
    [loginBtn autoSetDimension:ALDimensionHeight toSize:40.0];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"无账户?快速注册" forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"register"] forState:UIControlStateHighlighted];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    [registerBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(280, 40, 0, 40) excludingEdge:ALEdgeBottom];
    [registerBtn autoSetDimension:ALDimensionHeight toSize:40.0];
}

- (void)forgetBtnClick
{
    XLForgetViewContrller *forget = [[XLForgetViewContrller alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
}

- (void)loginBtnClick
{
    // 登录
    [SNAPI userLoginWithAccount:self.userName.text password:self.password.text areaCode:area_Code success:^{
        NSLog(@"无 token 登录成功");
        XLHomeViewController *home = [[XLHomeViewController alloc]init];
        [self.navigationController pushViewController:home animated:YES];
        [SVProgressHUD showSuccessWithStatus:@"登录成功" maskType:SVProgressHUDMaskTypeGradient];
        
        // 保存用户名
        NSUserDefaults *userName = [NSUserDefaults standardUserDefaults];
        [userName setObject:self.userName.text forKey:@"userName"];
        // 保存密码
        NSUserDefaults *password = [NSUserDefaults standardUserDefaults];
        [password setObject:self.password.text forKey:@"password"];
        
        // 进行一次 mqtt 连接(重要不可删除)
        [SNMqtt connect];
        
        NSLog(@"登录成功 --- ");
        // 归档帐号
        [SNAccount saveAccount:self.userName.text password:self.password.text areaCode:area_Code];
        
        // 5. 获取用户基本信息
        [SNAPI userInfoSuccess:^(SNUser *user) {
            //            self.user = user;
            XLAppDelegate *app = (XLAppDelegate *)[UIApplication sharedApplication].delegate;
            app.user = user;
        } failure:^(NSError *error) {
            //        NSLog(@"获取用户基本信息失败");
        }];
        
        [self initDMI];
        
    } failure:^(NSError *error) {
//        NSLog(@"无 token 登录失败 %@",error.domain);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.domain]];
    }];
    
#pragma mark - 提示设备不存在代码
//    [SNAPI setFailureHanlder:^(NSError *error) {
////        NSLog(@"登录失败 --- %@",error.domain);
//        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.domain]];
//    }];
}

- (void)registerBtnClick
{
    XLRegisterViewController *registerVC = [[XLRegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.userName endEditing:YES];
    [self.password endEditing:YES];
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

@end
