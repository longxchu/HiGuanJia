//
//  XLHelpViewController.m
//  xlzj
//
//  Created by 周绪刚 on 16/5/26.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLHelpViewController.h"
#import <ScinanSDK-iOS/SNCircleProgress.h>

@interface XLHelpViewController ()<UIWebViewDelegate>

@end

@implementation XLHelpViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"帮助";
    self.view.backgroundColor = kBackgroundColor;
    
    [self initNaviBar];
    
    [self initWebView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self NaviBarShow:YES];
}

- (void)initNaviBar
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"back"];
    backBtn.frame = CGRectMake(0, 0, image.size.width/2 * 1.2, image.size.height/2 * 1.2);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setBackgroundImage:image forState:UIControlStateSelected];
    [backBtn setBackgroundImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initWebView
{
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenSizeWidth, kMainScreenSizeHeight - 64.0)];
    NSURL *url = [NSURL URLWithString:@"http://www.thinkrise.cn/app_service/user_manual_gen2"];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    web.delegate = self;
    [self.view addSubview:web];
}

#pragma mark - UIWebViewDelegate
#pragma mark -
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    [SVProgressHUD showWithStatus:@"正在拼命加载..." maskType:SVProgressHUDMaskTypeBlack];
}

- (void)webViewDidFinishLoad:(UIWebView *)web
{
    NSLog(@"webViewDidFinishLoad");
    [SVProgressHUD dismiss];
}

-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error
{
    NSLog(@"DidFailLoadWithError");
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.domain]];
}

@end
