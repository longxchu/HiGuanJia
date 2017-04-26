//
//  UIView+kSimpleUI.m
//  kActivity
//
//  Created by zhaoke on 16/8/18.
//  Copyright © 2016年 zk. All rights reserved.
//

#import "UIView+kSimpleUI.h"
#import "NSObject+categoryProperty.h"

#define Degress_to_radians(d) (d * M_PI / 180)

@implementation UIView (kSimpleUI)

#pragma mark --- basic frame ---
- (CGFloat)x {
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)y {
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}
- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}
- (void)setWidth:(CGFloat)width {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), width, self.height)];
}
- (void)setHeight:(CGFloat)height {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height)];
}
- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGFloat)centerX {
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}
- (CGFloat)centerY {
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}
- (nullable UIViewController *)superVC {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
+ (instancetype)initViewFromXibAtIndex:(NSInteger)index {
    NSString *name = NSStringFromClass(self);
    UIView *xibView = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil][index];
    if(xibView == nil){
        return nil;
    }
    return xibView;
}
- (void)setBorder:(UIColor *)color width:(CGFloat)width {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}
- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}
- (void)createCornerRadiusShadowWithCornerRadius:(CGFloat)cornerRadius offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shouldRasterize = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:cornerRadius] CGPath];
    self.layer.masksToBounds = NO;
}
- (void)shakeView {
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    shake.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)], [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f)]];
    shake.autoreverses = YES;
    shake.repeatCount = 2.0f;
    shake.duration = 0.07f;
    
    [self.layer addAnimation:shake forKey:@"shake"];
}
- (void)removeAllSubviews {
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
#pragma mark --- advance UI ---
- (void)rotateViewIndefinitelyInDurationPerLoop:(NSTimeInterval)duration isClockWise:(BOOL)isClockWise {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.removedOnCompletion = FALSE;
    rotationAnimation.autoreverses = FALSE;
    rotationAnimation.toValue = [NSNumber numberWithFloat:(Degress_to_radians(isClockWise?360:0))];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:(Degress_to_radians(isClockWise?0:360))];
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:rotationAnimation forKey:@"rotationZ360"];
}
- (void)removeRotateAnimtion {
    [self.layer removeAnimationForKey:@"rorationZ360"];
}
- (void)duangShowAnimation:(void(^ _Nullable)())finishAction {
    self.alpha = 1;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
    imageView.image = [self capetureImage];
    [self.superview addSubview:imageView];
    
    CGFloat sizeOffset = 0.08, width = imageView.width, height = imageView.height ;
    CGPoint center = self.center;
    self.alpha = 0;
    imageView.alpha = 0;
    [UIView animateWithDuration:0.12 animations:^{
        imageView.size = CGSizeMake(width*(1+sizeOffset*2), height*(1+sizeOffset*2));
        imageView.center = center;
        imageView.alpha = 1;
    } completion:^(BOOL finished) {
       [UIView animateWithDuration:0.12 animations:^{
           imageView.size = CGSizeMake(width*(1-sizeOffset), height*(1-sizeOffset));
           imageView.center = center;
       } completion:^(BOOL finished) {
           [UIView animateWithDuration:0.12 animations:^{
               imageView.size = CGSizeMake(width, height);
               imageView.center = center;
           } completion:^(BOOL finished) {
               [imageView removeFromSuperview];
               self.alpha = 1;
               if(finishAction) {
                   finishAction();
               }
           }];
       }];
    }];
}
- (void)duangHideAnimation:(void(^ _Nullable)())finishAction {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.frame];
    imageView.image = [self capetureImage];
    [self.superview addSubview:imageView];
    self.alpha = 0;
    CGFloat width = self.width, height = self.height, sizeOffset = 0.1;
    CGPoint center = self.center;
    
    [UIView animateWithDuration:0.15 animations:^{
        imageView.size = CGSizeMake(width*(1+sizeOffset), height*((1+sizeOffset)));
        imageView.center = center;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            imageView.size = CGSizeMake(width*(1-sizeOffset), height*((1-sizeOffset)));
            imageView.center = center;
            imageView.alpha = 0;
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            self.alpha = 1;
            if (finishAction) {
                finishAction();
            }
        }];
    }];
}
- (NSString *)shakeAnimationKeyWithAnimation:(CAAnimation *)animation {
    return [[NSNumber numberWithUnsignedInteger:[animation hash]].description stringByAppendingString:@"animationShake"];
}
- (void)shakeAnimation:(void(^ _Nullable)())finishAction {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.delegate = self;
    rotationAnimation.removedOnCompletion = YES;
    rotationAnimation.autoreverses = YES;
    rotationAnimation.fromValue = [NSNumber numberWithFloat:Degress_to_radians(0)];
    rotationAnimation.toValue = [NSNumber numberWithFloat:Degress_to_radians(30)];
    rotationAnimation.duration = 0.3;
    rotationAnimation.repeatCount = 2;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:rotationAnimation forKey:@"animationShake"];
    CAAnimation *anim = [self.layer animationForKey:@"animationShake"];
    [self setObjectPropertyValue:finishAction forKey:[self shakeAnimationKeyWithAnimation:anim]];
}
- (void)animationDidStart:(CAAnimation *)anim {}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *key = [self shakeAnimationKeyWithAnimation:anim];
    void(^action)() = [self objectPropertyValueForKey:key];
    if(action) {
        action();
        [self removePropertyValueForKey:key];
    }
}

- (UIImage *)capetureImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (NSData *)capeturePDF {
    CGRect bounds = self.bounds;
    NSMutableData *data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if(!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

@end
