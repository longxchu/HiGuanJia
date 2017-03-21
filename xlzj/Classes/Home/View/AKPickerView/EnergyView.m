//
// EnergyView.m
//  lkcsmart
//
//  Created by 崔浩楠 on 16/4/6.
//  Copyright © 2016年 thinkrise. All rights reserved.
//

#import "EnergyView.h"
#import "AKPickerView.h"

@interface EnergyView ()<AKPickerViewDataSource, AKPickerViewDelegate>

@property (nonatomic, weak) AKPickerView *pickerView;
@property (strong, nonatomic) UIView *pickerBgView;
@property (nonatomic, weak) AKPickerView *pickerView2;
@property (strong, nonatomic) UIView *pickerBgView2;
@property (nonatomic, weak) AKPickerView *pickerView3; //温度选择器
@property (strong, nonatomic) UIView *pickerBgView3;

@property (nonatomic, strong) NSMutableArray *titles1;      //时间数组1
@property (nonatomic, strong) NSMutableArray *titles2;      //时间数组2
@property (nonatomic, strong) NSMutableArray *titles3;      //温度数组
@property (assign, nonatomic) NSInteger currentTemp;        //当前温度
@end

@implementation EnergyView
IMP_INSTANCE(NSMutableArray, titles1)
IMP_INSTANCE(NSMutableArray, titles2)
IMP_INSTANCE(NSMutableArray, titles3);

- (void)shareViewWithSelectP1:(NSInteger)selectP1 SelectP2:(NSInteger)selectP2 Temperature:(NSInteger)temperature
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectP1 = selectP1;
    self.selectP2 = selectP2;
    self.selectP3 = temperature;
    
    [self setup];
}

- (void)setup
{
    // 开始时间
    UILabel *startTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 70)];
    startTime.text = @"    开始时间";
    startTime.textColor = [UIColor lightGrayColor];
    [self addSubview:startTime];
    
    self.pickerBgView = [[UIView alloc]initWithFrame:CGRectMake(100, 10, 200, 40)];
    [self addSubview:self.pickerBgView];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 70, 300, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line1];
    
    // 结束时间
    UILabel *endTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 71, 100, 70)];
    endTime.text = @"    结束时间";
    endTime.textColor = [UIColor lightGrayColor];
    [self addSubview:endTime];
    
    self.pickerBgView2 = [[UIView alloc]initWithFrame:CGRectMake(100, 81, 200, 40)];
    [self addSubview:self.pickerBgView2];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 141, 300, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line2];
    
    // 温度选择
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 142, 100, 70)];
    tempLabel.text = @"    温度选择";
    tempLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:tempLabel];
    
    self.pickerBgView3 = [[UIView alloc]initWithFrame:CGRectMake(100, 152, 200, 40)];
    [self addSubview:self.pickerBgView3];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 213, 300, 1)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line3];
    
    // 确定取消
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancleBtn.frame = CGRectMake(0, 213, 150, 45);
    [cancleBtn addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleBtn];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(150, 213, 1, 45)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line4];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    saveBtn.frame = CGRectMake(151, 213, 149, 45);
    [saveBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveBtn];
    
    [self setSubViews];
    
    [self layoutSubviewsPickers];
}

- (void)layoutSubviewsPickers
{
    if (self.pickerView.tag == 1)
    {
        if (self.selectP1 == 0)
        {
            [self.pickerView selectItem:self.selectP1 animated:YES];
        }
        else
        {
            [self.pickerView selectItem:self.selectP1 + 1 animated:YES];
        }
        NSLog(@" ---------1标签--------- %@", self.titles1[self.selectP1 + 1]);
        self.selectedNum1 = [self.titles1[self.selectP1 + 1] intValue];
        NSLog(@" ---------1实际--------- %zd", self.selectedNum1);
        
        NSArray *array = [self.titles1[self.selectP1 + 1] componentsSeparatedByString:@":"];
        for (int i = 0; i < [array count]; i++)
        {
            NSString *hour = [array objectAtIndex:0];
            NSString *minute = [array objectAtIndex:1];
            NSLog(@"hour === %@ ==== minute === %@",hour,minute);
            int testH = [hour intValue] * 4;
            int testM = [minute intValue] / 15;
            NSLog(@"testH --- %d --- testM --- %d || All --- %d",testH,testM,testH+testM);
            
            self.selectedNum1 = testH + testM;
        }
    }
    
    if (self.pickerView.tag == 2)
    {
        [self.pickerView2 selectItem:self.selectP2 animated:YES];
        NSLog(@" ---------1标签--------- %@", self.titles2[self.selectP2]);
        self.selectedNum1 = [self.titles2[self.selectP2] intValue];
        NSLog(@" ---------1实际--------- %zd", self.selectedNum1);
        
        NSArray *array = [self.titles2[self.selectP2] componentsSeparatedByString:@":"];
        for (int i = 0; i < [array count]; i++)
        {
            NSString *hour = [array objectAtIndex:0];
            NSString *minute = [array objectAtIndex:1];
            NSLog(@"hour === %@ ==== minute === %@",hour,minute);
            int testH = [hour intValue] * 4;
            int testM = [minute intValue] / 15;
            NSLog(@"testH --- %d --- testM --- %d || All --- %d",testH,testM,testH+testM);
            
            self.selectedNum1 = testH + testM;
        }
    }
    // 放到这边防止pickerView1滚动带动pickerView2滚动
    [self.pickerView2 selectItem:self.selectP2 animated:YES];
    
    NSLog(@" ---- %@",self.titles3);
    [self.pickerView3 selectItem:self.selectP3 animated:YES];
}

- (void)setSubViews
{
    //时间选择默认数据1
    for (int i = 0; i < 24; i++)
    {
        for (int j = 0; j < 60; j++)
        {
            if (j % 15 == 0 || j % 60 == 0)
            {
                NSString *hourStr = i < 10 ? [NSString stringWithFormat:@"0%d",i] : [NSString stringWithFormat:@"%d",i];
                NSString *minStr = j == 0 ? [NSString stringWithFormat:@"0%d",j] : [NSString stringWithFormat:@"%d",j];
                [self.titles1 addObject:[NSString stringWithFormat:@"%@:%@",hourStr,minStr]];
            }
        }
    }
    
    //时间选择默认数据2
    for (int i = 0; i < 24; i++)
    {
        for (int j = 0; j < 60; j++)
        {
            if (j % 15 == 0 || j % 60 == 0)
            {
                NSString *hourStr = i < 10 ? [NSString stringWithFormat:@"0%d",i] : [NSString stringWithFormat:@"%d",i];
                NSString *minStr = j == 0 ? [NSString stringWithFormat:@"0%d",j] : [NSString stringWithFormat:@"%d",j];
                [self.titles2 addObject:[NSString stringWithFormat:@"%@:%@",hourStr,minStr]];
            }
        }
    }
    
    [self.titles2 removeObjectAtIndex:0];
    NSString *hourStr = @"24";
    NSString *minStr = @"00";
    [self.titles2 addObject:[NSString stringWithFormat:@"%@:%@",hourStr,minStr]];
    
    NSLog(@" ---- %@",self.titles2);
    //温度选择默认数据
    [self.titles3 removeAllObjects];
    for (int i = 5; i <= 35; i++)
    {
        [self.titles3 addObject:[NSString stringWithFormat:@"%dC°",i]];
        if (i != 35)
        {
            [self.titles3 addObject:[NSString stringWithFormat:@"%d.5C°",i]];
        }
    }
    
    self.pickerView = [self creatPickerViewWithIndex:1 pickerView:self.pickerView];
    self.pickerView2 = [self creatPickerViewWithIndex:2 pickerView:self.pickerView2];
    self.pickerView3 = [self creatPickerViewWithIndex:3 pickerView:self.pickerView3];
    
    [self.pickerView reloadData];
    [self.pickerView2 reloadData];
    [self.pickerView3 reloadData];
}

- (void)removeViewTap
{
    [self removeFromSuperview];
}

- (AKPickerView *)creatPickerViewWithIndex:(NSInteger)index pickerView:(AKPickerView *)pickerView
{
    pickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(0, 0, self.pickerBgView.width, 50)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.tag = index;// 绑定 tag
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    switch (index)
    {
        case 1:
            [self.pickerBgView addSubview:pickerView];
            break;
        case 2:
            [self.pickerBgView2 addSubview:pickerView];
            break;
        case 3:
            [self.pickerBgView3 addSubview:pickerView];
            break;
        default:
            break;
    }
    
    pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
    pickerView.interitemSpacing = 20.0;
    pickerView.fisheyeFactor = 0.001;
    pickerView.pickerViewStyle = AKPickerViewStyle3D;
    pickerView.maskDisabled = false;
    return pickerView;
}

#pragma mark - AKPickerViewDataSource
- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    if (pickerView.tag == 3)    // 温度
    {
        return [self.titles3 count];
    }
    if (pickerView.tag == 2)
    {
        return [self.titles1 count];
    }
    return [self.titles2 count]; // 时间
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    if (pickerView.tag == 3)    // 温度
    {
        return self.titles3[item];
    }
    if (pickerView.tag == 2)
    {
        return self.titles2[item];
    }
    return self.titles1[item];   // 时间
}

#pragma mark - AKPickerViewDelegate
- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    self.pickerView = pickerView;
    
    //    NSLog(@" ------------------------------------------- Num1 : %zd",self.selectedNum1);
    //    NSLog(@" ------------------------------------------- Num2 : %zd",self.selectedNum2);
    //    NSLog(@" ------------------------------------------- item : %zd",item);
    //    NSLog(@" ------------------------------------------- selectP1 : %zd",self.selectP1);
    //    NSLog(@" ------------------------------------------- selectP2 : %zd",self.selectP2);
    
    if (pickerView.tag == 1)
    {
        self.selectP1 = item;
        //        NSLog(@" ------------------------------------------- selectP1 : %zd",self.selectP1);
        
        if (item >= self.selectedNum2)
        {
            [self.pickerView2 selectItem:item + 1 animated:YES];
        }
        
        //        NSLog(@" ---------1标签--------- %@", self.titles[item]);
        self.selectedNum1 = [self.titles1[item] intValue];
        //        NSLog(@" ---------1实际--------- %zd", self.selectedNum1);
        
        NSArray *array = [self.titles1[item] componentsSeparatedByString:@":"];
        for (int i = 0; i < [array count]; i++)
        {
            NSString *hour = [array objectAtIndex:0];
            NSString *minute = [array objectAtIndex:1];
            //            NSLog(@"hour === %@ ==== minute === %@",hour,minute);
            int testH = [hour intValue] * 4;
            int testM = [minute intValue] / 15;
            //            NSLog(@"testH --- %d --- testM --- %d || All --- %d",testH,testM,testH+testM);
            
            self.selectedNum1 = testH + testM;
        }
    }
    else if(pickerView.tag == 2)
    {
        NSLog(@" ------------------------------------------- item : %zd",item);
        NSLog(@" ------------------------------------------- selectP1 : %zd",self.selectP1);
        NSLog(@" ------------------------------------------- selectP2 : %zd",self.selectP2);
        
        //        if (item <= self.selectedNum1)
        //        {
        //            [self.pickerView selectItem:item - 1 animated:YES];
        //        }
        if ((item - self.selectP1 < 1) && item >= 1)
        {
            [self.pickerView2 selectItem:item + 1 animated:YES];
        }
        
        
        //        NSLog(@" ~~~~~~~~~2标签~~~~~~~~~ %@", self.titles[item]);
        self.selectedNum2 = [self.titles2[item] intValue];
        //        NSLog(@" ~~~~~~~~~2实际~~~~~~~~~ %zd", self.selectedNum2);
        
        NSArray *array = [self.titles2[item] componentsSeparatedByString:@":"];
        for (int i = 0; i < [array count]; i++)
        {
            NSString *hour = [array objectAtIndex:0];
            NSString *minute = [array objectAtIndex:1];
            //            NSLog(@"hour === %@ ==== minute === %@",hour,minute);
            int testH = [hour intValue] * 4;
            int testM = [minute intValue] / 15;
            //            NSLog(@"testH --- %d --- testM --- %d || All --- %d",testH,testM,testH+testM);
            
            self.selectedNum2 = testH + testM;
        }
    }
    else if(pickerView.tag == 3)
    {
        //        NSLog(@" *********3标签********* %@", self.titles3[item]);
        self.currentTemp = [self.titles3[item] integerValue];
        self.selectedNum3 = self.titles3[item];
        //        NSLog(@" *********3实际********* %@", self.selectedNum3);
    }
}

- (void)cancleClick:(UIButton *)sender
{
    if (self.cancleClick)
    {
        self.cancleClick();
    }
}

- (void)saveClick:(UIButton *)sender
{
    if (self.saveClick)
    {
        if (self.currentTemp == 0)
        {
            self.currentTemp = 5;
        }
        self.saveClick(self.currentTemp);
    }
}
@end
