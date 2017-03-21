//
//  Indicator.m
//  汽车表盘自定义
//
//  Created by sunchunlei on 16/3/18.
//  Copyright © 2016年 朱俊. All rights reserved.
//
//

#import "Indicator.h"
// 指针的颜色
#define kIndicatorColor [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]

#define kOverColor [UIColor colorWithRed:0.176 green:0.251 blue:0.318 alpha:1.0]

@interface Indicator()

@end

@implementation Indicator

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self customBigCircleAndSmallCircleWithWidth:frame.size.width Height:frame.size.height];
    }
    return self;
}

- (void)customBigCircleAndSmallCircleWithWidth:(CGFloat)width Height:(CGFloat)height {
    //大圆的位置
    CGRect bigOvalRect = CGRectMake(0, height - width, width, width);
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:bigOvalRect];
    CAShapeLayer *bigOvalLayer = [CAShapeLayer layer];
    bigOvalLayer.path = ovalPath.CGPath;
    bigOvalLayer.strokeColor = kOverColor.CGColor;
    bigOvalLayer.fillColor = kOverColor.CGColor;
    
    // 小圆的路径
    CGRect smallOvalRect = CGRectInset(bigOvalRect, width / 3.0, width / 3.0);
    UIBezierPath *smallOvalPath = [UIBezierPath bezierPathWithOvalInRect:smallOvalRect];
    CAShapeLayer *smallOvalLayer = [CAShapeLayer layer];
    smallOvalLayer.path = smallOvalPath.CGPath;
    smallOvalLayer.strokeColor = kTextColor.CGColor;
    smallOvalLayer.fillColor = kTextColor.CGColor;
    
    
    //计算三角形位置和路径
    //顶点
    CGPoint topPoint = CGPointMake(width * 0.5, 0);
    
    //以一个小的半径为基准计算三角形的两个底边
    CGFloat smallRadius = width * 0.15;
    //左顶点
    CGFloat leftBottomX = CGRectGetMidX(smallOvalRect) - smallRadius * cosf(M_PI_2/90*75);
    CGFloat leftBottomY = CGRectGetMidY(smallOvalRect) - smallRadius * sinf(M_PI_2/90*75);
    
    CGPoint leftBottomPoint = CGPointMake(leftBottomX, leftBottomY);
    //右顶点
    CGFloat rightBottomX = CGRectGetMidX(smallOvalRect) - smallRadius*cosf(M_PI_2 / 90 * 105);
    CGFloat rightBottomY = CGRectGetMidY(smallOvalRect) - smallRadius * sinf(M_PI_2 / 90 * 105);
    CGPoint rightBottomPoint = CGPointMake(rightBottomX, rightBottomY);
    
    //完整绘制三角形的路径
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:topPoint];
    [trianglePath addLineToPoint:leftBottomPoint];
    [trianglePath addLineToPoint:rightBottomPoint];
    [trianglePath addLineToPoint:topPoint];
    [trianglePath closePath];
    
    //增加到layer层
    CAShapeLayer *triangleLayer = [CAShapeLayer layer];
    triangleLayer.path = trianglePath.CGPath;
    triangleLayer.strokeColor = kTextColor.CGColor;
    triangleLayer.fillColor = kTextColor.CGColor;
    triangleLayer.strokeColor = [UIColor colorWithRed:0.135 green:0.471 blue:0.930 alpha:1.000].CGColor;
    triangleLayer.fillColor = [UIColor colorWithRed:0.135 green:0.471 blue:0.930 alpha:1.000].CGColor;
    [self.layer addSublayer:triangleLayer];
    
    //最后设置锚点的位置
    self.layerAnchorPoint = CGPointMake(0.5, CGRectGetMidY(smallOvalRect)/height);
}

@end
