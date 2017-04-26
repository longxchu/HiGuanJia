//
//  Indicator.h
//  汽车表盘自定义
//
//  Created by sunchunlei on 16/3/18.
//  Copyright © 2016年 朱俊. All rights reserved.
//

#import <UIKit/UIKit.h>

// 指示器 指针
@interface Indicator : UIView

// layer层的  锚点
@property (nonatomic, assign)CGPoint layerAnchorPoint;
- (instancetype)initWithFrame:(CGRect)frame;

@end
