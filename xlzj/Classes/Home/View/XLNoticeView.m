//
//  XLNoticeView.m
//  xlzj
//
//  Created by 周绪刚 on 16/6/16.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLNoticeView.h"

@interface XLNoticeView ()

@end

@implementation XLNoticeView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UILabel *noticeLabel = [[UILabel alloc]init];
    [noticeLabel setText:@"功能正在开发中..."];
    noticeLabel.backgroundColor = [UIColor redColor];
    [noticeLabel setTextAlignment:NSTextAlignmentCenter];
    [noticeLabel setTextColor:[UIColor whiteColor]];
    [noticeLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    noticeLabel.frame = CGRectMake(0, 200, 320, 60.0);
    [self addSubview:noticeLabel];
}

@end
