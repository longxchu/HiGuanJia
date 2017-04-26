//
//  XLHome.h
//  xlzj
//
//  Created by 周绪刚 on 16/5/23.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLHome : NSObject
/**
 *  icon
 */
@property (nonatomic ,strong) UIImageView *iconView;
/**
 *  客厅
 */
@property (nonatomic ,strong) UILabel *roomLabel;
/**
 *  状态
 */
@property (nonatomic ,strong) UIButton *statusBtn;
/**
 *  温度
 */
@property (nonatomic ,strong) UIButton *temperatureBtn;
/**
 *  湿度
 */
@property (nonatomic ,strong) UIButton *humidityBtn;
@end
