//
//  SNCircleProgress.h
//  CircleAnimationTest
//
//  Created by User on 15/12/22.
//  Copyright © 2015年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNCircleProgress : UIView

/**
 *  底条宽度
 */
@property (nonatomic, assign) CGFloat backLineWidth;

/**
 *  进度条宽度
 */
@property (nonatomic, assign) CGFloat progressLineWidth;

/**
 *  底条颜色
 */
@property (nonatomic, strong) UIColor *backLineColor;

/**
 *  进度条颜色
 */
@property (nonatomic, strong) UIColor *progressLineColor;

/**
 *  比例（0 ~ 1）
 */
@property (nonatomic, assign) double ratio;

/**
 *  开始弧度
 */
@property (nonatomic, assign) CGFloat startAngle;

/**
 *  结束弧度
 */
@property (nonatomic, assign) CGFloat endAngle;

/**
 *  中间文本框
 */
@property (nonatomic, strong) UILabel *textLabel;

@end
