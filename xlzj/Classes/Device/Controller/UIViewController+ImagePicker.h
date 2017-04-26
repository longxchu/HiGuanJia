//
//  UIViewController+ImagePicker.h
//
//  Created by dd.
//  Copyright (c) 2014年. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImagePickerBlock)(UIImage *image,NSString *imageName,NSString *imagePath);

/**
 *  方便从相册或从相机获取图片
 */
@interface UIViewController (ImagePicker)

/**
 *  使用相机或相册获取图片
 *
 *  @param block 参数为获取的图片/图片名称/图片路径
 */
- (void) imageByCameraAndPhotosAlbumWithActionSheetUsingBlock:(ImagePickerBlock)imageBlock;

@end
