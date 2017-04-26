//
//  XLLineChartView.m
//  LineDemo
//
//  Created by zhouxg on 16/7/25.
//  Copyright © 2016年 zhouxg. All rights reserved.
//

//range 为Y轴值的范围，设置y轴坐标数组时从小到大正序排列
#define RANGE           ([_YLabels.lastObject floatValue]-[_YLabels.firstObject floatValue])
//num为x轴显示的坐标个数，默认为_XLabels.count,改为固定值即可滑动
#define NUM             (_xNum >0? _xNum:_XLabels.count)
#define LEFT_SIDE       30.0f
#define TOP_SIDE        20.0f
#define MARGIN          10.0f
#define SCROLL_WIDTH    (self.bounds.size.width-LEFT_SIDE)
#define SCROLL_HEIGHT   self.bounds.size.height
#define CHART_WIDTH     (SCROLL_WIDTH-TOP_SIDE)
#define CHART_HEIGHT    (SCROLL_HEIGHT-LEFT_SIDE)

#import "XLLineChartView.h"

@interface XLLineChartView()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic ,strong) UIBezierPath *progressLine;

@end

@implementation XLLineChartView
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _xNum = 0;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(LEFT_SIDE, 0, SCROLL_WIDTH, SCROLL_HEIGHT)];
//    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
}
#pragma mark - setter
-(void)setYLabels:(NSMutableArray *)YLabels
{
    _YLabels = YLabels;
    CGFloat Height = CHART_HEIGHT/_YLabels.count;
    for (int i = 0; i< _YLabels.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CHART_HEIGHT -i*Height -TOP_SIDE/2, LEFT_SIDE+MARGIN, TOP_SIDE)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _YLabels[i];
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
    }
}
- (void)setXLabels:(NSMutableArray *)XLabels
{
    _XLabels = XLabels;
    CGFloat Width = CHART_WIDTH/NUM;
    _scrollView.contentSize = CGSizeMake(XLabels.count * Width+2*MARGIN, SCROLL_HEIGHT);
    for (int i = 0; i < _XLabels.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN+i*Width - 8.0, SCROLL_HEIGHT - LEFT_SIDE, Width, LEFT_SIDE)];
        label.text = _XLabels[i];
        label.font = [UIFont systemFontOfSize:10];
        [_scrollView addSubview:label];
    }
}
#pragma mark - strokeChart
- (void)strokeChartWithPoints:(NSMutableArray *)pointsArray
{
    [self addHorizontalLine];
    [self addVerticalLine];
    
    _points = pointsArray;
    
    CGFloat Width = CHART_WIDTH/NUM;
    CGFloat Height = CHART_HEIGHT/_YLabels.count;
    
    CAShapeLayer *chartLine = [CAShapeLayer layer];
    chartLine.lineCap = kCALineCapRound;
    chartLine.lineJoin = kCALineJoinBevel;
    chartLine.fillColor = [UIColor whiteColor].CGColor;
    chartLine.lineWidth = 2.0f;
    chartLine.strokeEnd = 0.0f;
    [_scrollView.layer addSublayer:chartLine];
    self.progressLine = [UIBezierPath bezierPath];
    for (int i=0; i<_points.count-1; i++)
    {
        CGFloat one = ([_points[i] floatValue]-[_YLabels[0] floatValue])/RANGE;
        CGFloat two = ([_points[i+1] floatValue]-[_YLabels[0] floatValue])/RANGE;
        CGPoint onePoint = CGPointMake(MARGIN+i*Width, (CHART_HEIGHT-Height) *(1 - one)+Height);
        CGPoint twoPoint = CGPointMake(MARGIN+(i+1)*Width, (CHART_HEIGHT-Height) *(1 - two)+Height);
        
#warning zhouxg_start
        CGPoint marginPoint = CGPointMake(MARGIN+(i+1)*Width, (CHART_HEIGHT-Height) *(1 - one)+Height);
#warning zhouxg_end
        
//        NSLog(@"%@ --- %@",NSStringFromCGPoint(onePoint),NSStringFromCGPoint(twoPoint));
        [self.progressLine moveToPoint:onePoint];
        
#warning zhouxg_start
        [self.progressLine addLineToPoint:marginPoint];
        
        [self.progressLine moveToPoint:marginPoint];
        
        [self.progressLine addLineToPoint:marginPoint];        
#warning zhouxg_end
        
        [self.progressLine addLineToPoint:twoPoint];
    }
    chartLine.path = self.progressLine.CGPath;
    chartLine.strokeColor = [UIColor colorWithRed:0.012 green:0.816 blue:0.635 alpha:1.000].CGColor;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        pathAnimation.duration = 3.0;
    pathAnimation.duration = _points.count *0.3;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    chartLine.strokeEnd = 1.0;
    
    for (int i=0; i<_points.count; i++) {
        NSString *point = _points[i];
        CGFloat one = ([_points[i] floatValue]-[_YLabels[0] floatValue])/RANGE;
        CGPoint onePoint = CGPointMake(MARGIN+i*Width, (CHART_HEIGHT-Height) *(1 - one)+Height);
        
#warning zhouxg_start
        CGPoint twoPoint = CGPointMake(MARGIN+(i+1)*Width, (CHART_HEIGHT-Height) *(1 - one)+Height);
#warning zhouxg_end
        
        [self addPoint:onePoint isShow:NO value:point.floatValue];
    }
}
#pragma mark - addPoint
- (void)addPoint:(CGPoint)point isShow:(BOOL)isHollow value:(CGFloat)value
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 8, 8)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4;
    view.layer.borderWidth = 2;
    view.layer.borderColor = [UIColor colorWithRed:0.012 green:0.816 blue:0.635 alpha:1.000].CGColor;
    
    if (isHollow)
    {
        view.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        view.backgroundColor = [UIColor colorWithRed:0.012 green:0.816 blue:0.635 alpha:1.000];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-20, point.y-20, 40, 20)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = view.backgroundColor;
        label.text = [NSString stringWithFormat:@"%.1f",value];
        [_scrollView addSubview:label];
    }
    
    [_scrollView addSubview:view];
}
#pragma mark - addLine
//横线
- (void)addHorizontalLine
{
    CGFloat Height = CHART_HEIGHT/_YLabels.count;
    for (int i=0; i< _YLabels.count; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(MARGIN, CHART_HEIGHT -i*Height)];
        [path addLineToPoint:CGPointMake(_scrollView.contentSize.width-MARGIN, CHART_HEIGHT -i*Height)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.3] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 1;
        [_scrollView.layer addSublayer:shapeLayer];
    }
}
//竖线
- (void)addVerticalLine
{
    CGFloat Height = CHART_HEIGHT/_YLabels.count;
    CGFloat Width = CHART_WIDTH/NUM;
    for (int i = 0; i <= _XLabels.count; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
//        [path moveToPoint:CGPointMake(MARGIN+i*2*Width, CHART_HEIGHT)];
//        [path addLineToPoint:CGPointMake(MARGIN+i*2*Width, Height)];
#warning zhouxg_两个小时的间隔
        [path moveToPoint:CGPointMake(MARGIN+i*2*Width, CHART_HEIGHT)];
        [path addLineToPoint:CGPointMake(MARGIN+i*2*Width, Height)];
#warning zhouxg_两个小时的间隔
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.3] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 1;
        [_scrollView.layer addSublayer:shapeLayer];
    }
}
@end
