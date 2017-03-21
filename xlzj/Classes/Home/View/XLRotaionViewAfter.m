//
//  XLRotaionViewAfter.m
//  PanDemo
//
//  Created by 周绪刚 on 16/6/5.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLRotaionViewAfter.h"
#import <QuartzCore/QuartzCore.h>

@interface XLRotaionViewAfter ()
// 创建容器
@property (nonatomic ,strong) UIView *container;
// 父视图
@property (nonatomic ,strong) UIView *superView;
// 开始frame
@property (nonatomic ,assign) CGAffineTransform startTransform;
@end

@implementation XLRotaionViewAfter

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView
{
    if (self = [super initWithFrame:frame])
    {
        self.superView = superView;
        [self initWheel];
    }
    return self;
}

- (void)initWheel
{
    self.container = [[UIView alloc]initWithFrame:self.frame];
    self.container.userInteractionEnabled = NO;
    [self addSubview:self.container];
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.container.frame];
    bgImageView.image = [UIImage imageNamed:@"bottom_wheel_bg"];
    [self.container addSubview:bgImageView];
    
//    UIImageView *centerImageView = [[UIImageView alloc]initWithFrame:self.container.frame];
//    centerImageView.image = [UIImage imageNamed:@"top_center_dish"];
//    [self.container addSubview:centerImageView];
}

@end
