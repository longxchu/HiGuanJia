//
//  ZKMainHeader.h
//  kActivity
//
//  Created by zhaoke on 16/8/18.
//  Copyright © 2016年 zk. All rights reserved.
//

#ifndef ZKMainHeader_h
#define ZKMainHeader_h

#pragma mark - weak & strong

#define WeakS(weakSelf) __weak __typeof(&*self)weakSelf = self;
#define StrongS(weakSelf) __strong __typeof(&*self)strongSelf = weakSelf;
#define WeakObj(o) __weak typeof(o) o##Weak = o;


#pragma mark - frame

// 非横屏
#define _kScreenWidth [UIScreen mainScreen].bounds.size.width
#define _kScreenHeight [UIScreen mainScreen].bounds.size.height
#define isIphone4 _kScreenWidth == 480
#define isIphone5 _kScreenWidth == 568
#define isIphone6 _kScreenWidth == 667
#define isIphone6plus _kScreenWidth == 736

#pragma mark - color

#define RGBColor(a, b, c) [UIColor colorWithRed:(a)/255.0 green:(b)/255.0 blue:(c)/255.0 alpha:1]
#define RGBAColor(a, b, c, d) [UIColor colorWithRed:(a)/255.0 green:(b)/255.0 blue:(c)/255.0 alpha:(d)]
#define hexColor(colorV) [UIColor colorWithHexColorString:@#colorV]
#define hexColorAlpha(colorV,a) [UIColor colorWithHexColorString:@#colorV alpha:a];

#pragma mark - for short

#define _kApplication [UIApplication sharedApplication]
#define _kKeyWindow [[UIApplication sharedApplication].keyWindow
#define _kAppDelegate [UIApplication sharedApplication].delegate
#define _kUserDefaults [NSUserDefaults standardUserDefaults]
#define _kNotificationCenter [NSNotificationCenter defaultCenter]

#define _kPathTemp NSTemporaryDirectory()
#define _kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define _kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]




#endif /* ZKMainHeader_h */
