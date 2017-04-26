//
//  XLRegisterViewController.m
//  xlzj
//
//  Created by zhouxg on 16/5/19.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLRegisterViewController.h"
#import "XLLoginViewController.h"

@interface XLRegisterViewController ()
// 用户手机号
@property (nonatomic ,strong) UITextField *userName;
// 密码
@property (nonatomic ,strong) UITextField *password;
// 确认密码
@property (nonatomic ,strong) UITextField *confirmPassword;
// 验证码
@property (nonatomic ,strong) UITextField *validCode;
// ticket
@property (nonatomic, copy) NSString *ticket;
@end

@implementation XLRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快速注册";
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
    UIView *container = [[UIView alloc]init];
    [container setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:container];
    [container autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(30, 20, 0, 20) excludingEdge:ALEdgeBottom];
    [container autoSetDimension:ALDimensionHeight toSize:150.0];
    
    UIImageView *userImage = [[UIImageView alloc]init];
    [userImage setImage:[UIImage imageNamed:@"username"]];
    [container addSubview:userImage];
    [userImage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:container withOffset:8.0];
    [userImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:container withOffset:16.0];
    [userImage autoSetDimensionsToSize:CGSizeMake(32.0, 32.0)];
    
    self.userName = [[UITextField alloc]init];
    [self.userName setPlaceholder:@"请输入您的手机号"];
    [self.userName setKeyboardType:UIKeyboardTypeNumberPad];
    [self.userName setBorderStyle:UITextBorderStyleNone];
    self.userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userName.font = [UIFont systemFontOfSize:16.0];
    [container addSubview:self.userName];
    [self.userName autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:container withOffset:8.0];
    [self.userName autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:userImage withOffset:8.0];
    [self.userName autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:container withOffset:-8.0];
    [self.userName autoSetDimension:ALDimensionHeight toSize:32.0];
    
    UIView *lineView1 = [[UIView alloc]init];
    [lineView1 setBackgroundColor:[UIColor lightGrayColor]];
    [container addSubview:lineView1];
    [lineView1 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(48.0, 36.0, 0, 36.0) excludingEdge:ALEdgeBottom];
    [lineView1 autoSetDimensionsToSize:CGSizeMake(kMainScreenSizeWidth - 72, 1.0)];
    
    UIImageView *passwordImage = [[UIImageView alloc]init];
    [passwordImage setImage:[UIImage imageNamed:@"password"]];
    [container addSubview:passwordImage];
    [passwordImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineView1 withOffset:8.0];
    [passwordImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:container withOffset:16.0];
    [passwordImage autoSetDimensionsToSize:CGSizeMake(32.0, 32.0)];
    
    self.password = [[UITextField alloc]init];
    [self.password setPlaceholder:@"请输入密码"];
    self.password.secureTextEntry = YES;
    [self.password setBorderStyle:UITextBorderStyleNone];
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password.font = [UIFont systemFontOfSize:16.0];
    [container addSubview:self.password];
    [self.password autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineView1 withOffset:8.0];
    [self.password autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:passwordImage withOffset:8.0];
    [self.password autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:container withOffset:-8.0];
    [self.password autoSetDimension:ALDimensionHeight toSize:32.0];
    
    UIView *lineView2 = [[UIView alloc]init];
    [lineView2 setBackgroundColor:[UIColor lightGrayColor]];
    [container addSubview:lineView2];
    [lineView2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.password withOffset:8.0];
    [lineView2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:container withOffset:36.0];
    [lineView2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:container withOffset:-36.0];
    [lineView2 autoSetDimension:ALDimensionHeight toSize:1.0];
    
    UIImageView *confirmPasswordImage = [[UIImageView alloc]init];
    [confirmPasswordImage setImage:[UIImage imageNamed:@"password"]];
    [container addSubview:confirmPasswordImage];
    [confirmPasswordImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineView2 withOffset:8.0];
    [confirmPasswordImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:container withOffset:16.0];
    [confirmPasswordImage autoSetDimensionsToSize:CGSizeMake(32.0, 32.0)];
    
    self.confirmPassword = [[UITextField alloc]init];
    [self.confirmPassword setPlaceholder:@"请确认密码"];
    self.confirmPassword.secureTextEntry = YES;
    [self.confirmPassword setBorderStyle:UITextBorderStyleNone];
    self.confirmPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.confirmPassword.font = [UIFont systemFontOfSize:16.0];
    [container addSubview:self.confirmPassword];
    [self.confirmPassword autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineView2 withOffset:8.0];
    [self.confirmPassword autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:confirmPasswordImage withOffset:8.0];
    [self.confirmPassword autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:container withOffset:-8.0];
    [self.confirmPassword autoSetDimension:ALDimensionHeight toSize:32.0];
}

- (void)initvalidCodeContainer
{
    UIView *container = [[UIView alloc]init];
    container.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:container];
    [container autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.confirmPassword withOffset:25.0];
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
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:registerBtn];
    [registerBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:container withOffset:30.0];
    [registerBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:40.0];
    [registerBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-40.0];
    [registerBtn autoSetDimension:ALDimensionHeight toSize:40.0];
}

- (void)postBtnClick
{
    [SNAPI commonMessageValidWithMobile:self.userName.text type:1 areaCode:area_Code success:^(NSString *ticket) {
        self.ticket = ticket;
        [SVProgressHUD showSuccessWithStatus:@"验证码发送成功" maskType:SVProgressHUDMaskTypeGradient];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.domain]];
    }];
}

- (void)registerBtnClick
{
    if ([self.password.text isEqualToString:self.confirmPassword.text])
    {
        [SNAPI userRegisterMobileWithEmail:self.userName.text password:self.password.text type:1 ticket:self.ticket validCode:self.validCode.text success:^(NSString *userDigit) {
            NSLog(@"success:%@",userDigit);
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
    [self.userName endEditing:YES];
    [self.password endEditing:YES];
    [self.validCode endEditing:YES];
}
@end
