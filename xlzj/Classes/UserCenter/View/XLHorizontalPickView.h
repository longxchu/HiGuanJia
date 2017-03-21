//
//  XLHorizontalPickView.h
//  xlzj
//
//  Created by zhouxg on 16/5/9.
//  Copyright © 2016年 zhouxg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLHorizontalPickViewDelegate <NSObject>
- (void)selectItemAtIndex:(NSInteger)index isChanged:(BOOL)isChanged;
@end

@interface XLHorizontalPickView : UIView
// 标题
@property (nonatomic ,strong) NSArray *itemTitles;
// 中心位置
@property (nonatomic ,assign) NSInteger centerIndex;
// 滚动速度
@property (nonatomic ,assign) BOOL acuteScroll;
// 显示指示器
@property (nonatomic ,assign) BOOL showIndicator;
@property (nonatomic ,weak) id<XLHorizontalPickViewDelegate> delegate;

- (void)updateData;
- (void)scrollToHead;
- (void)scrollToCenter;
- (void)scrollToTail;
@end
