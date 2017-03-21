//
//  XLUserCenterViewController.m
//  xlzj
//
//  Created by zhouxg on 16/5/19.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLUserCenterViewController.h"
#import "XLChangeNameViewController.h"
#import "XLFeedbackViewController.h"
#import "XLAboutViewController.h"
#import "XLHelpViewController.h"
#import "XLModifyPasswordViewController.h"
#import "UIViewController+ImagePicker.h"
#import "XLLoginViewController.h"
#import "XLNavigationController.h"
#import "XLSettingViewController.h"

@interface XLUserCenterViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UIView *user_Container;
@property (nonatomic ,strong) UIButton *phone;
@property (nonatomic ,strong) UITableView *tableView;
@end

@implementation XLUserCenterViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"用户中心";
    self.view.backgroundColor = kBackgroundColor;
    
    [self initNaviBar];
    
    [self initUserCenter];
    
    [self initTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self NaviBarShow:NO];
    
    [SNAPI userInfoSuccess:^(SNUser *user) {
        NSLog(@"user %@",user);
        self.nickName = user.user_nickname;
        [self.phone setTitle:self.nickName forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        NSLog(@"error %@",error.domain);
    }];
    
    [self.phone removeFromSuperview];
    self.phone = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat Margin = (kMainScreenSizeWidth - 150)/2;
    self.phone.frame = CGRectMake(Margin, 150, 150, 30);
    // 图片相对于按钮的偏移量
    [self.phone setImage:[UIImage imageNamed:@"user_name_edit"] forState:UIControlStateNormal];
    self.phone.imageEdgeInsets = UIEdgeInsetsMake(0, 130, 0, 0);
    
    // 相对于图片的偏移量
    self.phone.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [self.phone.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [self.phone addTarget:self action:@selector(phoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.user_Container addSubview:self.phone];
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

- (void)initUserCenter
{
    self.user_Container = [[UIView alloc]init];
    self.user_Container.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.user_Container];
    [self.user_Container autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [self.user_Container autoSetDimension:ALDimensionHeight toSize:190.0];
    
    UIImageView *backgroundView = [[UIImageView alloc]init];
    UIImage *background = [UIImage imageNamed:@"user_icon_bg"];
    [backgroundView setImage:background];
    [self.user_Container addSubview:backgroundView];
    [backgroundView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    XLAppDelegate *appDelegate = (XLAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *iconImageStr = appDelegate.user.avatar;
    NSArray *nameArr = [iconImageStr componentsSeparatedByString:@"/"];
    NSString *name = [nameArr lastObject];
    if (name != nil)
    {
        UIImage *urlImage = [self getImageFromURL:iconImageStr];
        [iconBtn setImage:urlImage forState:UIControlStateNormal];
    }
    else
    {
        //load imag from Userdefaults
        NSData *imageData;
        imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_icon"];
        
        if(imageData != nil)
        {
            UIImage *icon = [NSKeyedUnarchiver unarchiveObjectWithData: imageData];
            [iconBtn setImage:icon forState:UIControlStateNormal];
        }else{
            UIImage *icon = [UIImage imageNamed:@"linkon"];
            [iconBtn setImage:icon forState:UIControlStateNormal];
        }
    }
    
    iconBtn.layer.cornerRadius = 36;
    iconBtn.layer.masksToBounds = YES;
    [iconBtn addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.user_Container addSubview:iconBtn];
    [iconBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [iconBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.user_Container withOffset:74.0];
    [iconBtn autoSetDimensionsToSize:CGSizeMake(72, 72)];
}

-(UIImage *) getImageFromURL:(NSString *)fileURL
{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

- (void)iconBtnClick:(UIButton *)button
{
    [self imageByCameraAndPhotosAlbumWithActionSheetUsingBlock:^(UIImage *image, NSString *imageName, NSString *imagePath) {
        [SNAPI userAvatar:image nickName:self.nickName success:^{
            NSData *imageData;
            // 将 UIImage 存储为 NSData
            imageData = [NSKeyedArchiver archivedDataWithRootObject:image];
            // 将 UIimage 存储到 UserDefaults
            [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"user_icon"];
            
            [button setImage:image forState:UIControlStateNormal];
            [SVProgressHUD showSuccessWithStatus:@"设置头像成功" maskType:SVProgressHUDMaskTypeGradient];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.domain]];
        }];
    }];
}

- (void)phoneBtnClick
{
    [self.phone setTitle:self.nickName forState:UIControlStateNormal];
    XLChangeNameViewController *changeName = [[XLChangeNameViewController alloc]init];
    [self.navigationController pushViewController:changeName animated:YES];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(15.0 , 220.0, kMainScreenSizeWidth - 30.0, kMainScreenSizeHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60.0;
//    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"about"];
        cell.textLabel.text = @"设置";
    }
    else if (indexPath.row == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"help"];
        cell.textLabel.text = @"帮助";
    }
    else if (indexPath.row == 2)
    {
        cell.imageView.image = [UIImage imageNamed:@"feedback"];
        cell.textLabel.text = @"反馈";
    }
    else if (indexPath.row == 3)
    {
        cell.imageView.image = [UIImage imageNamed:@"about"];
        cell.textLabel.text = @"关于";
    }
    
    [cell setNeedsLayout];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        XLSettingViewController *set = [[XLSettingViewController alloc]init];
        [self.navigationController pushViewController:set animated:YES];
    }
    else if (indexPath.row == 1)
    {
        XLHelpViewController *help = [[XLHelpViewController alloc]init];
        [self.navigationController pushViewController:help animated:YES];
    }
    else if (indexPath.row == 2)
    {
        XLFeedbackViewController *feedback = [[XLFeedbackViewController alloc]init];
        [self.navigationController pushViewController:feedback animated:YES];
    }
    else if (indexPath.row == 3)
    {
        XLAboutViewController *about = [[XLAboutViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenSizeWidth, 300.0)];
    container.backgroundColor = kBackgroundColor;
    [tableView addSubview:container];
    
    UIButton *modifyPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modifyPwdBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [modifyPwdBtn setBackgroundImage:[UIImage imageNamed:@"register"] forState:UIControlStateHighlighted];
    [modifyPwdBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    modifyPwdBtn.frame = CGRectMake(15.0, 60.0, kMainScreenSizeWidth - 60.0, 45.0);
    [modifyPwdBtn addTarget:self action:@selector(modifyPwdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:modifyPwdBtn];
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [exitButton setBackgroundImage:[UIImage imageNamed:@"register"] forState:UIControlStateHighlighted];
    [exitButton setTitle:@"退出" forState:UIControlStateNormal];
    exitButton.frame = CGRectMake(15.0, CGRectGetMaxY(modifyPwdBtn.frame) + 15.0, kMainScreenSizeWidth - 60.0, 45.0);
    [exitButton addTarget:self action:@selector(exitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:exitButton];
    
    return container;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 300.0;
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)exitButtonClick
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定要退出吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate
#pragma mark -
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }
    else if (buttonIndex == 1)
    {
        if ([SNAccount haveToken])
        {
            [SNMqtt disconnect];
            // 移除 token
            [SNAccount removeToken];
            [SVProgressHUD showSuccessWithStatus:@"退出成功" maskType:SVProgressHUDMaskTypeGradient];
            XLLoginViewController *login = [[XLLoginViewController alloc]init];
            XLNavigationController *nav = [[XLNavigationController alloc]initWithRootViewController:login];
            [self presentViewController:nav animated:NO completion:nil];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"退出失败" maskType:SVProgressHUDMaskTypeGradient];
            return;
        }
    }
}

- (void)modifyPwdBtnClick
{
    XLModifyPasswordViewController *modify = [[XLModifyPasswordViewController alloc]init];
    [self.navigationController pushViewController:modify animated:YES];
}

@end
