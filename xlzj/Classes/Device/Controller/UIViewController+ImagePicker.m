//
//  UIViewController+ImagePicker.m
//
//  Created by dd.
//  Copyright (c) 2014年. All rights reserved.
//

#define ActionSheetTag              250

#import "UIViewController+ImagePicker.h"
#import <objc/runtime.h>
#import <CoreGraphics/CoreGraphics.h>

@interface UIViewController()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) ImagePickerBlock imageBlock;

@end

static const void *ImagePickerBlockKey = &ImagePickerBlockKey;

@implementation UIViewController (ImagePicker)

#pragma mark - 存取block

-(void)setImageBlock:(ImagePickerBlock)imageBlock
{
    objc_setAssociatedObject(self, ImagePickerBlockKey, imageBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(ImagePickerBlock)imageBlock
{
    return objc_getAssociatedObject(self, ImagePickerBlockKey);
}

#pragma mark -

/**
 *  使用相机或相册获取图片
 *
 *  @param block 参数为获取的图片/图片名称/图片路径
 */
- (void) imageByCameraAndPhotosAlbumWithActionSheetUsingBlock:(ImagePickerBlock)imageBlock
{
    self.imageBlock = imageBlock;
    
    UIActionSheet *as = nil;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        as = [[UIActionSheet alloc] initWithTitle:@"选择"
                                         delegate:self
                                cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                                otherButtonTitles:@"相机",@"从相册选择", nil];
    } else {
        
        as = [[UIActionSheet alloc] initWithTitle:@"选择"
                                         delegate:self
                                cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                                otherButtonTitles:@"从相册选择", nil];
    }
    
    as.tag = ActionSheetTag;
    
    if (self.tabBarController)
    {
        [as showFromTabBar:self.tabBarController.tabBar];
    }else{
        [as showInView:self.view];
    }
    
}

#pragma mark - Action Sheet Delegate

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ActionSheetTag)
    {
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex)
            {
                case 2:
                    // 取消
                    return;
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                default:
                    break;
            }
        }
        else
        {
            if (buttonIndex == 0)
            {
                //相册
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            else
            {
                //取消
                return;
            }
        }
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - Image Picker Delegte
#pragma mark -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSString *imageName = [self imageNameWithCurrentTime];
    
    // 1. 先进行缩放
    image = [self scaleImage:image toScale:0.5];
    // 2. 再进行裁剪
    image = [self imageFromImage:image inRect:CGRectMake(15, 0, kMainScreenSizeWidth - 30, (kMainScreenSizeWidth - 30) * 2 / 3)];
    
    NSString *imagePath = [self saveImage:image withName:imageName andPath:@"images"];
    
    if (self.imageBlock)
    {
        self.imageBlock(image,imageName,imagePath);
    }
}

/** 原始图片进行缩放 */
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
                                
    return scaledImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 保存图片至沙盒

/**
 *  保存图片
 *
 *  @param currentImage 图片数据
 *  @param imageName    图片名称
 *  @param folderName   图片路径 默认在documents目录下
 *
 *  @return 图片完整路径
 */
- (NSString *) saveImage:(UIImage *)currentImage withName:(NSString *)imageName andPath:(NSString *)folderName
{
    NSData *imageData = UIImagePNGRepresentation(currentImage);
    
    // 获取沙盒目录
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    if (folderName)
    {
        documentsPath = [documentsPath stringByAppendingPathComponent:folderName];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    
    NSString *imagePath = [documentsPath stringByAppendingPathComponent:imageName];
    
    [imageData writeToFile:imagePath atomically:NO];
    
    return imagePath;
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect
{
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

/**
 *  根据当前时间生成图片名称
 *
 *  @return 图片名
 */
- (NSString *) imageNameWithCurrentTime
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSS"];

    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString *randomString = [NSString stringWithFormat:@"%d%d%d%d%d%d",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10];
    
    return [NSString stringWithFormat:@"image%@%@.png",dateString,randomString];
}

@end
