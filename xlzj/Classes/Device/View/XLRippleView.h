//
//  XLRippleView.h
//  xlzj
//
//  Created by zhouxg on 16/5/20.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLRippleView : UIView

/**
 *  最小半径 默认20
 */
@property(nonatomic , assign)CGFloat 	minRadius;
/**
 *  最大半径 默认50
 */
@property(nonatomic , assign)CGFloat 	maxRadius;
/**
 *  园圈的颜色 默认是灰色
 */
@property(nonatomic , strong)UIColor	*rippleColor;
/**
 *  园圈的宽度 默认是1
 */
@property(nonatomic , assign)CGFloat	rippleWidth;
/**
 *  动画时间 默认两秒
 */
@property(nonatomic , assign)CGFloat	animationTime;
/**
 *  开始动画
 */
- (void)startRippleAnimation;
/**
 *  动画一次
 */
- (void)startRippleAnimationOnce;
/**
 *  停止动画
 */
- (void)stopRippleAnimation;
@end
