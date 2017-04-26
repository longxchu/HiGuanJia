//
//  XLChangeNameViewController.m
//  xlzj
//
//  Created by zhouxg on 16/5/19.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLChangeNameViewController.h"
#import "XLUserCenterViewController.h"

@interface XLChangeNameViewController ()
@property (nonatomic ,strong) UITextField *currentName;
@end

@implementation XLChangeNameViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改昵称";
    self.view.backgroundColor = kBackgroundColor;
    
    [self initNaviBar];
    
    [self initContainer];
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
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 60, 45);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)backButtonPressed
{
    XLUserCenterViewController *userCenter = [[XLUserCenterViewController alloc]init];
    userCenter.nickName = self.currentName.text;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initContainer
{
    UIView *container = [[UIView alloc]init];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.masksToBounds = YES;
    container.layer.cornerRadius = 9.0;
    [self.view addSubview:container];
    [container autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(30, 20, 0, 20) excludingEdge:ALEdgeBottom];
    [container autoSetDimension:ALDimensionHeight toSize:50.0];
    
    self.currentName = [[UITextField alloc]init];
    [self.currentName setPlaceholder:@"请输入新昵称"];
    [self.currentName setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [self.currentName setBorderStyle:UITextBorderStyleNone];
    self.currentName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [container addSubview:self.currentName];
    [self.currentName autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 20, 0, -4)];
}

- (void)saveBtnClick
{
    if ([_currentName.text isEqualToString:@""])
    {
        return;
    }
    
    [SNAPI userModifyBaseWithUserAddress:nil userPhone:nil userNickname:self.currentName.text userSex:nil success:^{
        [SVProgressHUD showSuccessWithStatus:@"昵称修改成功!" maskType:SVProgressHUDMaskTypeBlack];
        //点击保存自动返回方法
        [self performSelector:@selector(BackToLastNavi) withObject:nil afterDelay:1.0];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"昵称修改失败!" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

//返回方法实现
-(void)BackToLastNavi {
    [self .navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.currentName endEditing:YES];
}

@end
