//
//  kGeneralViews.h
//  kActivity
//
//  Created by zhaoke on 16/8/18.
//  Copyright © 2016年 zk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZKMainHeader.h"
#import "AppDelegate+Extend.h"
#import "UIView+kSimpleUI.h"
#import "UILabel+Extend.h"
#import "NSString+Extend.h"



@interface kGeneralViews : UIView

@end

typedef void(^actionBlock)(void);

#pragma mark ---自定义刷新控件---
@interface LoadingView: UIView

@property (nonatomic, copy) NSString *loadingStr;

+ (void)height;
+ (void)showLoadingWithString:(NSString *)string withView:(UIView *)view;
+ (void)hideLoadingView;

@end

@interface ErrorView : UIView

+ (void)showError:(NSString *)error;
+ (void)hideError;
+ (void)showError:(NSString *)error withShowDuration:(CGFloat)second;
+ (void)showError:(NSString *)error withShowDuration:(CGFloat)second finishAction:(void(^)(void))action;
+ (void)showError:(NSError *)error autoHideWithDefaultErrorString:(NSString *)string;
+ (void)showError:(NSError *)error autoHideWithDefaultErrorString:(NSString *)string finishAction:(void(^)(void))action;

@end
