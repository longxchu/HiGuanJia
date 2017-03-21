//
//  XLPopoverView.h
//  IndoorNavigation
//
//  Created by zhouxg on 16/4/19.
//  Copyright © 2016年 zhouxg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PopoverBlock)(NSInteger index);

@interface XLPopoverView : UIView
/** 菜单列表集合 */
@property (nonatomic, copy) NSArray *menuTitles;
/**
 *  显示弹窗
 *
 *  @param aView    箭头指向的控件
 *  @param selected 选择完成回调
 */
- (void)showFromView:(UIView *)aView selected:(PopoverBlock)selected;
@end