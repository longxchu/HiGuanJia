//
//  XLSettingViewController.m
//  xlzj
//
//  Created by 周绪刚 on 2017/1/21.
//  Copyright © 2017年 周绪刚. All rights reserved.
//

#import "XLSettingViewController.h"

@interface XLSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titlesArray;
    UITableView *settingTableView;
}
@end

@implementation XLSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = kBackgroundColor;
    
    [self initNaviBar];
    
    [self initData];
    
    [self initTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self NaviBarShow:YES];
}

- (void)initData
{
    titlesArray = @[@"APP操作音",@"APP操作振动"];
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
    settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kMainScreenSizeWidth, kMainScreenSizeHeight) style:UITableViewStylePlain];
    settingTableView.delegate = self;
    settingTableView.dataSource = self;
    settingTableView.rowHeight = 60.0;
    settingTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:settingTableView];
}

#pragma mark - UITableViewDelegate
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"XLSettingViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = titlesArray[indexPath.row];
    
    XLAppDelegate *appDelegate = (XLAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (indexPath.row == 0)
    {
        UISwitch *soundSwitch = [[UISwitch alloc]init];
        [soundSwitch setOn:appDelegate.canSoundPlay];
        soundSwitch.tag = 1;
        [soundSwitch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = soundSwitch;
    }
    else if(indexPath.row == 1)
    {
        UISwitch *vibrateSwitch = [[UISwitch alloc]init];
        [vibrateSwitch setOn:appDelegate.canVibratePlay];
        vibrateSwitch.tag = 2;
        [vibrateSwitch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = vibrateSwitch;
    }
    
    return cell;
}

- (void)updateSwitchAtIndexPath:(UISwitch *)sender
{
    XLAppDelegate *appDelegate = (XLAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (sender.tag == 1)    // 声音
    {
        if ([sender isOn])
        {
            appDelegate.canSoundPlay = 1;
            NSString *sound = [NSString stringWithFormat:@"%d",appDelegate.canSoundPlay];
            NSUserDefaults *soundDefaults = [NSUserDefaults standardUserDefaults];
            [soundDefaults setObject:sound forKey:@"soundControl"];
        }
        else
        {
            appDelegate.canSoundPlay = 0;
            NSString *sound = [NSString stringWithFormat:@"%d",appDelegate.canSoundPlay];
            NSUserDefaults *soundDefaults = [NSUserDefaults standardUserDefaults];
            [soundDefaults setObject:sound forKey:@"soundControl"];
        }
    }
    else if (sender.tag == 2)// 振动
    {
        if ([sender isOn])
        {
            appDelegate.canVibratePlay = 1;
            NSString *vibrate = [NSString stringWithFormat:@"%d",appDelegate.canVibratePlay];
            NSUserDefaults *vibrateDefaults = [NSUserDefaults standardUserDefaults];
            [vibrateDefaults setObject:vibrate forKey:@"vibrateControl"];
        }
        else
        {
            appDelegate.canVibratePlay = 0;
            NSString *vibrate = [NSString stringWithFormat:@"%d",appDelegate.canVibratePlay];
            NSUserDefaults *vibrateDefaults = [NSUserDefaults standardUserDefaults];
            [vibrateDefaults setObject:vibrate forKey:@"vibrateControl"];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
