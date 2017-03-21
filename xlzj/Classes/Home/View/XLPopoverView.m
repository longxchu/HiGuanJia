//
//  XLPopoverView.m
//  IndoorNavigation
//
//  Created by zhouxg on 16/4/19.
//  Copyright © 2016年 zhouxg. All rights reserved.
//

// 字体大小
#define kPopoverFontSize 14.f
// 箭头高度
#define kArrowH 0
// 箭头宽度
#define kArrowW 0
// 边框颜色
#define kBorderColor UIColorFromRGB(0xE1E2E3)

#import "XLPopoverView.h"

@interface XLPopoverView () <UITableViewDelegate, UITableViewDataSource>
{
    PopoverBlock _selectedBlock;
    UIView *_backgroundView;
}
@property (nonatomic, retain) UITableView *tableView;
@end

@implementation XLPopoverView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tableView];
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.tableView.layer.cornerRadius  = 5.f;
    self.tableView.layer.borderColor   = [UIColor whiteColor].CGColor;
    self.tableView.layer.borderWidth   = 1.f;
}
#pragma mark - Getter
#pragma mark - 
- (UITableView *)tableView
{
    if (_tableView) return _tableView;
    
    _tableView = [UITableView new];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.rowHeight       = 38;
    _tableView.separatorColor  = [UIColor lightGrayColor];
    _tableView.scrollEnabled   = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kPopoverCellIdentifier"];
    _tableView.tableFooterView = UIView.new;
    
    return _tableView;
}
#pragma mark - UITableViewDelegate
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuTitles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kPopoverCellIdentifier"];
    cell.textLabel.font   = [UIFont systemFontOfSize:kPopoverFontSize];
    cell.textLabel.text   = [self.menuTitles objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        
        if (_selectedBlock) {
            _selectedBlock(indexPath.row);
        }
        
        [self removeFromSuperview];
    }];
}
#pragma mark - Private
#pragma mark -
/** 点击透明层隐藏 */
- (void)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        [self removeFromSuperview];
    }];
}
#pragma mark - Public
#pragma mark -
/**
 *  显示弹窗
 *
 *  @param aView    箭头指向的控件
 *  @param selected 选择完成回调
 */
- (void)showFromView:(UIView *)aView selected:(PopoverBlock)selected
{
    if (selected) _selectedBlock = selected;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 背景遮挡
    _backgroundView = UIView.new;
    _backgroundView.frame = keyWindow.bounds;
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.userInteractionEnabled = YES;
    [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    [keyWindow addSubview:_backgroundView];
    
    // 刷新数据更新contentSize
    [self.tableView reloadData];
    
    // 获取触发弹窗的按钮在window中的坐标
    CGRect triggerRect   = [aView convertRect:aView.bounds toView:keyWindow];
    // 箭头指向的中心点
    CGFloat arrowCenterX = CGRectGetMaxX(triggerRect)-CGRectGetWidth(triggerRect)/2;
    
    // 取得标题中的最大宽度
    CGFloat maxWidth = 0;
    for (id obj in self.menuTitles) {
        if ([obj isKindOfClass:[NSString class]]) {
            CGSize titleSize = [obj sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kPopoverFontSize]}];
            if (titleSize.width > maxWidth) {
                maxWidth = titleSize.width;
            }
        }
    }
    CGFloat curWidth  = ((maxWidth+80)>kMainScreenSizeWidth-30)?kMainScreenSizeWidth-30:(maxWidth+80);
    CGFloat curHeight = self.tableView.contentSize.height+kArrowH;
    CGFloat curX      = arrowCenterX-curWidth/2;
    CGFloat curY      = CGRectGetMaxY(triggerRect)+10;
    
    // 如果箭头指向点距离屏幕右边减去5px不足curWidth的一半的话就重新设置curX
    if ((kMainScreenSizeWidth-arrowCenterX-5)<curWidth/2) {
        curX = curX-(curWidth/2-(kMainScreenSizeWidth-arrowCenterX-5));
    }
    // 如果箭头指向点距离屏幕左边加上5px不足curWidth的一半的话就重新设置curX
    if (arrowCenterX+5<curWidth/2) {
        curX = curX+(curWidth/2-arrowCenterX)+5;
    }
    
    self.frame           = CGRectMake(curX, curY, curWidth, curHeight);
    self.tableView.frame = CGRectMake(0, 0, curWidth, self.tableView.contentSize.height);
    [keyWindow addSubview:self];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}
@end
