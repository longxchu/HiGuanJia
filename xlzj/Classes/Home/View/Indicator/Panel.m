//
//  Panel.m
//  汽车表盘自定义
//
//  Created by sunchunlei on 16/3/18.
//  Copyright © 2016年 朱俊. All rights reserved.
//

#import "Panel.h"
#import "Indicator.h"

// indicator的宽和高
static const CGFloat indicatorWidth = 39;
static const CGFloat indicatorHight = 108;

@interface Panel()

@property (nonatomic, weak)Indicator *indicator;

@end

@implementation Panel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self customViewWithFrame:frame];
    }
    return self;
}


- (void)customViewWithFrame:(CGRect)frame
{
    //指针视图
    Indicator *indicatorView = [[Indicator alloc] initWithFrame:CGRectMake(0, 0, indicatorWidth, indicatorHight)];
    // 在这里我们确定锚点的位置
    CGPoint anchorPoint = indicatorView.layerAnchorPoint;
    NSValue *value = [NSValue valueWithCGPoint:anchorPoint];
    if (value) {
        indicatorView.layer.anchorPoint = anchorPoint;
        indicatorView.layer.position = CGPointMake(CGRectGetWidth(frame) / 2, CGRectGetHeight(frame) / 2);
        
        indicatorView.transform = CGAffineTransformMakeRotation(- M_PI_2 * 4 / 3);
        [self addSubview:indicatorView];
        self.indicator = indicatorView;
    }
}

- (void)setIndicatorTransform:(CGFloat)angle
{
    self.indicator.transform = CGAffineTransformMakeRotation(angle);
}
@end
