//
//  XLPropertyViewController.m
//  xlzj
//
//  Created by zhouxg on 16/5/25.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#define WEAKSELF typeof(self) __weak weakSelf = self;

#import "XLPropertyViewController.h"
#import "UIViewController+ImagePicker.h"
#import <ScinanSDK-iOS/SNDevice.h>

@interface XLPropertyViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong) UIButton *imageBtn;
@property (nonatomic ,strong) UIView *renameContainer;
/** 新名称 */
@property (nonatomic ,strong) UITextField *currentName;

/** 定时器 */
@property (nonatomic ,strong) NSTimer *timer;

/** 滚动视图 */
@property (nonatomic ,strong) UIScrollView *scrollView;

@end

@implementation XLPropertyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设备属性";
    self.view.backgroundColor = kBackgroundColor;
    
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.contentOffset = CGPointMake(0, 1000);
    self.scrollView.frame = CGRectMake(0, 0, kMainScreenSizeWidth, kMainScreenSizeHeight);
    self.scrollView.contentSize = CGSizeMake(kMainScreenSizeWidth, kMainScreenSizeHeight);//+ 150.0
    [self.view addSubview:self.scrollView];
    
    [self initNaviBar];
    
    [self initImageView];
    
    [self initRenameView];
    
    [self initMiddleView];
    
    [self initDetailView];
    
}

- (void)getDeviceInfoTimeFire
{
    if (self.device.strIndex != nil)
    {
        NSDictionary *getDeviceInfo = @{@"strCmd":@"getDeviceInfo",@"strIndex":self.device.strIndex};
        NSString *getDeviceInfoDictJson = [XLDictionary dictionaryToJson:getDeviceInfo];
        //    [linkon_op dmiJsonCommand:getDeviceInfoDictJson];
        NSString *getDeviceInfoCommand = [linkon_op dmiJsonCommand:getDeviceInfoDictJson];
        //    NSLog(@"getDeviceInfoCommand --- \n%@",getDeviceInfoCommand);
        
        // 2. 根据retData取到对应数组
        NSDictionary *getDeviceInfoDict = [XLDictionary dictionaryWithJsonString:getDeviceInfoCommand];
        NSArray *getDeviceInfoArr = [getDeviceInfoDict valueForKey:@"retData"];
        
        self.device = [XLDevice mj_objectWithKeyValues:getDeviceInfoArr];
        NSLog(@"device = = %@",self.device);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self NaviBarShow:YES];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getDeviceInfoTimeFire) userInfo:nil repeats:YES];
    [self.timer fire];
    NSLog(@"%@",self.device);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
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
    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSData *imageData =  [MBDataCache readDataWithUrlString:self.device.strSN];
    UIImage *image = [UIImage imageNamed:@"livingroom"];
    if (imageData == NULL) {
        [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
    }else{
        [self.imageBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    }
    
    [self.imageBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    
//    self.imageBtn.frame = CGRectMake(0, 0, kMainScreenSizeWidth, image.size.height);
    self.imageBtn.frame = CGRectMake(15, 5, kMainScreenSizeWidth - 30, (kMainScreenSizeWidth - 30) * 2 / 3);
    [self.imageBtn setBackgroundColor:[UIColor clearColor]];
    self.imageBtn.layer.cornerRadius = 10.0;
    self.imageBtn.layer.masksToBounds = YES;
    [self.imageBtn addTarget:self action:@selector(chooseImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.imageBtn];
}

#pragma mark - 设置设备图片
#pragma mark -
- (void)chooseImageBtnClick
{
    [self imageByCameraAndPhotosAlbumWithActionSheetUsingBlock:^(UIImage *image, NSString *imageName, NSString *imagePath) {
        [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.imageBtn setImage:nil forState:UIControlStateNormal];
        
        self.imageBtn.frame = CGRectMake(15, 5, kMainScreenSizeWidth - 30, (kMainScreenSizeWidth - 30) * 2 / 3);
        self.imageBtn.layer.cornerRadius = 10.0;
        self.imageBtn.layer.masksToBounds = YES;
        

        if (self.imageBtn.imageView.image) {
            self.device.cellIcon = image;
            NSData *data;
            if (UIImagePNGRepresentation(self.device.cellIcon) == nil) {
                
                data = UIImageJPEGRepresentation(self.device.cellIcon, 1);
                
            } else {
                
                data = UIImagePNGRepresentation(self.device.cellIcon);
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [MBDataCache saveData:data urlString:self.device.strSN];
            });
        }
    }];
}

- (void)initRenameView
{
    self.renameContainer = [[UIView alloc]init];
    self.renameContainer.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.renameContainer];
    [self.renameContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.imageBtn withOffset:10.0];
    [self.renameContainer autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [self.renameContainer autoSetDimensionsToSize:CGSizeMake(kMainScreenSizeWidth - 30.0, 45.0)];
    
    UILabel *renameLabel = [[UILabel alloc]init];
    [renameLabel setText:@"起个名字吧:"];
    [renameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.renameContainer addSubview:renameLabel];
    [renameLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 5, 5, 5) excludingEdge:ALEdgeRight];
    [renameLabel autoSetDimension:ALDimensionWidth toSize:100.0];
    
    self.currentName = [[UITextField alloc]init];
    [self.currentName setText:self.device.strDevName];
    [self.currentName setPlaceholder:@"请输入新名字"];
    [self.currentName setTextAlignment:NSTextAlignmentLeft];
    self.currentName.delegate = self;
    self.currentName.userInteractionEnabled = NO;
    [self.renameContainer addSubview:self.currentName];
    [self.currentName autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5.0, 110.0, 5.0, 0.0)];
    
    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modifyBtn setImage:[UIImage imageNamed:@"device_edit_name"] forState:UIControlStateNormal];
    [modifyBtn setImage:[UIImage imageNamed:@"device_submit_name"] forState:UIControlStateSelected];
    [modifyBtn addTarget:self action:@selector(modifyBtnClick:) forControlEvents:UIControlEventTouchDown];
    [modifyBtn setImageEdgeInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    [self.renameContainer addSubview:modifyBtn];
    [modifyBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeLeft];
    [modifyBtn autoSetDimension:ALDimensionWidth toSize:45.0];
}

- (void)modifyBtnClick:(UIButton *)button
{
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
    
    self.currentName.userInteractionEnabled = YES;
    
    if (!button.selected)
    {
        [self.currentName becomeFirstResponder];
        button.selected = YES;
        self.currentName.userInteractionEnabled = YES;
    }
    else
    {
        button.selected = NO;
        self.currentName.userInteractionEnabled = NO;
        
        [XLDMITools commandStrCmdWith:@"setDeviceName" withStrIndex:self.device.strIndex withValue:self.currentName.text];
    }
}

- (void)initMiddleView
{
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = kTextColor;
    [self.scrollView addSubview:lineView];
    [lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.renameContainer withOffset:15.0];
    [lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:15.0];
    [lineView autoSetDimensionsToSize:CGSizeMake(4.0, 35.0)];
    
    UILabel *propertyLabel = [[UILabel alloc]init];
    [propertyLabel setText:@"产品属性"];
    [propertyLabel setTextAlignment:NSTextAlignmentLeft];
    [self.scrollView addSubview:propertyLabel];
    [propertyLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.renameContainer withOffset:15.0];
    [propertyLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lineView withOffset:5.0];
    [propertyLabel autoSetDimensionsToSize:CGSizeMake(100.0, 35.0)];
}

- (void)initDetailView
{
    UIView *container = [[UIView alloc]init];
    container.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:container];
    [container autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.renameContainer withOffset:60.0];
    [container autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:15.0];
    [container autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-15.0];
    [container autoSetDimension:ALDimensionHeight toSize:180.0];
    
    /** 产品型号 */
    UILabel *productModel = [[UILabel alloc]init];
    [productModel setText:@"产品型号:"];
    [productModel setTextAlignment:NSTextAlignmentCenter];
    [container addSubview:productModel];
    [productModel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:container withOffset:5.0];
    [productModel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:container];
    [productModel autoSetDimensionsToSize:CGSizeMake(100.0, 30.0)];
    UILabel *productModelDesc = [[UILabel alloc]init];
    [productModelDesc setText:self.device.strEdition];
    [productModelDesc setTextAlignment:NSTextAlignmentLeft];
    [container addSubview:productModelDesc];
    [productModelDesc autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 100.0, 0, 0) excludingEdge:ALEdgeBottom];
    [productModelDesc autoSetDimension:ALDimensionHeight toSize:30.0];
    
    /** 工作状态 */
    UILabel *workStatus = [[UILabel alloc]init];
    [workStatus setText:@"工作状态:"];
    [workStatus setTextAlignment:NSTextAlignmentCenter];
    [container addSubview:workStatus];
    [workStatus autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:container withOffset:40.0];
    [workStatus autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:container];
    [workStatus autoSetDimensionsToSize:CGSizeMake(100.0, 30.0)];
    UILabel *workStatusDesc = [[UILabel alloc]init];
    BOOL online = self.device.stConnect;
    NSString *isOnline = online ? @"在线" : @"离线";
    [workStatusDesc setText:isOnline];
    [workStatusDesc setTextAlignment:NSTextAlignmentLeft];
    [container addSubview:workStatusDesc];
    [workStatusDesc autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(40.0, 100.0, 0, 0) excludingEdge:ALEdgeBottom];
    [workStatusDesc autoSetDimension:ALDimensionHeight toSize:30.0];
    
    /** 设备串号 */
    UILabel *deviceNO = [[UILabel alloc]init];
    [deviceNO setText:@"设备串号:"];
    [deviceNO setTextAlignment:NSTextAlignmentCenter];
    [container addSubview:deviceNO];
    [deviceNO autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:container withOffset:75.0];
    [deviceNO autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:container];
    [deviceNO autoSetDimensionsToSize:CGSizeMake(100.0, 30.0)];
    UILabel *deviceNODesc = [[UILabel alloc]init];
    [deviceNODesc setText:self.device.strSN];
    [deviceNODesc setTextAlignment:NSTextAlignmentLeft];
    [container addSubview:deviceNODesc];
    [deviceNODesc autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(75.0, 100.0, 0, 0) excludingEdge:ALEdgeBottom];
    [deviceNODesc autoSetDimension:ALDimensionHeight toSize:30.0];
    
    /** 固件版本 */
    UILabel *firmwareVersion = [[UILabel alloc]init];
    [firmwareVersion setText:@"固件版本:"];
    [firmwareVersion setTextAlignment:NSTextAlignmentCenter];
    [container addSubview:firmwareVersion];
    [firmwareVersion autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:container withOffset:110.0];
    [firmwareVersion autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:container];
    [firmwareVersion autoSetDimensionsToSize:CGSizeMake(100.0, 30.0)];
    UILabel *firmwareVersonDesc = [[UILabel alloc]init];
    [firmwareVersonDesc setText:self.device.strVersion];
    [firmwareVersonDesc setTextAlignment:NSTextAlignmentLeft];
    [container addSubview:firmwareVersonDesc];
    [firmwareVersonDesc autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(110.0, 100.0, 0, 0) excludingEdge:ALEdgeBottom];
    [firmwareVersonDesc autoSetDimension:ALDimensionHeight toSize:30.0];
    
    /** 最新版本 */
    UILabel *newVersion = [[UILabel alloc]init];
    [newVersion setText:@"最新版本:"];
    [newVersion setTextAlignment:NSTextAlignmentCenter];
    [container addSubview:newVersion];
    [newVersion autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:container withOffset:145.0];
    [newVersion autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:container];
    [newVersion autoSetDimensionsToSize:CGSizeMake(100.0, 30.0)];
    UILabel *newVersionDesc = [[UILabel alloc]init];
    NSString *newVersionStr;
    if (self.device.fwType == 0)
    {
        newVersionStr = @"暂无";
    }
    else if (self.device.fwType == 1)
    {
        newVersionStr = [NSString stringWithFormat:@"%@(WiFi)",self.device.fwVersion];
    }
    else if (self.device.fwType == 2)
    {
        newVersionStr = [NSString stringWithFormat:@"%@(主控)",self.device.fwVersion];
    }
    else
    {
        newVersionStr = @"未知固件类型";
    }
    [newVersionDesc setText:newVersionStr];
    [newVersionDesc setTextAlignment:NSTextAlignmentLeft];
    [container addSubview:newVersionDesc];
    [newVersionDesc autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(145.0, 100.0, 0, 0) excludingEdge:ALEdgeBottom];
    [newVersionDesc autoSetDimension:ALDimensionHeight toSize:30.0];
    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateBtn setTitle:@"更新设备固件" forState:UIControlStateNormal];
    [updateBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [updateBtn setBackgroundImage:[UIImage imageNamed:@"register"] forState:UIControlStateHighlighted];
    [updateBtn addTarget:self action:@selector(updateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:updateBtn];
    [updateBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:container withOffset:20.0];
    [updateBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:15.0];
    [updateBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-15.0];
    [updateBtn autoSetDimension:ALDimensionHeight toSize:45.0];
}

- (void)updateBtnClick
{
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
    
    if (self.device.fwType == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"无固件可升级" maskType:SVProgressHUDMaskTypeBlack];
    }
    else if (self.device.fwType == 1 || self.device.fwType == 2)
    {
        [SVProgressHUD showSuccessWithStatus:@"命令已下发" maskType:SVProgressHUDMaskTypeBlack];
        
        [XLDMITools commandStrCmdWith:@"doUpgradeFw" withStrIndex:self.device.strIndex withValue:@""];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"无效的固件类型" maskType:SVProgressHUDMaskTypeBlack];
    }
}
@end
