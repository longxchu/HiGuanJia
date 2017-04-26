//
//  XLEnergyViewController.m
//  xlzj
//
//  Created by zhouxg on 16/5/24.
//  Copyright © 2016年 周绪刚. All rights reserved.
//
/** 周日到周六分别是 {1,2,4,8,16,32,64} 的数组 */

#import "XLEnergyViewController.h"
#import "XLLineChartView.h"
#import "XLPopoverView.h"

#define APP_REUSE_CELL @"reuseCell"

@interface XLEnergyViewController ()<UITableViewDelegate,UITableViewDataSource,NSCoding>
#pragma mark - 导航栏
#pragma mark -
/** 星期选择数组 */
@property (nonatomic ,strong) NSArray *weeks;
/** 左边选择按钮 */
@property (nonatomic ,strong) UIButton *leftButton;
/** 右边选择按钮 */
@property (nonatomic ,strong) UIButton *rightButton;
/** 日期按钮 */
@property (nonatomic ,strong) UIButton *weekButton;
/** 日期 index */
@property (nonatomic ,assign) NSInteger dayIndex;
/** 求和 */
@property (nonatomic ,assign) NSInteger sumInteger;
/** 选中的单个数字 */
@property (nonatomic ,assign) NSInteger singleInteger;

/** 解码字符串 */
@property (nonatomic, copy) NSString *base64Decode;
/** 定时器 */
@property (nonatomic ,strong) NSTimer *timer;
/** 折线图中间View */
@property (nonatomic ,strong) UIView *container;
/** 时间选择器View */
@property (nonatomic , weak) UIView *bgView;
/** 时间选择器 */
@property (nonatomic , weak) EnergyView *energyView;
/** 点数组 */
@property (nonatomic ,strong) NSMutableArray *pointsArray;
/** 表格 */
@property (nonatomic ,strong) XLLineChartView *chartView;
/** 弹出菜单 */
@property (nonatomic ,strong) XLPopoverView *popoverView;
/** 保存tableViewContainer */
@property (nonatomic ,strong) UIView *saveTableViewContainer;
/** 保存tableView */
@property (nonatomic ,strong) UITableView *saveTableView;
/** 每一行 */
@property (nonatomic ,strong) NSMutableArray *reuseArr;

/** 当前索引 */
@property (nonatomic ,assign) int currentIndex;
/** 当前值 */
@property (nonatomic ,assign) int currentValue;
/** 前面的索引 */
@property (nonatomic ,assign) NSInteger forwardIndex;
/** 后面的索引 */
@property (nonatomic ,assign) NSInteger backwardIndex;
/** 临时温度数组 */
@property (nonatomic ,strong) NSMutableArray *temperatureArrayM;
@end

@implementation XLEnergyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    
    self.reuseArr = [[NSMutableArray alloc]init];
    self.pointsArray = [[NSMutableArray alloc]init];
    
    // 1. 初始化导航栏
    [self initNaviBar];
    
    // 2. 初始化星期数组
    
    self.weeks = [NSArray arrayWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日",nil];
    
    // 初始化中间背景View
    [self initMiddleContainer];
    
    // 防止左边点击index < 0
//    [self changeMiddleButtonDisplay];
    self.leftButton.enabled = NO;
    self.dayIndex = 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getSaveModeParamMethod) userInfo:nil repeats:YES];
    [self.timer fire];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 创建保存星期View
    [self initWeekSaveTableView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)initNaviBar
{
    // 1. 设置整个控制器的View
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.image = [UIImage imageNamed:@"energy_bg"];
    [self.view addSubview:bgImageView];
    [bgImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // 2. 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"节能模式" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];//19*34
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 80);
    backBtn.frame = CGRectMake(0, 0, 100, 40);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    // 3. 保存按钮
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:kTextColor];
    saveBtn.layer.cornerRadius = 5.0;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn setImage:[UIImage imageNamed:@"save_more"] forState:UIControlStateNormal];//21*12
    saveBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 80, 12, 10);
    saveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 21);
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    [saveBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:5.0];
    [saveBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-15.0];
    [saveBtn autoSetDimensionsToSize:CGSizeMake(100.0, 30.0)];
    
    // 4. 右边日期选择按钮
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightButton];
    [self.rightButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:5.0];
    [self.rightButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-140.0];
    [self.rightButton autoSetDimensionsToSize:CGSizeMake(23, 27)];
    
    // 5. 中间日期选择按钮
    self.weekButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.weekButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self.weekButton setImage:[UIImage imageNamed:@"save_more"] forState:UIControlStateNormal];
    self.weekButton.imageEdgeInsets = UIEdgeInsetsMake(12, 80, 12, 10);
    self.weekButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 21);
    [self.weekButton addTarget:self action:@selector(weekBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.weekButton setTitle:@"星期一" forState:UIControlStateNormal];
    [self.view addSubview:self.weekButton];
    [self.weekButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:5.0];
    [self.weekButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-170.0];
    [self.weekButton autoSetDimensionsToSize:CGSizeMake(100.0, 30.0)];
    
    // 6. 左边日期选择按钮
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];//23*27
    [self.leftButton setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftButton];
    [self.leftButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:5.0];
    [self.leftButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-280.0];
    [self.leftButton autoSetDimensionsToSize:CGSizeMake(23, 27)];
}

- (void)backBtnClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)getSaveModeParamMethod
{
    NSNumber *dayObj = [NSNumber numberWithInteger:self.dayIndex];
    NSDictionary *getSaveModeDict = @{@"strCmd":@"getSaveModeParam",@"strIndex":self.strIndex,@"dayValue":dayObj};
    NSString *getSaveModeJson = [XLDictionary dictionaryToJson:getSaveModeDict];
    NSString *getSaveModeCommand = [linkon_op dmiJsonCommand:getSaveModeJson];
    
    // 2. 根据 retData 找到对应数组
    NSDictionary *getSaveModeCommandDict = [XLDictionary dictionaryWithJsonString:getSaveModeCommand];
    self.base64Decode = [getSaveModeCommandDict valueForKey:@"retData"];
    
    if ([self.base64Decode isEqualToString:@""])
    {
        [SVProgressHUD showWithStatus:@"正在加载数据请稍候..." maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        [SVProgressHUD dismiss];
        
        [self.timer invalidate];
        self.timer = nil;
        
        // 解码
        [self base64DecodeMethod];
        
        // 解码成功之后绘制折线图
        [self initChartView];
    }
}

/** 编码 */
- (void)base64EncodeMethod
{
    self.saveTableViewContainer.hidden = YES;
    
//    // 1. 移出最后补的一个点
//    if (self.pointsArray.count > 96)
//    {
//        [self.pointsArray removeLastObject];
//    }
    
    Byte bytes[96];
    for (int i = 0; i < 96; i++)
    {
        NSString *tempStr = self.pointsArray[i];
        NSInteger tempInt = tempStr.integerValue;
        bytes[i] = tempInt*2;
    }
    
    NSData *bytesData = [NSData dataWithBytes:bytes length:96];
    NSString *base64Encode = [CommonFunc base64EncodedStringFrom:bytesData];
    
    NSNumber *dayMask;
    if (self.sumInteger == 0)
    {
        dayMask = [NSNumber numberWithInteger:2];
    }
    else
    {
        dayMask = [NSNumber numberWithInteger:self.sumInteger];
    }
    
    NSDictionary *setSaveModeParamDict = @{@"strCmd":@"setSaveModeParam",@"strIndex":self.strIndex,@"dayMask":dayMask,@"setValue":base64Encode};
    NSString *setSaveModeParamJson = [XLDictionary dictionaryToJson:setSaveModeParamDict];
    [linkon_op dmiJsonCommand:setSaveModeParamJson];
}

/** 解码 */
- (void)base64DecodeMethod
{
    [self.pointsArray removeAllObjects];
    
    NSData *decode = [CommonFunc dataWithBase64EncodedString:self.base64Decode];
    Byte *testByte = (Byte *)[decode bytes];
    for(int i = 0;i < [decode length];i++)
    {
        NSNumber *temp = [NSNumber numberWithInt:(testByte[i]/2)];
        [self.pointsArray addObject:temp];
    }
    
    // 补齐最后一个元素
    if (decode.length > 0)
    {
        int j = (int)[decode length];
        NSNumber *last = [NSNumber numberWithInt:(testByte[j - 1]/2)];
        [self.pointsArray insertObject:last atIndex:j];
    }
    
    NSLog(@"pointArray ---- %zd,\n%@",self.pointsArray.count,self.pointsArray);
}

- (void)leftBtnClick
{
    if (self.dayIndex == 0)
    {
        self.dayIndex = 7;
    }
    
    self.dayIndex--;
    
    NSLog(@" ----------- %zd",self.dayIndex);
    self.rightButton.enabled = YES;
    
    if (self.dayIndex == 1)
    {
        NSString *week = self.weeks[0];
        [self.weekButton setTitle:week forState:UIControlStateNormal];
        self.leftButton.enabled = NO;
    }
    else if (self.dayIndex == 2)
    {
        NSString *week = self.weeks[1];
        [self.weekButton setTitle:week forState:UIControlStateNormal];
    }
    else if (self.dayIndex == 3)
    {
        NSString *week = self.weeks[2];
        [self.weekButton setTitle:week forState:UIControlStateNormal];
    }
    else if (self.dayIndex == 4)
    {
        NSString *week = self.weeks[3];
        [self.weekButton setTitle:week forState:UIControlStateNormal];
    }
    else if (self.dayIndex == 5)
    {
        NSString *week = self.weeks[4];
        [self.weekButton setTitle:week forState:UIControlStateNormal];
    }
    else if (self.dayIndex == 6)
    {
        NSString *week = self.weeks[5];
        [self.weekButton setTitle:week forState:UIControlStateNormal];
    }
    
    // 重新画图
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getSaveModeParamMethod) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)rightBtnClick
{
    self.dayIndex++;
    NSLog(@" ----------- %zd",self.dayIndex);
    self.leftButton.enabled = YES;
    
    if (self.dayIndex == 2)
    {
        NSString *week = self.weeks[1];
        [self.weekButton setTitle:week forState:UIControlStateNormal];
    }
    else if (self.dayIndex == 3)
    {
        NSString *week = self.weeks[2];
        [self.weekButton setTitle:week forState:UIControlStateNormal];
    }
    else if (self.dayIndex == 4)
    {
        NSString *week = self.weeks[3];
        [self.weekButton setTitle:week forState:UIControlStateNormal];
    }
    else if (self.dayIndex == 5)
    {
        NSString *week = self.weeks[4];
        [self.weekButton setTitle:week forState:UIControlStateNormal];
    }
    else if (self.dayIndex == 6)
    {
        NSString *week = self.weeks[5];
        [self.weekButton setTitle:week forState:UIControlStateNormal];
    }
    else if (self.dayIndex == 7)
    {
        NSString *week = self.weeks[6];
        [self.weekButton setTitle:week forState:UIControlStateNormal];
        self.rightButton.enabled = NO;
    }
    
    // 重新画图
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getSaveModeParamMethod) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)weekBtnClick:(UIButton *)button
{
    UIButton *showBtn = button;
    
    self.popoverView = [XLPopoverView new];
    self.popoverView.menuTitles = self.weeks;
    NSLog(@" ----------- %zd",self.dayIndex);
    [self.popoverView showFromView:showBtn selected:^(NSInteger index) {
        
        if (index == 0)
        {
            self.leftButton.enabled = NO;
            self.rightButton.enabled = YES;
        }
        else if (index == 6)
        {
            self.leftButton.enabled = YES;
            self.rightButton.enabled = NO;
        }
        else
        {
            self.leftButton.enabled = self.rightButton.enabled = YES;
        }
        
        
        if (index == 0)
        {
            NSString *week = self.weeks[index];
            [self.weekButton setTitle:week forState:UIControlStateNormal];
            self.dayIndex = 1;
        }
        else if (index == 1)
        {
            NSString *week = self.weeks[index];
            [self.weekButton setTitle:week forState:UIControlStateNormal];
            self.dayIndex = 2;
        }
        else if (index == 2)
        {
            NSString *week = self.weeks[index];
            [self.weekButton setTitle:week forState:UIControlStateNormal];
            self.dayIndex = 3;
        }
        else if (index == 3)
        {
            NSString *week = self.weeks[index];
            [self.weekButton setTitle:week forState:UIControlStateNormal];
            self.dayIndex = 4;
        }
        else if (index == 4)
        {
            NSString *week = self.weeks[index];
            [self.weekButton setTitle:week forState:UIControlStateNormal];
            self.dayIndex = 5;
        }
        else if (index == 5)
        {
            NSString *week = self.weeks[index];
            [self.weekButton setTitle:week forState:UIControlStateNormal];
            self.dayIndex = 6;
        }
        else if (index == 6)
        {
            NSString *week = self.weeks[index];
            [self.weekButton setTitle:week forState:UIControlStateNormal];
            self.dayIndex = 0;
        }
        
        NSLog(@" ----------- %zd",self.dayIndex);
        
        // 重新画图
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getSaveModeParamMethod) userInfo:nil repeats:YES];
        [self.timer fire];
    }];
}

/** 点击保存按钮弹出星期选择 tableView */
- (void)initWeekSaveTableView
{
    self.saveTableViewContainer = [[UIView alloc]initWithFrame:CGRectMake(kMainScreenSizeWidth - 130.0, 45.0, 120.0, 300.0)];
    self.saveTableViewContainer.backgroundColor = [UIColor lightGrayColor];
    self.saveTableViewContainer.hidden = YES;
    [self.view addSubview:self.saveTableViewContainer];
    
    self.saveTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 120.0, 260.0) style:UITableViewStyleGrouped];
    self.saveTableView.delegate = self;
    self.saveTableView.dataSource = self;
    self.saveTableView.allowsMultipleSelectionDuringEditing = YES;
    [self.saveTableViewContainer addSubview:self.saveTableView];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 260.0, 120.0, 40.0);
    [saveBtn setTitle:@"确认保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:[UIColor colorWithHex:0x10AFE6]];
    // 进行base64编码
    [saveBtn addTarget:self action:@selector(base64EncodeMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.saveTableViewContainer addSubview:saveBtn];
}

- (void)saveBtnClick:(UIButton *)button
{
    if (self.saveTableViewContainer.hidden == YES)
    {
        self.saveTableViewContainer.hidden = NO;
    }
    else if (self.saveTableViewContainer.hidden == NO)
    {
        self.saveTableViewContainer.hidden = YES;
    }
}

#pragma mark - UITableViewDelegate
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.weeks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"eneryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSString *week = self.weeks[indexPath.row];
    cell.textLabel.text = week;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    for (NSIndexPath *selectedIndexPath in self.reuseArr)
    {
        if (selectedIndexPath.row == indexPath.row)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /** 周日到周六分别是 {1,2,4,8,16,32,64} 的数组 */
    
    if (indexPath.row == 0)
    {
        self.singleInteger = 2;
    }
    else if (indexPath.row == 1)
    {
        self.singleInteger = 4;
    }
    else if (indexPath.row == 2)
    {
        self.singleInteger = 8;
    }
    else if (indexPath.row == 3)
    {
        self.singleInteger = 16;
    }
    else if (indexPath.row == 4)
    {
        self.singleInteger = 32;
    }
    else if (indexPath.row == 5)
    {
        self.singleInteger = 64;
    }
    else if (indexPath.row == 6)
    {
        self.singleInteger = 1;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        self.sumInteger += self.singleInteger;
        
        [self.reuseArr addObject:indexPath];
    }
    else if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        self.sumInteger -= self.singleInteger;
        
        [self.reuseArr addObject:indexPath];
    }
}

- (void)initMiddleContainer
{
    self.container = [[UIView alloc]init];
    self.container.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    self.container.layer.masksToBounds = YES;
    self.container.layer.cornerRadius = 5.0;
    self.container.frame = CGRectMake(10.0, 40.0, kMainScreenSizeHeight - 20.0, kMainScreenSizeWidth - 50.0);
    [self.view addSubview:self.container];
}

- (void)initChartView
{
    [self.chartView removeFromSuperview];
    
    // X 轴时间点
    NSMutableArray *XLabelsArray = [NSMutableArray arrayWithCapacity:25];
    for (int i = 0; i<25; i++)
    {
        [XLabelsArray addObject:[NSString stringWithFormat:@"%d时",i]];
    }
    
    // Y 轴温度值
    NSMutableArray *YLabelsArray = [NSMutableArray arrayWithArray:@[@"5°",@"8°",@"11°",@"14°",@"17°",@"20°",@"23°",@"26°",@"29°",@"32°",@"35°"]];
    
    self.chartView = [[XLLineChartView alloc] initWithFrame:CGRectMake(0, 0, self.container.frame.size.width, self.container.frame.size.height)];
    self.chartView.XLabels = XLabelsArray;
    self.chartView.YLabels = YLabelsArray;
    self.chartView.xNum = 24;
    [self.chartView strokeChartWithPoints:self.pointsArray];
    [self.container addSubview: self.chartView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.chartView addGestureRecognizer:tap];
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture
{
    if (self.saveTableViewContainer.hidden == NO)
    {
        self.saveTableViewContainer.hidden = YES;
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenSizeWidth, kMainScreenSizeHeight)];
    bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:bgView];
    
    CGPoint point = [gesture locationInView:self.view];
    NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
    
    self.currentIndex = (int)(point.x * 96) / (kMainScreenSizeWidth - 20);
    NSLog(@" ---- %zd",self.currentIndex);
    
    if (self.currentIndex == 97)
    {
        self.currentIndex = 96;
    }
    
    // 作为数组索引
    // 当前索引下的元素
    NSNumber *currentObj = self.pointsArray[self.currentIndex];
    self.currentValue = currentObj.intValue;
    
    // 往后遍历
    int backwardValue;
    for (int i = self.currentIndex; i < self.pointsArray.count; i++)
    {
        if (i == 96)
        {
            i--;
            break;
        }
        NSNumber *backwardObj = self.pointsArray[i + 1];
        backwardValue = backwardObj.intValue;
        if (self.currentValue != backwardValue)
        {
            self.backwardIndex = i;
            break;
        }
        if (i == 95 && self.currentValue == backwardValue)
        {
            self.backwardIndex = 95;// 24:00
        }
    }
    NSLog(@" ---- %zd",self.backwardIndex);
    
    // 往前遍历
    int forwardValue;
    int tempIndex = self.currentIndex;
    for (int i = tempIndex; i >= 0; i--)
    {
        NSNumber *forwardObj = self.pointsArray[i];
        forwardValue = forwardObj.intValue;
        
        if (self.currentValue != forwardValue)
        {
            self.forwardIndex = i;
            break;
        }
        if (i == 0 && self.currentValue == forwardValue)
        {
            self.forwardIndex = 0;
        }
    }
    NSLog(@" ---- %zd",self.forwardIndex);
    
    // 温度
    self.temperatureArrayM = [[NSMutableArray alloc]init];
    for (int i = 5; i <= 35; i++)
    {
        [self.temperatureArrayM addObject:[NSString stringWithFormat:@"%d",i]];
        if (i != 35)
        {
            [self.temperatureArrayM addObject:[NSString stringWithFormat:@"%d.5",i]];
        }
    }
    
    NSString *tempNum = [NSString stringWithFormat:@"%d",self.currentValue];
    NSUInteger temperatureIndex = [self.temperatureArrayM indexOfObject:tempNum];
    NSLog(@" ----- test :%zd",temperatureIndex);
    
    self.bgView = bgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeViewTap)];
    [bgView addGestureRecognizer:tap];
    
    EnergyView *energyView = [[EnergyView alloc]init];
    [energyView shareViewWithSelectP1:self.forwardIndex SelectP2:self.backwardIndex Temperature:temperatureIndex];
    
    energyView.frame = CGRectMake((kMainScreenSizeWidth - 300.0) / 2, (kMainScreenSizeHeight - 258.0) / 2, 300, 258);
    energyView.layer.cornerRadius = 5.0f;
    energyView.layer.masksToBounds = YES;
    [self.view addSubview:energyView];
    self.energyView = energyView;
    
    //取消按钮
    self.energyView.cancleClick = ^(){
        [self removeViewTap];
    };
    
    //保存按钮
    self.energyView.saveClick = ^(NSInteger temp){
        [self removeViewTap];
        
        NSLog(@" ----- pointArray ----- %@",self.pointsArray);
        
        NSLog(@" ------ forwardIndex ------ %zd",self.forwardIndex);        // forwardIndex
        NSLog(@" ------ backwardIndex ------ %zd",self.backwardIndex);      // backwardIndex
        NSLog(@" ------ selectedNum1 ------ %zd",self.energyView.selectedNum1);      // backwardIndex
        NSLog(@" ------ selectedNum2 ------ %zd",self.energyView.selectedNum2);      // backwardIndex
        
        NSString *string = self.energyView.selectedNum3;
        NSRange range = [string rangeOfString:@"C°"];
        string = [string substringToIndex:range.location];
        
        if (self.energyView.selectedNum2 > self.energyView.selectedNum1)
        {
            if (self.forwardIndex < self.energyView.selectedNum1)
            {
                for (NSInteger i = self.forwardIndex + 1; i < self.energyView.selectedNum2; i++)
                {
                    if (self.forwardIndex == 0)
                    {
                        [self.pointsArray replaceObjectAtIndex:self.forwardIndex withObject:string];
                    }
                    else
                    {
                        [self.pointsArray replaceObjectAtIndex:i withObject:string];
                    }
                }
            }
            else
            {
                for (NSInteger i = self.energyView.selectedNum1; i < self.energyView.selectedNum2; i++)
                {
                    if (self.energyView.selectedNum1 == 0)
                    {
                        [self.pointsArray replaceObjectAtIndex:self.energyView.selectedNum1 withObject:string];
                    }
                    else
                    {
                        [self.pointsArray replaceObjectAtIndex:i withObject:string];
                    }
                }
            }
        }
        else
        {
            if (self.forwardIndex % 2 != 0)
            {
                self.forwardIndex++;
            }
            self.energyView.selectedNum1 = (int)self.forwardIndex;
            
            for (NSInteger i = self.energyView.selectedNum1; i < self.energyView.selectedNum2; i++)
            {
                [self.pointsArray replaceObjectAtIndex:i withObject:string];
            }
            
            if (self.backwardIndex == 0 && self.energyView.selectedNum2 == 0)
            {
                for (int i = 92; i < 97; i++)
                {
                    [self.pointsArray replaceObjectAtIndex:i withObject:string];
                }
            }
        }
        
        // 重新画图
        [self initChartView];
        
        [self base64EncodeMethod];
    };
}

- (void)removeViewTap
{
    [self.energyView removeFromSuperview];
    [self.bgView removeFromSuperview];
}

#pragma mark - 限制屏幕横屏
#pragma mark -
-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

@end
