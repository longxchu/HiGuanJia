//
//  SMRotaryWheel.m
//  RotaryWheelProject
//
//  Created by cesarerocchi on 2/10/12.
//  Copyright (c) 2012 studiomagnolia.com. All rights reserved.

#import "XLRotaionView.h"
#import <QuartzCore/QuartzCore.h>

#define SCALE 20.0f

static float deltaAngle;

static float maxTransB;

static float minTransB;

typedef NS_ENUM(NSInteger , XLRotaionViewType)
{
    XLRotaionViewTypeNormal,
    XLRotaionViewTypeMin,
    XLRotaionViewTypeMax
};

@interface XLRotaionView()

@property (nonatomic, strong) UIView *superViews;

@property (nonatomic, assign) XLRotaionViewType rotaionType;
@end

@implementation XLRotaionView

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView
{
    if (self = [super initWithFrame:frame])
    {
        self.superViews = superView;
        self.rotaionType = XLRotaionViewTypeNormal;
        [self initWheel];
    }
    return self;
}

- (void) initWheel
{
    self.container = [[UIView alloc] initWithFrame:self.frame];
    
    // 防止阴影旋转
    UIImageView *wheel = [[UIImageView alloc] initWithFrame:self.container.frame];
    wheel.image = [UIImage imageNamed:@"temp_wheel_bg"];
    wheel.userInteractionEnabled = NO;
    [self addSubview:wheel];
    
    UIImageView *dish = [[UIImageView alloc] initWithFrame:self.container.frame];
    dish.image = [UIImage imageNamed:@"scale_dish"];
    [self.container addSubview:dish];
    
    self.container.userInteractionEnabled = NO;
    [self addSubview:self.container];
}

- (void)setStartScale:(CGFloat)startScale
{
    CGAffineTransform newTrans = [self scaleConversionWithFloat:startScale];
    self.container.transform = newTrans;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIScrollView *sc = (UIScrollView *)self.superViews;
    sc.scrollEnabled = NO;
    
    UITouch *touch = [touches anyObject];
    CGPoint delta = [touch locationInView:self];
    self.startTransform = self.container.transform;
    float dx = delta.x  - self.container.center.x;
    float dy = delta.y  - self.container.center.y;
    deltaAngle = atan2(dy,dx);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    
    float dx = pt.x  - self.container.center.x;
    float dy = pt.y  - self.container.center.y;
    float ang = atan2(dy,dx);
    float angleDif = deltaAngle - ang;
    
    CGAffineTransform newTrans = CGAffineTransformRotate(self.startTransform, -angleDif);
    
    
    CGFloat newRotate = acosf(newTrans.a);
    if (newTrans.b < 0)
    {
        newRotate+= M_PI;
    }
    CGFloat newDegree = newRotate/M_PI * 180;
    float current = 20.0f - newDegree * 0.1;
    float rightCurrent = (20.0f + newDegree) * 0.1;
    
    if (self.rotaionType == XLRotaionViewTypeMax && (newTrans.b > maxTransB || newTrans.a > 0))
    {
        return;
    }
    else if (self.rotaionType == XLRotaionViewTypeMin && (newTrans.b < minTransB || newTrans.a > 0))
    {
        return;
    }
    else
    {
        self.rotaionType = XLRotaionViewTypeNormal;
    }
    if (newDegree >= 330 && newDegree <= 360)
    {
        maxTransB = newTrans.b;
        self.rotaionType = XLRotaionViewTypeMax;
        self.container.transform = CGAffineTransformMake(-0.87955634355180379, -0.47579474410483047, 0.47579474410483047, -0.87955634355180379, 0, 0);
        self.temperatureLabel.text = @"35.0°";
        return;
    }
    else if (newDegree >= 150 && newDegree <= 180)
    {
        minTransB = newTrans.b;
        self.rotaionType = XLRotaionViewTypeMin;
        self.container.transform = CGAffineTransformMake(-0.86407125656382189, 0.50336950998269459, -0.50336950998269459, -0.86407125656382189, 0, 0);
        self.temperatureLabel.text = @"5.0°";
        return;
    }
    self.container.transform = newTrans;
//    NSLog(@"====%f,%f,%f,%f=====",self.container.transform.a,self.container.transform.b,self.container.transform.c,self.container.transform.d);
    
    if (newDegree < 180.0f && current > 5)
    {   //右旋转
        
        // 浮点数分解为整数和小数 modff
        float decimalNum = modff(current, &current);
        
        if (decimalNum >= 0.5)
        {
            decimalNum = 0.5;
        }
        else
        {
            decimalNum = 0.0;
        }
        // 四舍五入
        float roundNum = roundf(current);
        
        float totalNum = roundNum + decimalNum;
        
        self.temperatureLabel.text = [NSString stringWithFormat:@"%0.1f°",totalNum];
    }
    else if(rightCurrent < 35.0f)
    {   //左旋转
        if (current < 5.0f && rightCurrent < 20.0f)
        {
            self.temperatureLabel.text = @"5.0°";
        }
        else
        {
            // 浮点数分解为整数和小数 modff
            float decimalNum = modff(rightCurrent, &rightCurrent);
            
            if (decimalNum >= 0.5)
            {
                decimalNum = 0.5;
            }
            else
            {
                decimalNum = 0.0;
            }
            // 四舍五入
            float roundNum = roundf(rightCurrent);
            
            float totalNum = roundNum + decimalNum;
            
            self.temperatureLabel.text = [NSString stringWithFormat:@"%0.1f°",totalNum];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    XLAppDelegate *appDelegate = (XLAppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.canSoundPlay)
    {
        // 开始播放\继续播放
        [appDelegate.player play];
        [ECMusicTool stopMusic:appDelegate.songs[0]];
        [ECMusicTool playMusic:appDelegate.songs[0]];
    }
    
    if (appDelegate.canVibratePlay)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    NSArray *testArr = [self.temperatureLabel.text componentsSeparatedByString:@"°"];
    NSString *value = testArr[0];
    float intValue = [value floatValue];
    

    // 必须为数字类型,不能为字符串。数值为真实值*2,即 31 表示 实际的设置温度是 15.5 度
    [XLDMITools commandStrCmdWith:@"setExprTemp" withStrIndex:self.strIndex withValue:@(intValue*2)];
    
    UIScrollView *sc = (UIScrollView *)self.superViews;
    sc.scrollEnabled = YES;
}

- (CGAffineTransform)scaleConversionWithFloat:(CGFloat)scale
{
    CGFloat a,b,c,d;
    CGAffineTransform trans;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"XLRotaionData" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSString *scaleStr = [NSString stringWithFormat:@"%.1f",scale];
    NSArray  *scaleArr = [[data objectForKey:scaleStr] componentsSeparatedByString:@","];
    
    if (scaleArr.count)
    {
        a = [scaleArr[0] floatValue];
        b = [scaleArr[1] floatValue];
        c = [scaleArr[2] floatValue];
        d = [scaleArr[3] floatValue];
    }
    else
    {
        scaleStr = [NSString stringWithFormat:@"%.1f",SCALE];
        scaleArr = [[data objectForKey:scaleStr] componentsSeparatedByString:@","];
        a = [scaleArr[0] floatValue];
        b = [scaleArr[1] floatValue];
        c = [scaleArr[2] floatValue];
        d = [scaleArr[3] floatValue];
    }
    
    trans = CGAffineTransformMake(a, b, c, d, 0.0f, 0.0f);
    
    return trans;
}


@end
