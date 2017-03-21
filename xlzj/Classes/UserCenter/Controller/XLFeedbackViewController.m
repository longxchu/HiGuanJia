//
//  XLFeedbackViewController.m
//  xlzj
//
//  Created by 周绪刚 on 16/5/25.
//  Copyright © 2016年 周绪刚. All rights reserved.
//

#import "XLFeedbackViewController.h"
#import "YBPhotoListViewController.h"
#import "YBImagePickerViewController.h"
#import "YBImgePickerView.h"

@interface XLFeedbackViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,YBImagePickerViewControllerDelegate,YBImgePickerViewDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic ,strong) UITextView *questionView;
@property (weak, nonatomic) YBImgePickerView *imagePickerView;
// imageArr
@property (nonatomic ,strong) NSMutableArray *imageArrM;
// 图片名称
@property (nonatomic ,strong) NSString *fileName;
// 设置邮箱
@property (nonatomic ,strong) MFMailComposeViewController *mail;
@end

@implementation XLFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"反馈";
    self.view.backgroundColor = kBackgroundColor;
    
    [self initNaviBar];
    
    [self initContainer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self NaviBarShow:YES];
    
    self.mail = [[MFMailComposeViewController alloc]init];
    self.mail.mailComposeDelegate = self;
}

- (void)initNaviBar
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"back"];
    backBtn.frame = CGRectMake(0, 0, image.size.width/2 * 1.2, image.size.height/2 * 1.2);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setBackgroundImage:image forState:UIControlStateSelected];
    [backBtn setBackgroundImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(0, 0, 60, 45);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.backgroundColor = [UIColor clearColor];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendBtnClick
{
    NSString *suggest = self.questionView.text;
    
    self.imageArrM = [NSMutableArray array];
    __weak typeof(_imageArrM) weakArrM = self.imageArrM;
    
    for (int i = 0; i < self.imagePickerView.selected_image_array.count; i++)
    {
        YBPhotoModel *model = (YBPhotoModel *)self.imagePickerView.selected_image_array[i];
        
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        NSURL *url= model.url;
        [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
            // 使用asset来获取本地图片
            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            CGImageRef imgRef = [assetRep fullResolutionImage];
            
            UIImage *test = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:(UIImageOrientation)assetRep.orientation];
            [weakArrM addObject:test];
            
            UIImage *tempImage = weakArrM[i];
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
            [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
            NSString* timeSp = [formatter stringFromDate:[NSDate date]];
            
            if ([MFMailComposeViewController canSendMail]) {
                //设置邮件主题
                [self.mail setSubject:@"问题反馈"];
                NSArray *recipients = @[@"tech_fb@thinkrise.cn"];//531106716@qq.com tech_fb@thinkrise.cn
                [self.mail setToRecipients:recipients];
                
                NSString *body = [NSString stringWithFormat:@"<br/><b>%@<b/>",suggest];
                
                [self.mail setMessageBody:body isHTML:YES];
                
                NSData* pData = UIImageJPEGRepresentation(tempImage,  0.8) ;
                
                //设置邮件附件{mimeType:文件格式|fileName:文件名}
                self.fileName = [NSString stringWithFormat:@"%@%zd.jpg",timeSp,i];
                [self.mail addAttachmentData:pData mimeType:@"jpg" fileName:self.fileName];
                NSLog(@"fileName === %zd",self.fileName);
                
            }else{
                NSLog(@"MFMessageComposeViewController can'tSendText");
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"反馈发送不成功,请检查网络设置!"]];
                [self.mail dismissViewControllerAnimated:YES completion:nil];
            }
            
            if (i == self.imagePickerView.selected_image_array.count - 1)
            {
                [self presentViewController:self.mail animated:true completion:nil];
            }
            
        } failureBlock:^(NSError *error) {
            // 访问库文件被拒绝,则直接使用默认图片
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.domain]];
        }];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"MFMailComposeViewController MFMailComposeResultCancelled");
            [SVProgressHUD showSuccessWithStatus:@"删除成功!" maskType:SVProgressHUDMaskTypeBlack];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"MFMailComposeViewController MFMailComposeResultFailed");
            [SVProgressHUD showErrorWithStatus:@"反馈失败"];
            break;
        case MFMailComposeResultSent:
            NSLog(@"MFMailComposeViewController MFMailComposeResultSent");
            [SVProgressHUD showSuccessWithStatus:@"反馈成功!" maskType:SVProgressHUDMaskTypeBlack];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"MFMailComposeViewController MFMailComposeResultSaved");
            [SVProgressHUD showSuccessWithStatus:@"保存成功!" maskType:SVProgressHUDMaskTypeBlack];
            break;
            
        default:
            break;
    }
    [self.mail dismissViewControllerAnimated:YES completion:^{
        NSLog(@"MFMessageComposeViewController dismissViewControllerAnimated");
    }];
    
    [SVProgressHUD dismiss];
}

- (void)initContainer
{
    UILabel *questinLabel = [[UILabel alloc]init];
    [questinLabel setText:@"问题和意见"];
    [questinLabel setTextAlignment:NSTextAlignmentLeft];
    [questinLabel setTextColor:[UIColor darkGrayColor]];
    [self.view addSubview:questinLabel];
    [questinLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(30.0, 15.0, 0, 15.0) excludingEdge:ALEdgeBottom];
    [questinLabel autoSetDimension:ALDimensionHeight toSize:30.0];
    
    self.questionView = [[UITextView alloc]init];
    [self.questionView setText:@"请描述您的问题和意见"];
    [self.questionView setTextColor:[UIColor lightGrayColor]];
    self.questionView.font = [UIFont systemFontOfSize:16.0];
    self.questionView.backgroundColor = [UIColor whiteColor];
    self.questionView.textAlignment = NSTextAlignmentLeft;
    self.questionView.delegate = self;
    [self.view addSubview:self.questionView];
    [self.questionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:questinLabel withOffset:10.0];
    [self.questionView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.questionView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.questionView autoSetDimension:ALDimensionHeight toSize:150.0];
    
    UILabel *picLabel = [[UILabel alloc]init];
    // 图片 (选填,提供问题截图)
    [picLabel setText:@"图片 (选填,提供问题截图)"];
    [picLabel setTextAlignment:NSTextAlignmentLeft];
    [picLabel setTextColor:[UIColor darkGrayColor]];
    [self.view addSubview:picLabel];
    [picLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionView withOffset:20.0];
    [picLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:15.0];
    [picLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-15.0];
    [picLabel autoSetDimension:ALDimensionHeight toSize:30.0];
    
    [self imagePickerView];
}

#pragma mark - UITextViewDelegate
#pragma mark -
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请描述您的问题和意见"]) {
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        [textView setText:@"请描述您的问题和意见"];
        [textView setTextColor:[UIColor lightGrayColor]];
    }
}

-(YBImgePickerView *)imagePickerView
{
    if (_imagePickerView == nil)
    {
        YBImgePickerView *imagePickerView = [YBImgePickerView imagePickerView];
        imagePickerView.width = kMainScreenSizeWidth;
        imagePickerView.height = 150;
        imagePickerView.x = 0;
        imagePickerView.y = 280;
        imagePickerView.backgroundColor = [UIColor whiteColor];
        imagePickerView.delegate = self;
        [self.view addSubview:imagePickerView];
        _imagePickerView = imagePickerView;
    }
    return _imagePickerView;
}

#pragma mark - YBImagePickerViewControllerDelegate
- (void)YBImagePickerViewController:(YBImagePickerViewController *)imagePickerVC selectedPhotoArray:(NSArray *)selected_photo_array
{
    NSMutableArray *selected_image_array = [[NSMutableArray alloc]initWithArray:selected_photo_array];
    self.imagePickerView.selected_image_array = selected_image_array;
}

- (void)assetForURL:(NSURL *)assetURL resultBlock:(ALAssetsLibraryAssetForURLResultBlock)resultBlock failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock
{
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
