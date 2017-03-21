//
//  XLDeviceViewController.m
//  xlzj
//
//  Created by zhouxg on 16/5/20.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLDeviceViewController.h"
#import "XLAddDeviceViewController.h"
#import "XLPropertyViewController.h"
#import "XLDevice.h"

@interface XLDeviceViewController ()<UITableViewDataSource,UITableViewDelegate>
/** 数据表 */
@property (nonatomic ,strong) UITableView *tableView;
/** 定时刷新列表,调用 getDeviceList */
@property (nonatomic ,strong) NSTimer *timer;
/** 存放每行 cell 的模型 */
@property (nonatomic ,strong) NSMutableArray *deviceList;
/** 定义设备的中间变量 */
@property (nonatomic ,strong) XLDevice *device;
/** cell 图片数据 */
@property (nonatomic ,strong) NSData *imageData;

@property (nonatomic ,strong) UIButton *refreshBtn;
@end

@implementation XLDeviceViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"家里的设备";
    self.view.backgroundColor = kBackgroundColor;
    
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
    
    [self initNaviBar];
    
    [self initTableView];
    
    [self initBottomView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self NaviBarShow:YES];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getDeviceListTimerFire) userInfo:nil repeats:YES];
    [self.timer fire];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)getDeviceListTimerFire
{
    NSLog(@"------");
    
    // 1. 获取设备列表(此处不便于封装，需要用到string数据)
    NSDictionary *dict = @{@"strCmd":@"getDeviceList"};
    NSString *json = [XLDictionary dictionaryToJson:dict];
    NSString *getDeviceListCommand = [linkon_op dmiJsonCommand:json];
    
    // 2. 根据retData取到对应数组
    NSDictionary *getDeviceListRetDict = [XLDictionary dictionaryWithJsonString:getDeviceListCommand];
    NSArray *getDeviceListRetArr = [getDeviceListRetDict valueForKey:@"retData"];
    
    // 3. 字典数组转模型数组
    self.deviceList = [XLDevice mj_objectArrayWithKeyValuesArray:getDeviceListRetArr];
    
    for (int i = 0; i < self.deviceList.count; i++)
    {
        self.device = self.deviceList[i];
    }
    /** 整个 cell 显示 */
    [self.tableView reloadData];
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

- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(8, 5, kMainScreenSizeWidth - 16, kMainScreenSizeHeight - 154) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80.0;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
}

- (void)initBottomView
{
    self.refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.refreshBtn setBackgroundImage:[UIImage imageNamed:@"device_refresh_nomal"] forState:UIControlStateNormal];
    [self.refreshBtn setBackgroundImage:[UIImage imageNamed:@"device_refresh_press"] forState:UIControlStateHighlighted];
    [self.refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.refreshBtn];
    [self.refreshBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.refreshBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [self.refreshBtn autoSetDimensionsToSize:CGSizeMake(95.0, 82.0)];
    
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"device_bottom_bg"];
    [self.view addSubview:bgView];
    [bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 95.0, 0, 95.0) excludingEdge:ALEdgeTop];
    [bgView autoSetDimension:ALDimensionHeight toSize:82.0];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"device_add_nomal"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"device_add_press"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    [addBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [addBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [addBtn autoSetDimensionsToSize:CGSizeMake(95.0, 82.0)];
}

/** 刷新按钮 */
- (void)refreshBtnClick
{
    XLAppDelegate *appDelegate = (XLAppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.canSoundPlay)
    {
        // 开始播放\继续播放
        [appDelegate.player play];
        [ECMusicTool stopMusic:appDelegate.songs[1]];
        [ECMusicTool playMusic:appDelegate.songs[1]];
    }
    
    // 暂时删掉
//    [self.timer invalidate];
//    self.timer = nil;
    NSDictionary *dict = @{@"strCmd":@"refreshLocalDev"};
    NSString *json = [XLDictionary dictionaryToJson:dict];
    NSString *refreshLocalDevCommand = [linkon_op dmiJsonCommand:json];
    
    // 2. 根据retData取到对应数组
    NSDictionary *refreshLocalDevDict = [XLDictionary dictionaryWithJsonString:refreshLocalDevCommand];
    NSArray *refreshLocalDevArr = [refreshLocalDevDict valueForKey:@"retData"];
    
    // 3. 字典数组转模型数组
    self.deviceList = [XLDevice mj_objectArrayWithKeyValuesArray:refreshLocalDevArr];
    
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
}

- (void)addBtnClick
{
    XLAddDeviceViewController *addDevice = [[XLAddDeviceViewController alloc]init];
    [self.navigationController pushViewController:addDevice animated:YES];
}

#pragma mark - UITableViewDelegate
#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (self.deviceList.count > indexPath.row)  // 防止数组越界崩溃
    {
        self.device = self.deviceList[indexPath.row];
        
        UIImageView *iconView = [[UIImageView alloc]init];
        self.imageData = [MBDataCache readDataWithUrlString:self.device.strSN];
        if (self.imageData == NULL) {
            iconView.image = [UIImage imageNamed:@"livingroom"];
        }else{
            iconView.image = [UIImage imageWithData:self.imageData];
            iconView.layer.cornerRadius = 5.0;
            iconView.layer.masksToBounds = YES;
        }
        [cell.contentView addSubview:iconView];
        iconView.frame = CGRectMake(5.0, 5.0, 100.0, 70.0);
        //  这边不要打 log,否则会卡死
        //    NSLog(@"self.imageData --- %@",self.imageData);
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        [titleLabel setTextColor:[UIColor colorWithHex:0x3C3C3C]];
        titleLabel.text = self.device.strDevName;
        titleLabel.frame = CGRectMake(CGRectGetMaxX(iconView.frame) + 10.0, 15.0, kMainScreenSizeWidth - 120.0, 30.0);
        [cell.contentView addSubview:titleLabel];
        
        UILabel *descLabel = [[UILabel alloc]init];
        descLabel.frame = CGRectMake(CGRectGetMaxX(iconView.frame) + 10.0, 45.0, kMainScreenSizeWidth - 120.0, 30.0);
        [descLabel setTextColor:[UIColor colorWithHex:0x3C3C3C]];
        descLabel.font = [UIFont systemFontOfSize:13.0];
        [cell.contentView addSubview:descLabel];
        
        if ([self.device.strEdition isEqualToString:@"CS-NULL"])
        {
            descLabel.text = @"CS系列 未知版本";
        }
        else if ([self.device.strEdition isEqualToString:@"CE-NULL"])
        {
            descLabel.text = @"CE系列 未知版本";
        }
        else if ([self.device.strEdition isEqualToString:@"CS-1A0"])
        {
            descLabel.text = @"CS系列 电地暖温控器";
        }
        else if ([self.device.strEdition isEqualToString:@"CS-1B0"])
        {
            descLabel.text = @"CS系列 中央空调温控器";
        }
        else if ([self.device.strEdition isEqualToString:@"CS-1C0"])
        {
            descLabel.text = @"CS系列 水暖/中央空调二合一温控器";
        }
        else if ([self.device.strEdition isEqualToString:@"CS-1C1"])
        {
            descLabel.text = @"CS系列 水暖/中央空调二合一温控器";
        }
        else if ([self.device.strEdition isEqualToString:@"CS-1D0"])
        {
            descLabel.text = @"CS系列 水暖温控器";
        }
        else if ([self.device.strEdition isEqualToString:@"CS-1D1"])
        {
            descLabel.text = @"CS系列 壁挂炉温控器";
        }
        else if ([self.device.strEdition isEqualToString:@"CE-1A0"])
        {
            descLabel.text = @"CE系列 电地暖温控器";
        }
        else if ([self.device.strEdition isEqualToString:@"CE-1B0"])
        {
            descLabel.text = @"CE系列 中央空调温控器";
        }
        else if ([self.device.strEdition isEqualToString:@"CE-1C0"])
        {
            descLabel.text = @"CE系列 水暖/中央空调二合一温控器";
        }
        else if ([self.device.strEdition isEqualToString:@"CE-1C1"])
        {
            descLabel.text = @"CE系列 水暖/中央空调二合一温控器";
        }
        else if ([self.device.strEdition isEqualToString:@"CE-1D0"])
        {
            descLabel.text = @"CE系列 水暖温控器";
        }
        else if ([self.device.strEdition isEqualToString:@"CE-1D1"])
        {
            descLabel.text = @"CE系列 壁挂炉温控器";
        }
        else if ([self.device.strEdition isEqualToString:@"无法读取"])
        {
            descLabel.text = @"无法读取";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了 第 %zd 组 - 第 %zd 行",indexPath.section,indexPath.row);
    XLPropertyViewController *property = [[XLPropertyViewController alloc]init];
    XLDevice *tempDevice = self.deviceList[indexPath.row];
    property.device = tempDevice;
    
    [self.navigationController pushViewController:property animated:YES];
}

#pragma mark - 设置可以进行编辑
#pragma mark -
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 设置编辑的样式
#pragma mark -
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - 设置处理编辑情况
#pragma mark -
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // 1. 更新数据
        
        [self.deviceList removeObjectAtIndex:indexPath.row];
        
        // 2. 更新UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - 设置可以移动
#pragma mark -
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 处理移动的情况
#pragma mark -
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // 1. 更新数据
    NSString *title = self.deviceList[sourceIndexPath.row];
    
    [self.deviceList removeObject:title];
    
    [self.deviceList insertObject:title atIndex:destinationIndexPath.row];
    
    // 2. 更新UI
    [tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

#pragma mark - 在滑动手势删除某一行的时候，显示出更多的按钮
#pragma mark -
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 暂停定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    
    self.device = self.deviceList[indexPath.row];
    
    // 1 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        if (self.device.linkType == 1)          // linkType == 1 只删除 DMI
        {
            [XLDMITools commandStrCmdWith:@"deleteDevice" withStrIndex:self.device.strIndex withValue:@""];
        }
        else if (self.device.linkType == 0)     // linktype == 0，DMI删了，还要从司南那删掉
        {
            [XLDMITools commandStrCmdWith:@"deleteDevice" withStrIndex:self.device.strIndex withValue:@""];
            
            [SNAPI deviceDeleteWithDeviceID:self.device.devId success:^{
                [SVProgressHUD showSuccessWithStatus:@"删除设备成功!" maskType:SVProgressHUDMaskTypeBlack];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"删除设备失败!" maskType:SVProgressHUDMaskTypeBlack];
            }];
        }
        
        // 开启定时器
        [self.timer setFireDate:[NSDate distantPast]];
        
        // 1.1 更新数据
        [self.deviceList removeObjectAtIndex:indexPath.row];
        
        // 1.2 更新UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    //3 添加一个更多按钮
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了更多");
        XLPropertyViewController *property = [[XLPropertyViewController alloc]init];
        property.device = self.device;
        [self.navigationController pushViewController:property animated:YES];
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    
    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    return @[deleteRowAction,moreRowAction];
}

@end
