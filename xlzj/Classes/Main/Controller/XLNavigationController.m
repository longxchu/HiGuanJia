//
//  XLNavigationController.m
//  xlzj
//
//  Created by zhouxg on 16/5/19.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLNavigationController.h"

@interface XLNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation XLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    
    [self.navigationBar setBackgroundImage:[XLTools createImageWithColor:[UIColor clearColor] needRect:CGRectMake(0.0f, 0.0f, 1.0, 64.0)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setShadowImage:[UIImage new]];
    
    NSDictionary *attris = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
    self.navigationBar.titleTextAttributes = attris;
    
    self.navigationBar.barTintColor = [UIColor colorWithHex:HDNavigationBarTintColorValue];
    
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.viewControllers.count > 1;
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(BOOL)shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
