//
//  SNAction.h
//  ScinanSDK-iOS
//
//  Created by scinan on 16/5/16.
//  Copyright © 2016年 felixlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNAction : NSObject

@property (nonatomic, copy) NSString *action_id;

@property (nonatomic, copy) NSString *action_code;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *action_desc;

@property (nonatomic, copy) NSString *command;

@property (nonatomic, copy) NSString *allow_removal;

@property (nonatomic, copy) NSString *config;

@end

