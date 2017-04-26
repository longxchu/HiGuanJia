//
//  AppDelegate+Extend.m
//  kActivity
//
//  Created by zhaoke on 16/10/26.
//  Copyright © 2016年 zk. All rights reserved.
//

#import "AppDelegate+Extend.h"

@implementation XLAppDelegate (Extend)

+ (UIWindow *)getMainWindow {
    XLAppDelegate *delegate = (XLAppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate.window;
}

@end
