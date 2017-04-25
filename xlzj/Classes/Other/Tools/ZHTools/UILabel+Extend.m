//
//  UILabel+Extend.m
//  kActivity
//
//  Created by zhaoke on 16/8/28.
//  Copyright © 2016年 zk. All rights reserved.
//

#import "UILabel+Extend.h"

@implementation UILabel (Extend)

+ (UILabel *)labelWithExFont:(CGFloat)fontSize textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}
+ (UILabel *)labelWithFont:(CGFloat)fontSize textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}
+ (UILabel *)labelWithBoldFont:(CGFloat)fontSize textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}
+ (UILabel *)naviLabelWithTitle:(NSString *)title color:(UIColor *)titleColor {
    UILabel *titleLabel = [UILabel labelWithBoldFont:20 textColor:titleColor];
    titleLabel.frame = CGRectMake(0, 0, 150, 40);
    titleLabel.text = title;
    return titleLabel;
}
+ (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = text;
    return label;
}
- (CGSize)contentSize {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    NSDictionary *attibutes = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize contentSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attibutes context:nil].size;
    return contentSize;
}
- (void)setAttributedWithString:(NSString *)str attColor:(UIColor *)color attFont:(UIFont *)font {
    NSRange range = [self.text rangeOfString:str];
    UIColor *attColor = color?color:self.textColor;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.text];
    [string addAttribute:NSForegroundColorAttributeName value:attColor range:range];
    if(font){
        [string addAttribute:NSFontAttributeName value:font range:range];
    }
    self.attributedText = string;
}
@end
