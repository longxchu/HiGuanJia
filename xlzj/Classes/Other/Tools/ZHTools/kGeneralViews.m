//
//  kGeneralViews.m
//  kActivity
//
//  Created by zhaoke on 16/8/18.
//  Copyright © 2016年 zk. All rights reserved.
//

#import "kGeneralViews.h"



@implementation kGeneralViews

@end

#pragma mark ---自定义刷新控件---

@interface LoadingView()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation LoadingView

static LoadingView *_g_LoadingView = nil;

+ (void)height {
    if(_g_LoadingView){
        _g_LoadingView.height = _kScreenWidth-64-49;
    }
}
+ (void)showLoadingWithString:(NSString *)string withView:(UIView *)view{
    if(!_g_LoadingView){
        _g_LoadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 64, _kScreenWidth, _kScreenHeight-64)];
        _g_LoadingView.backgroundColor = [UIColor darkGrayColor];
        _g_LoadingView.alpha = 0.5;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingicon"]];
        imageView.size = CGSizeMake(45, 45);
        imageView.center = _g_LoadingView.center;
        imageView.centerY -= 64;
        [_g_LoadingView addSubview:imageView];
        _g_LoadingView.bgView = imageView;
        /*
        UIImageView *centerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingicon"]];
        centerView.size = CGSizeMake(48*0.8, 8*0.8);
        centerView.center = imageView.center;
        [_g_LoadingView addSubview:centerView];
         */
        [imageView rotateViewIndefinitelyInDurationPerLoop:1 isClockWise:NO];
    }
    if(string.length > 0){
        _g_LoadingView.loadingStr = string;
    }
    if(_g_LoadingView.loadingStr.length <= 0){
        _g_LoadingView.loadingStr = @"loading...";
    }
    [LoadingView hideLoadingView];
    [view addSubview:_g_LoadingView];
}
+ (void)hideLoadingView {
    if(_g_LoadingView.superview){
        [_g_LoadingView removeFromSuperview];
    }
    [_g_LoadingView removeFromSuperview];
}
- (void)setLoadingStr:(NSString *)loadingStr {
    _loadingStr = loadingStr;
    self.loadingLabel.text = loadingStr;
}

@end

@interface ErrorView()
@property (nonatomic, strong) UILabel *strLabel;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation ErrorView
static ErrorView *_g_ErrorView = nil;

+ (void)showError:(NSString *)error {
    [self showError:error finishAction:nil];
}
+ (void)hideError {
    if (_g_ErrorView) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:_g_ErrorView.bgView.frame];
        imageView.image = [_g_ErrorView.bgView capetureImage];
        [_g_ErrorView addSubview:imageView];
        _g_ErrorView.bgView.alpha = 0;
        CGFloat width = _g_ErrorView.bgView.width;
        CGFloat height = _g_ErrorView.bgView.height;
        CGFloat sizeOffset = 0.1;
        [UIView animateWithDuration:0.15 animations:^{
            imageView.size = CGSizeMake(width*(1+sizeOffset), height*((1+sizeOffset)));
            imageView.center = _g_ErrorView.center;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                imageView.size = CGSizeMake(width*(1-sizeOffset), height*((1-sizeOffset)));
                imageView.center = _g_ErrorView.center;
                imageView.alpha = 0;
            } completion:^(BOOL finished) {
                [_g_ErrorView removeFromSuperview];
                _g_ErrorView = nil;
            }];
        }];
    }
}
+ (void)showError:(NSString *)error withShowDuration:(CGFloat)second {
    [self showError:error withShowDuration:second finishAction:nil];
}
+ (void)showError:(NSString *)error withShowDuration:(CGFloat)second finishAction:(void(^)(void))action {
    [ErrorView showError:error finishAction:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ErrorView hideError];
            if (action) {
                action();
            }
        });
    }];
}
+ (void)showError:(NSError *)error autoHideWithDefaultErrorString:(NSString *)string {
    NSString *msg = [error.userInfo objectForKey:@"msg"];
    if(msg.length <= 0) {
        msg = string;
    }
    [ErrorView showError:msg withShowDuration:1.0];
}
+ (void)showError:(NSError *)error autoHideWithDefaultErrorString:(NSString *)string finishAction:(void(^)(void))action {
    NSString *msg = [error.userInfo objectForKey:@"msg"];
    if (msg.length <= 0) {
        msg = string;
    }
    [ErrorView showError:msg withShowDuration:1.f finishAction:action];
}
+ (void)showError:(NSString *)string finishAction:(void(^)())action {
    CGFloat margin = 15;
    CGFloat marginBg = 70;
    if(!_g_ErrorView) {
        _g_ErrorView = [[ErrorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _g_ErrorView.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _kScreenWidth-2*marginBg, 60)];
//        _g_ErrorView.bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _g_ErrorView.bgView.backgroundColor = RGBAColor(41, 41, 41, 0.8);
        _g_ErrorView.bgView.center = _g_ErrorView.center;
        _g_ErrorView.bgView.layer.masksToBounds = YES;
        _g_ErrorView.bgView.layer.cornerRadius = 5;
        [_g_ErrorView addSubview:_g_ErrorView.bgView];
        
        _g_ErrorView.strLabel = [UILabel labelWithFont:15 textColor:[UIColor whiteColor]];
        _g_ErrorView.strLabel.size = CGSizeMake(_g_ErrorView.bgView.width-2*margin, _g_ErrorView.bgView.height);
        _g_ErrorView.strLabel.center = CGPointMake(_g_ErrorView.bgView.width/2, _g_ErrorView.bgView.height/2);
//        _g_ErrorView.strLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _g_ErrorView.strLabel.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByWordWrapping;
        _g_ErrorView.strLabel.textAlignment = NSTextAlignmentCenter;
        _g_ErrorView.strLabel.numberOfLines = 0;
        [_g_ErrorView.bgView addSubview:_g_ErrorView.strLabel];
    }
    if(_g_ErrorView.superview) {
        [_g_ErrorView removeFromSuperview];
    }
    if(string.length > 0) {
        NSInteger maxLength = 50;
        if(string.length > maxLength) {
            string = [[string substringToIndex:maxLength] stringByAppendingString:@"..."];
        }
        _g_ErrorView.strLabel.text = string;
    }
    if(_g_ErrorView.strLabel.text.length <= 0){
        _g_ErrorView.strLabel.text = @"Error";
    }
    [[XLAppDelegate getMainWindow] addSubview:_g_ErrorView];
    CGFloat height = [_g_ErrorView.strLabel.text autoHeight:_g_ErrorView.strLabel.font width:_g_ErrorView.strLabel.width];
    CGFloat width = _g_ErrorView.bgView.width;
    _g_ErrorView.bgView.size = CGSizeMake(width,60);
    _g_ErrorView.bgView.center = _g_ErrorView.center;
    _g_ErrorView.bgView.alpha = 1;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_g_ErrorView.bgView.frame];
    imageView.image = [_g_ErrorView.bgView capetureImage];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_g_ErrorView addSubview:imageView];
    
    CGFloat sizeOffset = 0.1;
    _g_ErrorView.bgView.alpha = 0;
    imageView.size = CGSizeMake(width, height);
    imageView.center = _g_ErrorView.center;
    imageView.alpha = 0;
    [UIView animateWithDuration:0.12 animations:^{
        imageView.size = CGSizeMake(width*(1+sizeOffset*2), height*(1+sizeOffset*2));
        imageView.center = _g_ErrorView.center;
        imageView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.12 animations:^{
            imageView.size = CGSizeMake(width*(1-sizeOffset), height*(1-sizeOffset));
            imageView.center = _g_ErrorView.center;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.12 animations:^{
                imageView.size = CGSizeMake(width, height);
                imageView.center = _g_ErrorView.center;
            } completion:^(BOOL finished) {
                [imageView removeFromSuperview];
                _g_ErrorView.bgView.alpha = 1;
                if(action){
                    action();
                }
            }];
        }];
    }];
}
@end
