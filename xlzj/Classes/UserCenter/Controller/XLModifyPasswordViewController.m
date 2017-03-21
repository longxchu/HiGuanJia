//
//  XLModifyPasswordViewController.m
//  xlzj
//
//  Created by 周绪刚 on 16/5/26.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLModifyPasswordViewController.h"
#import "XLLoginViewController.h"
#import "XLNavigationController.h"

@interface XLModifyPasswordViewController ()
@property (nonatomic ,strong) UITextField *oldPassword;
@property (nonatomic ,strong) UITextField *currentPassword;
@property (nonatomic ,strong) UITextField *confirmPassword;
@end

@implementation XLModifyPasswordViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = kBackgroundColor;
    
    [self initNaviBar];
    
    [self initPwdView];
}

- (void)viewWillAppear:(BOOL)animated
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

- (void)initPwdView
{
    UIView *container = [[UIView alloc]init];
    container.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:container];
    [container autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(35.0, 10.0, 0, 10.0) excludingEdge:ALEdgeBottom];
    [container autoSetDimension:ALDimensionHeight toSize:122.0];
    
    self.oldPassword = [[UITextField alloc]init];
    [self.oldPassword setPlaceholder:@"请输入旧密码"];
    [self.oldPassword setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [self.oldPassword setBorderStyle:UITextBorderStyleNone];
    self.oldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.oldPassword.secureTextEntry = YES;
    [container addSubview:self.oldPassword];
    [self.oldPassword autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 8, 0, 8) excludingEdge:ALEdgeBottom];
    [self.oldPassword autoSetDimension:ALDimensionHeight toSize:40.0];
    
    UIView *oldnewLine = [[UIView alloc]init];
    oldnewLine.backgroundColor = [UIColor lightGrayColor];
    [container addSubview:oldnewLine];
    [oldnewLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(40, 8, 0, 8) excludingEdge:ALEdgeBottom];
    [oldnewLine autoSetDimension:ALDimensionHeight toSize:1.0];
    
    self.currentPassword = [[UITextField alloc]init];
    [self.currentPassword setPlaceholder:@"请输入新密码"];
    [self.currentPassword setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [self.currentPassword setBorderStyle:UITextBorderStyleNone];
    self.currentPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.currentPassword.secureTextEntry = YES;
    [container addSubview:self.currentPassword];
    [self.currentPassword autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(41.0, 8, 0, 8) excludingEdge:ALEdgeBottom];
    [self.currentPassword autoSetDimension:ALDimensionHeight toSize:40.0];
    
    UIView *newconfirmLine = [[UIView alloc]init];
    newconfirmLine.backgroundColor = [UIColor lightGrayColor];
    [container addSubview:newconfirmLine];
    [newconfirmLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(81, 8, 0, 8) excludingEdge:ALEdgeBottom];
    [newconfirmLine autoSetDimension:ALDimensionHeight toSize:1.0];
    
    self.confirmPassword = [[UITextField alloc]init];
    [self.confirmPassword setPlaceholder:@"请再次输入新密码"];
    [self.confirmPassword setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [self.confirmPassword setBorderStyle:UITextBorderStyleNone];
    self.confirmPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.confirmPassword.secureTextEntry = YES;
    [container addSubview:self.confirmPassword];
    [self.confirmPassword autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(82.0, 8, 0, 8) excludingEdge:ALEdgeBottom];
    [self.confirmPassword autoSetDimension:ALDimensionHeight toSize:40.0];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"register"] forState:UIControlStateHighlighted];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    [confirmBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:container withOffset:40.0];
    [confirmBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0];
    [confirmBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0];
    [confirmBtn autoSetDimension:ALDimensionHeight toSize:45.0];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"register"] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    [cancelBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:confirmBtn withOffset:10.0];
    [cancelBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0];
    [cancelBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10.0];
    [cancelBtn autoSetDimension:ALDimensionHeight toSize:45.0];
}

- (void)confirmBtnClick
{
    if ([self.currentPassword.text isEqualToString:self.confirmPassword.text])
    {
        NSLog(@" ---- %@ ----- %@",self.currentPassword.text,self.confirmPassword.text);
        
        [SNAPI userModifyPassword:self.currentPassword.text oldPassword:self.oldPassword.text success:^{
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功" maskType:SVProgressHUDMaskTypeGradient];
            
            XLLoginViewController *login = [[XLLoginViewController alloc]init];
            XLNavigationController *nav = [[XLNavigationController alloc]initWithRootViewController:login];
            [self presentViewController:nav animated:YES completion:nil];
            
            // 保存密码
            NSUserDefaults *password = [NSUserDefaults standardUserDefaults];
            [password setObject:self.currentPassword.text forKey:@"password"];
            
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.domain]];
        }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致,请重新输入" maskType:SVProgressHUDMaskTypeGradient];
    }
}

- (void)cancelBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
