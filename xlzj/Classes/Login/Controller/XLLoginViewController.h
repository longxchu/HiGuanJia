//
//  XLLoginViewController.h
//  xlzj
//
//  Created by zhouxg on 16/5/18.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBaseViewContrller.h"

@interface XLLoginViewController : XLBaseViewContrller
@property (nonatomic ,strong) iosCloudPkt *cloud;
- (void)loginBtnClick;
@end
