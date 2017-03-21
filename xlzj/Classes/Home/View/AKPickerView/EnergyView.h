//
//  EnergyView.h
//  lkcsmart
//
//  Created by 崔浩楠 on 16/4/6.
//  Copyright © 2016年 thinkrise. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnergyView : UIView

@property (copy, nonatomic) void (^cancleClick)();
@property (copy, nonatomic) void (^saveClick)(NSInteger temp);

@property (nonatomic ,assign) int selectedNum1;
@property (nonatomic ,assign) int selectedNum2;
@property (nonatomic ,strong) NSString *selectedNum3;

@property (nonatomic ,assign) NSInteger selectP1;
@property (nonatomic ,assign) NSInteger selectP2;
@property (nonatomic ,assign) NSInteger selectP3;

- (void)shareViewWithSelectP1:(NSInteger)selectP1 SelectP2:(NSInteger)selectP2 Temperature:(NSInteger)temperature;

@end
