//
//  XLBaseViewContrller.m
//  xlzj
//
//  Created by zhouxg on 16/5/19.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLBaseViewContrller.h"

@implementation XLBaseViewContrller

-(void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)NaviBarShow:(BOOL)isShow
{
    if (isShow == YES) {
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundImage:[XLTools createImageWithColor:[UIColor clearColor] needRect:CGRectMake(0.0f, 0.0f, 1.0, 64.0)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }else if (isShow == NO){
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[XLTools createImageWithColor:[UIColor clearColor] needRect:CGRectMake(0.0f, 0.0f, 1.0, 64.0)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
