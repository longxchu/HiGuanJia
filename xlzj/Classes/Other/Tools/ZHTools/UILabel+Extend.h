//
//  UILabel+Extend.h
//  kActivity
//
//  Created by zhaoke on 16/8/28.
//  Copyright © 2016年 zk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extend)

/**
 *  --z 
 */
+ (UILabel *)labelWithExFont:(CGFloat)fontSize textColor:(UIColor *)textColor;
+ (UILabel *)labelWithFont:(CGFloat)fontSize textColor:(UIColor *)textColor;
+ (UILabel *)labelWithBoldFont:(CGFloat)fontSize textColor:(UIColor *)textColor;
+ (UILabel *)naviLabelWithTitle:(NSString *)title color:(UIColor *)titleColor;

+ (UILabel *)labelWithText:(NSString *)text;
/**
 *  --z 计算文字的size
 */
- (CGSize)contentSize;
/**
 *  --z 富文本
 */
- (void)setAttributedWithString:(NSString *)str attColor:(UIColor *)color attFont:(UIFont *)font;
@end
