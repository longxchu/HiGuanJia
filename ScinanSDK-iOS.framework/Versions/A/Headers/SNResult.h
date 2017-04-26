//
//  SNResult.h
//  ZhikeAirConditioning
//
//  Created by User on 16/2/16.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNResult : NSObject

@property (nonatomic, assign) NSInteger result_code;
@property (nonatomic, copy) NSString *result_message;
@property (nonatomic, strong) id result_data;

//@property (nonatomic, copy) NSString *resultCode;
//@property (nonatomic, copy) NSString *resultMessage;
//@property (nonatomic, copy) NSData *resultData;

@end
