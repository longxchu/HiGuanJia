//
//  Panel.h
//  汽车表盘自定义
//
//  Created by sunchunlei on 16/3/18.
//  Copyright © 2016年 朱俊. All rights reserved.
//

#import <UIKit/UIKit.h>
// 圆盘  刻度

@interface Panel : UIView


- (instancetype)initWithFrame:(CGRect)frame;

- (void)setIndicatorTransform:(CGFloat)angle;

@end
