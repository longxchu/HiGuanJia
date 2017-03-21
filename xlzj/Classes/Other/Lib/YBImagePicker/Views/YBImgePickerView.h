//
//  YBImgePickView.h
//  YBImagePicker
//
//  Created by 杨彬 on 15/6/26.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBImgePickerView;
@protocol YBImgePickerViewDelegate <NSObject>
@optional
- (void)imagePickerView:(YBImgePickerView *)imagePickerView changeFrame:(CGRect) frame;
@end

@interface YBImgePickerView : UIView
/** 照片控件的尺寸 默认 70 * 70*/
//@property (assign, nonatomic) CGSize photo_view_size;
/** 一行多少个 默认 4个*/
@property (assign, nonatomic) NSUInteger number_of_column;
@property (assign, nonatomic) id <YBImgePickerViewDelegate> delegate;
/** 照片数据源模型数组 */
@property (strong, nonatomic) NSMutableArray * selected_image_array;
+ (instancetype)imagePickerView;
@end
