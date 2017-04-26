//
//  XLForgetViewContrller.m
//  xlzj
//
//  Created by zhouxg on 16/5/19.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLForgetViewContrller.h"
#import "XLLoginViewController.h"

@interface XLForgetViewContrller ()
@property (nonatomic ,strong) UIView *namePwdContainer;
// 手机号
@property (nonatomic ,strong) UITextField *account;
// 密码
@property (nonatomic ,strong) UITextField *password;
// 确认密码
@property (nonatomic ,strong) UITextField *confirmPassword;
// 验证码
@property (nonatomic ,strong) UITextField *validCode;
@property (nonatomic, copy) NSString *ticket;
@end

@implementation XLForgetViewContrller

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"找回密码";
    self.view.backgroundColor = kBackgroundColor;
    
    [self initNaviBar];
    
    [self initNamePwdContainer];
    
    [self initvalidCodeContainer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self NaviBarShow:YES];
}

- (void)initNaviBar
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"back"];
    backBtn.frame = CGRectMake(0, 0, image.size.width/2, image.size.height/2);
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

- (void)initNamePwdContainer
{
    self.namePwdContainer = [[UIView alloc]init];
    self.namePwdContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.namePwdContainer];
    [self.namePwdContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(30, 20, 0, 20) excludingEdge:ALEdgeBottom];
    [self.namePwdContainer autoSetDimension:ALDimensionHeight toSize:148.0];
    
    self.account = [[UITextField alloc]init];
    [self.account setPlaceholder:@"请输入您的手机号"];
    [self.account setKeyboardType:UIKeyboardTypeNumberPad];
    [self.account setBorderStyle:UITextBorderStyleNone];
    self.account.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.account.font = [UIFont systemFontOfSize:16.0];
    [self.namePwdContainer addSubview:self.account];
    [self.account autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.namePwdContainer withOffset:8.0];
    [self.account autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.namePwdContainer withOffset:40.0];
    [self.account autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.namePwdContainer withOffset:-40.0];
    [self.account autoSetDimension:ALDimensionHeight toSize:32.0];
    
    UIView *lineView1 = [[UIView alloc]init];
    [lineView1 setBackgroundColor:[UIColor lightGrayColor]];
    [self.namePwdContainer addSubview:lineView1];
    [lineView1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.account withOffset:8.0];
    [lineView1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.namePwdContainer withOffset:36.0];
    [lineView1 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.namePwdContainer withOffset:-36.0];
    [lineView1 autoSetDimension:ALDimensionHeight toSize:1.0];
    
    self.password = [[UITextField alloc]init];
    [self.password setPlaceholder:@"请输入新密码"];
    self.password.secureTextEntry = YES;
    [self.password setBorderStyle:UITextBorderStyleNone];
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password.font = [UIFont systemFontOfSize:16.0];
    [self.namePwdContainer addSubview:self.password];
    [self.password autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.namePwdContainer withOffset:40.0];
    [self.password autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.namePwdContainer withOffset:-40.0];
    [self.password autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:lineView1 withOffset: 8.0];
    [self.password autoSetDimension:ALDimensionHeight toSize:32.0];
    
    UIView *lineView2 = [[UIView alloc]init];
    [lineView2 setBackgroundColor:[UIColor lightGrayColor]];
    [self.namePwdContainer addSubview:lineView2];
    [lineView2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.password withOffset:8.0];
    [lineView2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.namePwdContainer withOffset:36.0];
    [lineView2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.namePwdContainer withOffset:-36.0];
    [lineView2 autoSetDimension:ALDimensionHeight toSize:1.0];
    
    self.confirmPassword = [[UITextField alloc]init];
    [self.confirmPassword setPlaceholder:@"请确认新密码"];
    self.confirmPassword.secureTextEntry = YES;
    [self.confirmPassword setBorderStyle:UITextBorderStyleNone];
    self.confirmPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.confirmPassword.font = [UIFont systemFontOfSize:16.0];
    [self.namePwdContainer addSubview:self.confirmPassword];
    [self.confirmPassword autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.namePwdContainer withOffset:40.0];
    [self.confirmPassword autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.namePwdContainer withOffset:-40.0];
    [self.confirmPassword autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineView2 withOffset:8.0];
    [self.confirmPassword autoSetDimension:ALDimensionHeight toSize:32.0];
}

- (void)initvalidCodeContainer
{
    UIView *container = [[UIView alloc]init];
    container.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:container];
    [container autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.namePwdContainer withOffset:25.0];
    [container autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:20.0];
    [container autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-20.0];
    [container autoSetDimension:ALDimensionHeight toSize:40.0];
    
    self.validCode = [[UITextField alloc]init];
    [self.validCode setPlaceholder:@"输入验证码"];
    [self.validCode setKeyboardType:UIKeyboardTypeNumberPad];
    [self.validCode setBorderStyle:UITextBorderStyleNone];
    self.validCode.font = [UIFont systemFontOfSize:16.0];
    [container addSubview:self.validCode];
    [self.validCode autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 20, 0, 0) excludingEdge:ALEdgeRight];
    [self.validCode autoSetDimension:ALDimensionWidth toSize:(kMainScreenSizeWidth - 40)/2 - 20];
    
    UIView *horizon = [[UIView alloc]init];
    [horizon setBackgroundColor:[UIColor blackColor]];
    [container addSubview:horizon];
    [horizon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [horizon autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [horizon autoSetDimensionsToSize:CGSizeMake(1.0, 30.0)];
    
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [postBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [postBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [postBtn addTarget:self action:@selector(postBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:postBtn];
    [postBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeLeft];
    [postBtn autoSetDimension:ALDimensionWidth toSize:(kMainScreenSizeWidth - 40)/2 - 1];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"register"] forState:UIControlStateHighlighted];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:confirmBtn];
    [confirmBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:container withOffset:30.0];
    [confirmBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:40.0];
    [confirmBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-40.0];
    [confirmBtn autoSetDimension:ALDimensionHeight toSize:40.0];
}

- (void)postBtnClick
{
    // 发送短信验证码
    [SNAPI commonMessageValidWithMobile:self.account.text type:0 areaCode:area_Code success:^(NSString *ticket) {
        NSLog(@"ticket ------ %@",ticket);
        self.ticket = ticket;
        [SVProgressHUD showSuccessWithStatus:@"验证码发送成功" maskType:SVProgressHUDMaskTypeGradient];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.domain]];
    }];
}

- (void)confirmBtnClick
{
    if ([self.password.text isEqualToString:self.confirmPassword.text])
    {
        [SNAPI userForgotPasswordMobilWithPassword:self.password.text ticket:self.ticket validCode:self.validCode.text success:^{
            [SVProgressHUD showSuccessWithStatus:@"密码重置成功" maskType:SVProgressHUDMaskTypeGradient];
            // 归档帐号
            [SNAccount saveAccount:self.account.text password:self.password.text areaCode:area_Code];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.domain]];
        }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"两次密码不一致,请重新输入!"]];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
