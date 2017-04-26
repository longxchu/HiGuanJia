//
//  SNScene.h
//  ScinanSDK-iOS
//
//  Created by User on 16/5/14.
//  Copyright © 2016年 felixlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNScene : NSObject

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *scene_id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *scene_desc;

@property (nonatomic, copy) NSString *command;

@property (nonatomic, assign) NSInteger create_time;

@property (nonatomic, copy) NSString *room_id;

@property (nonatomic, assign) BOOL status;

@end
