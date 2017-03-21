//
//  XLControlViewController.h
//  xlzj
//
//  Created by zhouxg on 16/5/23.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLBaseViewContrller.h"

@interface XLControlViewController : XLBaseViewContrller
@property (nonatomic, copy) NSString *titleLabel;
@property (nonatomic ,strong) NSString *strIndex;
/** 0:恒温模式; 1:节能模式; 2:离家模式 */
@property (nonatomic ,assign) int valWorkMode;
/** 0:制热模式; 1:制冷模式; 2:换气模式 */
@property (nonatomic ,assign) int valRunMode;
/** 0:小风模式; 1:中风模式; 2:大风模式 */
@property (nonatomic ,assign) int valFanSpeed;
@end
