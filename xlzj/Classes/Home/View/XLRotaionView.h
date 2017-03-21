//
//  SMRotaryWheel.m
//  RotaryWheelProject
//
//  Created by cesarerocchi on 2/10/12.
//  Copyright (c) 2012 studiomagnolia.com. All rights reserved.

#import <UIKit/UIKit.h>

@interface XLRotaionView : UIView

@property (nonatomic, strong) UIView *container;

@property (nonatomic ,assign) CGAffineTransform startTransform;

@property (nonatomic, assign) CGFloat startScale; //只能大于5.0f,小于35.0，小数点后面只能为.5f或.0f的一位浮点型。不规则则为默认值。

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView;

- (void) initWheel;

@property (nonatomic, strong) UILabel *temperatureLabel;

@property (nonatomic ,strong) NSString *strIndex;

@end
