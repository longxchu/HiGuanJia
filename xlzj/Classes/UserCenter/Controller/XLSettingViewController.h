//
//  XLSettingViewController.h
//  xlzj
//
//  Created by 周绪刚 on 2017/1/21.
//  Copyright © 2017年 周绪刚. All rights reserved.
//

#import "XLBaseViewContrller.h"

@interface XLSettingViewController : XLBaseViewContrller

/**
 更新 UISwitch 控件显示状态

 @param sender UISwitch
 */
- (void)updateSwitchAtIndexPath:(UISwitch *)sender;

@end
