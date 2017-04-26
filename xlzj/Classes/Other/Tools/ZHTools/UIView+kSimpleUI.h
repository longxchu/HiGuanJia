//
//  UIView+kSimpleUI.h
//  kActivity
//
//  Created by zhaoke on 16/8/18.
//  Copyright © 2016年 zk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKMainHeader.h"

@interface UIView (kSimpleUI)<CAAnimationDelegate>
/**
 *  --z basic frame
 */
- (CGFloat)x;
- (void)setX:(CGFloat)x;
- (CGFloat)y;
- (void)setY:(CGFloat)y;
- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;
- (CGSize)size;
- (void)setSize:(CGSize)size;
- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)centerX;
- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)centerY;

- (nullable UIViewController *)superVC;

/**
 *  --z load view
 */
+ (nullable instancetype)initViewFromXibAtIndex:(NSInteger)index;
- (void)setBorder:(nullable UIColor *)color width:(CGFloat)width;
- (void)setLayerShadow:(nullable UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;
- (void)createCornerRadiusShadowWithCornerRadius:(CGFloat)cornerRadius offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius;
- (void)shakeView;

- (void)removeAllSubviews;
- (nullable UIImage *)capetureImage; // 截屏图片
- (nullable NSData *)capeturePDF;
/**
 *  --z Animation
 */
- (void)rotateViewIndefinitelyInDurationPerLoop:(NSTimeInterval)duration isClockWise:(BOOL)isClockWise;
- (void)removeRotateAnimtion;

- (void)duangShowAnimation:(void(^ _Nullable)())finishAction;
- (void)duangHideAnimation:(void(^ _Nullable)())finishAction;
- (void)shakeAnimation:(void(^ _Nullable)())finishAction;

@end
